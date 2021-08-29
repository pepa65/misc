// scrypt - Mount LUKS encrypted vault as non-root
// Install:
//  sudo gcc scrypt.c -o /usr/local/bin/scrypt
//  sudo chmod u+s /usr/local/bin/scrypt
//  sudo ln -s /usr/local/bin/scrypt /usr/local/bin/uscrypt
// Adjust the variables below before compiling
// Example vault:
//  truncate -s 400M /data/MyDocuments/SECURE/vault
//  sudo cryptsetup -I hmac-sha256 luksFormat /data/MyDocuments/SECURE/vault
//  sudo cryptsetup luksOpen /data/MyDocuments/SECURE/vault vault
//  sudo mkfs.ext4 /dev/mapper/vault

#include <unistd.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>

// Configuration parameters, change to fit
#define NAME "vault"
#define MOUNTPOINT "/home/pp/Private"
#define DEVICE "/data/MyDocuments/SECURE/vault"

char * replacement_environment[] = {
	"PATH=/bin:/usr/bin:/sbin:/usr/sbin",
	"HOME=/root",
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
	while ((count < MAXARGS) && (arg = va_arg(ap, char *))) {
		args[count++] = arg;
	}
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
		{
			pid_t wpid;
			int status;
			for (;;) {
				wpid = wait(&status);
				if (wpid == -1) {
					perror("Wait error");
					exit(127);
				}
				if (pid == wpid) break;
			}
			if (status != 0) {
				if (WIFSIGNALED(status)) fprintf(stderr, "Child %s terminated with signal %d\n", exec, WTERMSIG(status));
				else if (WIFEXITED(status)) fprintf(stderr, "Child %s exited with status %d\n", exec, WEXITSTATUS(status));
					else fprintf(stderr, "Child %s exited with result %d\n", exec, status);
				exit(126);
			}
			break;
		}
	}
}

void do_mount(void) {
	fprintf(stdout, "Mounting %s on %s\n", DEVICE, MOUNTPOINT);
	setreuid(0,0);
	run("/sbin/cryptsetup", "luksOpen", DEVICE, NAME, NULL);
	run("/bin/mount", "/dev/mapper/"NAME, MOUNTPOINT, NULL);
}

void do_umount(void) {
	fprintf(stdout, "Un-mounting %s from %s\n", NAME, MOUNTPOINT);
	setreuid(0,0);
	run("/bin/umount", MOUNTPOINT, 0);
	run("/sbin/cryptsetup", "luksClose", NAME, 0);
}

int main(int argc, char **argv) {
	char const *prog = argv[0];
	char const *last_slash = strrchr(prog, '/');
	if (last_slash) prog = last_slash+1;
	if (prog[0] == 'u') do_umount();
	else do_mount();
	exit(0);
}
