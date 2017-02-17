// pair.c  Pairing Logitech receivers with remote devices
// Copyright 2011 Benjamin Tissoires <benjamin.tissoires@gmail.com> GNU GPL3+ license
// pepa65 <solusos@passchier.net> http://github.com/pepa65/misc/blob/master/pair.c

// Compile by:  gcc -o pair pair.c
// Prepare for executing:  chmod +x pair
// Usage:  pair [<device>...]
// - Usually <device> is /dev/hidraw# (where # is a number)
// - If no <device> is given, all starting with /dev/hidraw1 are tried in order
//   until one isn't accessible
// - If one <device> or more are given, all those will be tried
//   until one is found that is willing to be paired
// Example:  pair /dev/hidraw*  # the * causes all devices to be listed
// If a receiver is found that is ready to be paired, the first remote device
//  that gets switched on will be paired (it could be switched off and then on)

#include <linux/input.h>
#include <linux/hidraw.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>

#define USB_VENDOR_ID_LOGITECH (__u32)0x046d
#define USB_DEVICE_ID_UNIFYING_RECEIVER (__s16)0xc52b
#define USB_DEVICE_ID_UNIFYING_RECEIVER_2 (__s16)0xc532
#define USB_DEVICE_ID_NANO_RECEIVER (__s16)0xc52f

int main(int argc, char **argv) {
	int fd;
	int res;
	int err = 0;
	int dev = 0;
	int try = 0;
	int tried_all = 0;
	char *device;
	char hidraw[14] = "/dev/hidraw";
	hidraw[12]='\0';
	hidraw[13]='\0';
	struct hidraw_devinfo info;
	char magic_sequence[] = {0x10, 0xFF, 0x80, 0xB2, 0x01, 0x00, 0x00};

	if (argc < 2) try = 1;

	while (1) { // try all devices given
		if (++dev > 1) { // close the device opened earlier
			close(fd);
			printf("\n");
		}

		if (try) {
			if (tried_all) break;
			if (dev > 99) {
				printf("Devices /dev/hidraw# above 99 not supported");
				break;
			}
			if (dev < 10) {
				hidraw[11] = dev + 48;
			} else {
				hidraw[11] = dev / 10 + 48;
				hidraw[12] = dev % 10 + 48;
			}
			device = hidraw;
		}	else {
			if (dev >= argc) break;
			device = argv[dev];
		}

		// Open the Device with non-blocking reads
		fd = open(device, O_RDWR|O_NONBLOCK);
		if (fd < 0) {
			printf("Unable to open device %s\n", device);
			if (try) tried_all = 1;
			continue;
		}

		// Get raw info
		res = ioctl(fd, HIDIOCGRAWINFO, &info);
		printf("Trying device %04x:%04x on %s\n", info.vendor, info.product, device);
		if (res < 0) {
			printf("Failed getting info from device\n");
			continue;
		} else if (info.bustype != BUS_USB) {
			printf("Device is not a USB device\n");
			continue;
		} else if (info.vendor != USB_VENDOR_ID_LOGITECH) {
			printf("Device is not a Logitech device\n");
			continue;
		} else if (info.product != USB_DEVICE_ID_UNIFYING_RECEIVER &&
				info.product != USB_DEVICE_ID_NANO_RECEIVER &&
				info.product != USB_DEVICE_ID_UNIFYING_RECEIVER_2) {
			printf("Device is not a known Logitech receiver\n");
			continue;
		}

		// Send the magic sequence to the device
		res = write(fd, magic_sequence, sizeof(magic_sequence));
		if (res < 0) {
			printf("Could not initialize the device\n");
			continue;
		} else if (res != sizeof(magic_sequence)) {
			printf("Initialization of device not completed, only %d bytes written\n", res);
			continue;
		}
		printf("\nNow waiting to pair a new device: switch your device (off and) on to pair it\n");
		break;
	}
	close(fd);
}
