// Compile: gcc -o suspend suspend.c
// Set SUID: sudo chown root:root suspend && sudo chmod 4755 suspend

// OR in /etc/sudoers: pp ALL=(ALL) NOPASSWD: /usr/sbin/pm-suspend

// Compile: gcc suspend.c -o suspend

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv){
	char *file = "/sys/power/state";
	FILE *f;
	f=fopen(file, "w");
	if(f==NULL) {
		printf("Error opening file: %s\n", file);
		return 1;
	}
	fprintf(f, "%s", "mem");
	fclose(f);
	return 0;
}
