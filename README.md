# misc
*miscellaneous utilities and programs*

## difth
**Show differences between 2 Thai language sources in html or terminal**

* Required: swath dwdiff sed coreutils(cat type mkdir chmod mktemp rm)
Usage:
```
difth [-n|--nojs] [-s|--strings] <in1> <in2> [<htmlout>|-|/]
    Arguments <in1> and <in2> must be existing filenames,
     or strings (if -s or --strings is given).
    Argument htmlout is optional: if '-' then the html goes to stdout,
     if '/' then the html will be output to a file in $dl and displayed,
     if not present then the colored diff will be displayed onto terminal,
     otherwise the html will be output to the given filename <htmlout>.
    When -n or --nojs is given, the html will use no javascript (used for
     cycling through viewing modes).
```
Includes the files `difth.php` and `index.html-difth` (rename to `index.html`)
for hosting an online Thai text comparison service.

## count
**Count character occurrences in file**

* Required: uni2ascii

Usage: `count <file> [-s]`
    `-s means sort by code point instead of frequency`

## rmkernels
**Remove old kernels from Debian/Ubuntu**

Usage: `rmkernels`

## backup
**A utility to back up a list of files and directories**

Usage: `backup [-h|--help] [<backup-list> [<backup-file>]]`

## duckdns
**Update duckdns.org DDNS service**

Usage: `duckdns [date]`

## merge2ass
**Merge 2 subtitle files into one**

Usage:
```
merge2ass <movie> <subtitle1> <subtitle2> [-p|--play-movie]
    or: `merge2ass --detect <movie> [-p | --play-movie]
    or: `merge2ass [-h | --help]
```

## pair.c
**Utility to pair Logitech USB unifying or nano receivers with wireless input devices**

See the file for instructions to compile and use.

## subs
**Download subtitles from subscene.com**

Usage: `subs <search terms>`

## qemu-create-os-img
**Create a fresh Debian/Ubuntu qemu image**
Usage:
```
qemu-create-os-img [-h] [-r <release>] [-h <hostname>] [-i <img_file>]
                           [-s <disk_size>] [-b <boot_size>] [<debootstrap>]
  -h:              This help text
  -r <release>:    A supported Debian or Ubuntu release name
  -h <hostname>:   Desired hostname
  -i <img_file>:   Location of the image file (overwritten if existing)
  -d <disk_size>:  Size of the virtual disk
  -b <boot_size>:  Size of the boot partition (rest: root partition)
  <debootstrap>:   Extras arguments for debootstrap
Default values when options are not supplied:
  <release>:       xenial
  <hostname>:      <release>
  <img_file>:      <hostname>-<os>-<release>.qcow2
  <disk_size>:     $disk_size
  <boot_size>:     $boot_size
```

## earthwallpaperlive
**Set current earthimage as wallpaper**

Usage:
```
earthwallpaperlive [<projection>]
  <projection> is one of: mercator (default), peters, rectangular, random
Required: wget imagemagick(convert) [for peters projection]
```

## mgcfs
**Manage access to gocryptfs encrypted directory**

* Required: gocryptfs(http://rfjakob/gocryptfs) fuse tar grep procps coreutils
* Optional: zenity/whiptail/cryptsetup(askpass) <run>
* Optional environment variables: $MGCFS_MOUNT/DIR/NAME/RUN/PLAIN
Usage:
```
mgcfs [-c|--console] | [-w|--whiptail] [-i|--init [<dir> [<name>]] |
      [-u|--unmount <sleeplength>[<unit>]] | [-h|--help]
    -c/--console:  display through echo is forced instead of whiptail
    -w/--whiptail: display through whiptail is forced instead of zenity
    -i/--init:     setting up, <dir> must exist and <name> not or be empty
    -u/--unmount:  auto-unmount after <sleeplength>[<unit>]
    -h/--help:     display this help text
  Either set or adjust <mount>, <dir> and <name> as hardcoded in this script
   (and optionally <run>), or set the corresponding environment variables
   MGCFS_MOUNT, MGCFS_DIR, MGCFS_NAME (and optionally MGCFS_RUN).
  As a run-by-run backup, <dir>/<name>.tar will be used.
  When during 'init' MGCFS_PLAIN is 1, filenames will not be encrypted.
  <sleeplength> is in minutes if no unit is given; <unit> can be:
   s (seconds), m (minutes), h (hours), d (days).
```

## healbitrot
**Automatic check and self-healing for bitrot**

* Required: bitrot par2 grep find libc-bin(getconf) coreutils(rm mv cp mkdir cd du)
Usage:
```
healbitrot [<dir>]...
   <dir> are the directories to check
   if no directories specified, the file in $BITROT_BACKUPS_DEST is read
```

*The python script `bitrot` is included*

## spr
**Script to paste stdin to sprunge.us**

* Original: Copyright Han Boetes <hboetes@gmail.com>
* Modified by TerrorBite //github.com/TerrorBite
* Licence: public domain
* Required: POSIX shell netcat(nc) coreutils(cat od) date [if /dev/urandom not present]
Usage:
```
    spr <file
    spr <<<$string
    spr  # end the input with Ctrl-D on a new line
```

## sct.c
**Utility to set the screen "temperature" to adjust the red-blue balance**

See the file for instructions on how to compile and use.

## tf
**Transfer files via transfer.sh**
* Required: curl
* Optional: gpg tar qrencode
Usage:
```
tf [-q|--qr] [-z|--zip] [-c|--crypt] [-h|--help | <link> | <path>...
    -q|--qr:     Also give QR code for resulting link
    -z|--zip:    Use zip instead of tar for the uploaded archive
    -c|--crypt:  Use gpg for en/decryption of file/archive to be up/downloaded
    -h|--help:   Display this help text
  <link> is a transfer.sh link starting with https://
  <path> is the path to a file or directory; there can be multiple
```

## a5toa4
**Print an A5 size document on A4 for booklet folding**
Usage:
```
a5toa4 [-h|--half] <a5.pdf> [<a4.pdf>]
    Print the resulting A4 document on a single-sided printer by printing the
    even pages, flipping the bundle of sheets over, then printing the uneven pages
```
* Required: coreutils(cat mktemp) ghostscript(psselect pdf2ps ps2pdf) psutils(psnup)

## pdfslice
**pdfslice - Return page ranges from a source document**

Usage: `pdfslice <from> <to> <source.pdf> [<destination.pdf>]`
* Required: pdfseparate pdfunite coreutils(mktemp cd)
