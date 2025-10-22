// scrypt2 - Mount LUKS encrypted vault as non-root
//
// Required: cryptsetup mount sudo
// Adjust the #define variables below before compiling
//
// Install for all users:
//  sudo gcc scrypt2.c -o /usr/local/bin/scrypt
//  sudo chmod u+s /usr/local/bin/scrypt
//  sudo ln -sf /usr/local/bin/scrypt /usr/local/bin/uscrypt
// Add this to /etc/sudoers: "ALL ALL = (root) NOPASSWD: /usr/sbin/vgchange -an"
//
// Install instead for local user only:
//  sudo gcc scrypt2.c -o ~/bin/scrypt
//  sudo chmod 4501 ~/bin/scrypt
//  ln -sf ~/bin/scrypt ~/bin/uscrypt
// Add this to /etc/sudoers: "ALL ALL = (root) NOPASSWD: /usr/sbin/vgchange -an"
//
// Example integrity raid1 vault creation (matching the variables):
//  truncate -s 1G ~/vault2
//  # LUKS type 2 with integrity checksums
//  sudo cryptsetup -I hmac-sha256 luksFormat ~/vault
//  sudo cryptsetup luksOpen ~/vault vault
//  pvcreate /dev/mapper/vault
//  vgcreate vault /dev/mapper/vault
//  lvcreate -n v0 vault -l 123  # half of the extents of vg:vault2
//  lvcreate -n v1 vault -l 123  # half of the extents of vg:vault2
//  sudo mkfs.btrfs --csum xxhash /dev/mapper/vault-v0
//  sudo mount /dev/mapper/vault-v0 /home/pp/Private
//  sudo btrfs device add /dev/mapper/vault-v1 /home/pp/Private
//  sudo btrfs balance start -dconvert=raid1 -mconvert=raid1 /home/pp/Private

// Configuration parameters, change to fit
#define LUKSNAME "vault"
#define VG_LV "vault"
#define MOUNTPOINT "/home/pp/Private"
#define VAULTFILE "/data/MyDocuments/SECURE/vault"
#define MOUNT_MSG "Mounting %s on %s\n"
#define UNMOUNT_MSG "Un-mounting %s from %s\n"
// If the commands starts with UNMOUNTCHAR, it will unmount, otherwise mount
#define UNMOUNTCHAR 'u'

#include <unistd.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/wait.h>

char * replacement_environment[] = {
	"TERM=dumb",
	0
};

#define MAXARGS 6

void run(char *exec, ...) {
	char *args[MAXARGS];
	char *arg;
	int count = 0;
	va_list ap;
	args[count++] = exec;
	va_start(ap, exec);
	while ((count < MAXARGS) && (arg = va_arg(ap, char *)))
		args[count++] = arg;
	if (count >= MAXARGS) {
		fprintf(stderr, "Too many arguments\n");
		exit(127);
	}
	args[count] = 0;
	pid_t pid = fork();
	switch (pid) {
	case -1:
		perror("Fork error");
		exit(127);
	case 0:
		execve(exec, args, replacement_environment);
		perror("Exec error");
		exit(127);
	default:
		pid_t wpid;
		int status;
		for (;;) {
			wpid = wait(&status);
			if (wpid == -1) {
				perror("Wait error");
				exit(127);
			}
			if (pid == wpid)
				break;
		}
		if (status != 0) {
			if (WIFSIGNALED(status))
				fprintf(stderr, "Child %s terminated with signal %d\n", exec, WTERMSIG(status));
			else if (WIFEXITED(status))
				fprintf(stderr, "Child %s exited with status %d\n", exec, WEXITSTATUS(status));
			else fprintf(stderr, "Child %s exited with result %d\n", exec, status);
			exit(126);
		}
	}
}

void do_mount(void) {
	fprintf(stdout, MOUNT_MSG, LUKSNAME, MOUNTPOINT);
	run("/bin/mkdir", "-p", MOUNTPOINT, NULL);
	run("/bin/chmod", "0400", MOUNTPOINT, NULL);
	setreuid(0,0);
	run("/sbin/cryptsetup", "luksOpen", VAULTFILE, LUKSNAME, NULL);
	fprintf(stdout, "Decrypting "LUKSNAME"...\n");
	run("/usr/bin/sync", "-f", NULL);
	run("/usr/bin/sleep", "9", NULL); // Time is needed for lvs
	run("/bin/mount", "-o", "noatime", "/dev/mapper/"VG_LV, MOUNTPOINT, NULL);
}

void do_umount(void) {
	fprintf(stdout, UNMOUNT_MSG, LUKSNAME, MOUNTPOINT);
	setreuid(0,0);
	run("/bin/umount", MOUNTPOINT, NULL);
	run("/usr/bin/sudo", "/usr/sbin/vgchange", "-an", NULL);
	run("/sbin/cryptsetup", "luksClose", LUKSNAME, NULL);
}

int main(int argc, char **argv) {
	char const *prog = argv[0];
	char const *last_slash = strrchr(prog, '/');
	char mapper[] = "/dev/mapper/"LUKSNAME"\0###OVERFLOW-FOR-LONGER-NAMES###";
	if (argc > 1)
		for (int i = 0; i <= strlen(argv[1]); ++i)
			mapper[12+i] = argv[1][i];
	if (last_slash)
		prog = last_slash+1;
	if (prog[0] == UNMOUNTCHAR)
		do_umount();
	else do_mount();
	exit(0);
}
