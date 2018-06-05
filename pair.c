// pair.c
// pair - Pair Logitech USB receivers with wireless input devices
// Copyright 2011 Benjamin Tissoires <benjamin.tissoires@gmail.com> GNU GPL3+ license
// pepa65 <solusos@passchier.net> http://gitlab.com/pepa65/misc/blob/master/pair.c
// Compile:  gcc -o pair pair.c
// Prepare:  chmod +x pair

#include <linux/input.h>
#include <linux/hidraw.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>

#define USB_VENDOR_ID_LOGITECH (__s16)0x046d
#define USB_DEVICE_ID_UNIFYING_RECEIVER (__s16)0xc52b  // kb+m
#define USB_DEVICE_ID_UNIFYING_RECEIVER_2 (__s16)0xc532
#define USB_DEVICE_ID_OTHER_RECEIVER (__s16)0xc534  // blue
#define USB_DEVICE_ID_NANO_RECEIVER (__s16)0xc52f

int help(void) {
	printf(" pair - Pair Logitech USB receivers with wireless input devices\n");
	printf(" USAGE: pair [ -h | [-n] [<device>...] ]\n");
	printf("   - Usually <device> is /dev/hidraw# (where # is a number below 100)\n");
	printf("   - With -n no pairing is attempted, but all devices are checked\n");
	printf("   - If no <device> is given, all starting with /dev/hidraw1 are tried in order\n");
	printf("     until one isn't accessible or is ready to pair\n");
	printf("   - If one <device> or more are given, all are be tried in order\n");
	printf("     until one is ready to pair\n");
	printf("   - With -h only this helptext is shown\n");
	return 0;
}

int noreceiver(int device) {
  return (device != USB_DEVICE_ID_UNIFYING_RECEIVER &&
    device != USB_DEVICE_ID_UNIFYING_RECEIVER_2 &&
    device != USB_DEVICE_ID_OTHER_RECEIVER &&
    device != USB_DEVICE_ID_NANO_RECEIVER);
}

int main(int argc, char **argv) {
	int fd;
	int res;
	int seqdev = 0;
	int arg = 1;
	int try_seq = 0;
	int check = 0;
	char *device;
	char hidraw[14] = "/dev/hidraw";
	hidraw[12]='\0';
	hidraw[13]='\0';
	struct hidraw_devinfo info;
	char magic_sequence[] = {0x10, 0xFF, 0x80, 0xB2, 0x01, 0x00, 0x00};
	int len_magic = sizeof(magic_sequence);

	printf("%d > %d\n", argc, arg);
	if (argc > arg) {
		if (!strcmp(argv[arg], "-h")) return help();
		else if (!strcmp(argv[arg], "-n")) {
			check = 1;
			arg++;
		}
	}
	printf("%d == %d\n", argc, arg);
	if (argc == arg) try_seq = 1;

	while (1) { // try all devices given
		if (try_seq) {
			if (seqdev > 99) {
				printf("Devices above /dev/hidraw99 not supported");
				break;
			}
			else if (seqdev < 10) hidraw[11] = seqdev + 48;
			else {
				hidraw[11] = seqdev / 10 + 48;
				hidraw[12] = seqdev % 10 + 48;
			}
			device = hidraw;
			++seqdev;
		}
		else {
			if (arg >= argc) break;
			device = argv[arg++];
		}

		// Open the Device with non-blocking reads
		fd = open(device, O_RDWR|O_NONBLOCK);
		if (fd < 0) {
			printf("Unable to open device %s", device);
			if (try_seq) {
				printf(", stopping here\n");
				break;
			}
			printf("\n");
		}
		else {
			// Get raw info
			res = ioctl(fd, HIDIOCGRAWINFO, &info);
			printf("%sing device %04x:%04x on %s: ", (check ? "Check" : "Try"),
					info.vendor, info.product, device);
			if (res < 0) printf("no info from device\n");
			else if (info.bustype != BUS_USB) printf("not a USB device\n");
			else if (info.vendor != USB_VENDOR_ID_LOGITECH) printf("not a Logitech device\n");
			else if (noreceiver(info.product)) printf("not a known Logitech receiver\n");
			else {
				printf("a Logitech receiver\n");
				if (!check) {
					// Send the magic sequence to the receiver
					res = write(fd, magic_sequence, len_magic);
					if (res < 0) printf("Could not initialize the receiver\n");
					else if (res != len_magic)
						printf("Initialization of receiver not completed, only %d of %d bytes written\n",
								res, len_magic);
					else {
						printf("\nReceiver initialized, now waiting to pair a new device: switch it (off and) on to pair it\n");
						break;
					}
				}
			}
			close(fd);
		}
	}
	close(fd);
}
