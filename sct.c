// sct.c
// Set Colour Temperature of screen
// Required: libxrandr-dev (will pull in libx11-dev)
// Compile:
//     cc -o sct sct.c -lX11 -lXrandr
//   Or:
//     cc -std=c99 -O2 -I /usr/X11R6/include -o sct sct.c \
//       -L /usr/X11R6/lib -lm -lX11 -lXrandr
// Install: chmod +x sct && sudo mv sct /usr/local/bin/sct
//
// Bash usage (add these lines to .bashrc), requires yad:
//     export SCT
//     sct(){
//       SCT=$(yad --title "Display tint" --scale --value=${SCT:=6500} --min-value=1000 --max-value=10000)
//       [[ $SCT ]] && $(type -P sct) $SCT  ## sct executable in PATH
//     }
//
// Original license: Public domain, do as you wish.
// Adapted to work on all screens by pepa65 <pepa65@passchier.net>
// Modifications relicenced under GPLv3+

#include <X11/Xlib.h>
#include <X11/Xproto.h>
#include <X11/Xatom.h>
#include <X11/extensions/Xrandr.h>
#include <stdlib.h>
#include <math.h>
#include <stdio.h>

// From redshift, in 500K steps
static const struct {float red; float green; float blue;} whitepoints[] = {
	{1.00000000, 0.18172716, 0.00000000,}, // 1000K
	{1.00000000, 0.42322816, 0.00000000,},
	{1.00000000, 0.54360078, 0.08679949,},
	{1.00000000, 0.64373109, 0.28819679,},
	{1.00000000, 0.71976951, 0.42860152,},
	{1.00000000, 0.77987699, 0.54642268,},
	{1.00000000, 0.82854786, 0.64816570,},
	{1.00000000, 0.86860704, 0.73688797,},
	{1.00000000, 0.90198230, 0.81465502,},
	{1.00000000, 0.93853986, 0.88130458,},
	{1.00000000, 0.97107439, 0.94305985,},
	{1.00000000, 1.00000000, 1.00000000,}, // 6500K
	{0.95160805, 0.96983355, 1.00000000,},
	{0.91194747, 0.94470005, 1.00000000,},
	{0.87906581, 0.92357340, 1.00000000,},
	{0.85139976, 0.90559011, 1.00000000,},
	{0.82782969, 0.89011714, 1.00000000,},
	{0.80753191, 0.87667891, 1.00000000,},
	{0.78988728, 0.86491137, 1.00000000,}, // 10000K
	{0.77442176, 0.85453121, 1.00000000,},
};

int main(int argc, char **argv) {
	Display *dpy = XOpenDisplay(NULL);
	Window root;
	float tr, gamma_red, gamma_green, gamma_blue, gr;
	XRRCrtcGamma *crtc_gamma;
	int screens = ScreenCount(dpy), temp = 6500, screen = 0,
		arg, ti, c, i, crtcxid, size;
	if (argc > 1) {
		arg = atoi(argv[1]);
		if (arg >= 1000 && arg <= 10000) temp = arg;
	}

	// Interpolate from the table
	ti = temp / 500 - 2;
	tr = temp % 500 / 500;
#define AVG(rgb) (1 - tr) * whitepoints[ti].rgb + tr * whitepoints[ti + 1].rgb
	gamma_red = AVG(red);
	gamma_green = AVG(green);
	gamma_blue = AVG(blue);

	while (screen < screens) {
		root = RootWindow(dpy, screen++);
		XRRScreenResources *res = XRRGetScreenResourcesCurrent(dpy, root);

		for (c = 0; c < res->ncrtc; c++) {
			crtcxid = res->crtcs[c];
			size = XRRGetCrtcGammaSize(dpy, crtcxid);
			crtc_gamma = XRRAllocGamma(size);

			for (i = 0; i < size; i++) {
				gr = 65535 * i / size;
				crtc_gamma->red[i] = gr * gamma_red;
				crtc_gamma->green[i] = gr * gamma_green;
				crtc_gamma->blue[i] = gr * gamma_blue;
			}
			XRRSetCrtcGamma(dpy, crtcxid, crtc_gamma);
			XFree(crtc_gamma);
		}
	}
}
