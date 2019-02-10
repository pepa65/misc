# misc
**miscellaneous utilities and programs**

Almost all these utilities can be used by downloading them and running them like `bash <utility>`. Running like `bash <utility> -h` is always safe and will provide some sort of help text. If necessary packages are missing, this will be reported at runtime.


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
**back up a list of files and directories**

Usage:
```
backup [-h|--help] | [<backup-list> [<backup-file> [<backup-log>]]]
    backup-list: file with list of all files to be backed up, one per line
      multiple file/dir(s) possible with bash globbing (with * ? and [...])
    backup-file: output file name (.txz will be appended)
      backup-file can also be specified in the first line of backup-list, like:
      @<backup-file> but will be overridden by the command-line if set
   backup-log: log file

   Lines in backup-list are file/dirnames, except when the first character is:
     '@' (at):       <backup-file> (only in the very first line)
     ' ' (space):    skipped line
     '#' (pound):    comment line
     '$' (dollar):   command line
     '%' (percent):  gpg-password
```

## duckdns
**Update duckdns.org DDNS service**

Usage:
```
duckdns [-d|--date | -h|--help]
  -d/--date:  add a timestamp in the log
  -h/--help:  display this help text and values of domain and token
```

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

Usage: `subs -h|--help | <search terms>`

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
```
* Required: wget imagemagick(convert) [for peters projection]

## mgcfs
**Manage access to gocryptfs encrypted directory**

* Required: gocryptfs(http://github.com/rfjakob/gocryptfs) fuse grep procps tar coreutils(cat rm type ls mktemp stat shred mkdir chmod sleep sync)
* Optional: zenity/whiptail/cryptsetup(askpass) <run>
* Optional environment variables: $MGCFS_MOUNT/DIR/NAME/RUN/PLAIN
Usage:
```
mgcfs [-c|--console] | [-w|--whiptail] [-i|--init [<dir> [<name>]] |
      [-v|--verbose] [-u|--unmount <sleeplength>[<unit>]] | [-h|--help]
    -c/--console:  display through echo is forced instead of whiptail
    -w/--whiptail: display through whiptail is forced instead of zenity
    -i/--init:     setting up, <dir> must exist and <name> not or be empty
    -v/--verbose:  echoing the masterpassword to the terminal on mounting
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

## buildgocryptfs
**Build gocryptfs**

* Required: go git coreutils(cd ls)

## buildnano
**Build nano from source (release or git repo) on Ubuntu or Debian**

* Required: coreutils(mkdir cd mktemp rm) git+autoconf+autopoint+automake/wget[git/release] pkg-config gettext libncursesw5-dev groff[optional html-help] texinfo make gcc libmagic-dev[optional filetype detection]

Usage: `buildnano [-g|--git]`

## getborg
**Get borgbackup for Pi (armv7l) or PC (x86_64)**

* Required: wget sudo coreutils(mktemp rm mv chmod hash)

## healbitrot
**Automatic check and self-healing for bitrot**

* Required: bitrot par2 grep find libc-bin(getconf) coreutils(rm mv cp mkdir cd du)

Usage:
```
healbitrot [-h|--help] [<dir>...]
      <dir>:  directory to check; only if none given, the file in \$BITROT_DIRS
      is read, one directory per line. Bitrot data is stored in \$BITROT_DATA.
      -h/--help:  display this help text
```

*The python script `bitrot` is included*

## sct.c
**Utility to set the screen "temperature" to adjust the red-blue balance**

See the file for instructions on how to compile and use.

## a5toa4
**Print an A5 size document on A4 for booklet folding**
Usage:
```
a5toa4 [-c|--collate] <a5.pdf> [<a4.pdf>]
    Print the resulting A4 document on a single-sided printer by:
      - printing the even pages
      - flipping the whole bundle of sheets over
      - printing the odd pages
    Or print it on a full-duplex printer.

    If -c or --collate is given, the printing can be done by:
      - printing pages 1..n/2
      - flipping the whole bundle of sheets over
      - printing pages n/2+1..n
      (For more than 1 copy, select 'Collate' before printing.)

    -h/--help:  display this help text
```
* Required: coreutils(cat mktemp) ghostscript(psselect pdf2ps ps2pdf) psutils(psnup)

## pdfslice
**Make a pdf from a page range in a source document**

Usage:
```
Usage:  $Self [-h|--help ] | <range> <in.pdf> [<out.pdf>]
    Where <range> is:  [<from>],[<to>] | [<from>]+[<number>]
      If <from> & <to> start with a minus sign they count from the back;
        if omitted they default to first & last page;
        <number> specifies the number of pages, if omitted defaults to 1.
    -h/--help:  Just display this help text.
```
* Required: poppler-utils(pdfseparate pdfunite pdfinfo) coreutils(mktemp rm)

## bootctlu
**Setting up and registering systemd_boot on Ubuntu/Void/Arch**

Usage:
```
bootctlu [-h|--help] [-n|--nogo] [-q|--quiet] [-v|--verbose]
         [-m|--memtest] [-r|--register] [-e|--esp <EFI-mount>]
    -h/--help:             Only display this help text.
    -n/--nogo:             No writing to the system at all.
    -q/--quiet:            Only fatal errors output to the terminal.
    -v/--verbose:          Show more detail of the actions.
    -m/--memtest:          Also download and set up a MemTest86 entry.
    -r/--register:         Also register the efi-loader with UEFI.
    -e/--esp <EFI-mount>:  EFI System Partition mountpoint, default:
                           /boot/efi, can also be set in BOOTCTLU_ESP.
```
* Required: util-linux(lsblk) grep coreutils(sort cut mkdir cat cp ls rm cd) sed systemd(file:systemd-bootx64.efi)/wget[if not present] sudo[unless run as root, or only invoked with -n/--nogo]. For -m/--memtest: wget tar. For -r/--register: efibootmgr.

## ypass
**GUI for 'pass' the standard unix password manager**

Yad GUI frontend for pass, the standard unix password manager.
Can view, edit and delete.

*Required: yad pass coreutils(type sleep shred ls) sed diffutils(diff).

## bitwarden2xml
**Enter bitwarden data into keepassx database**

* Required: csvtool

Usage: `bitwarden2xml bitwarden.csv >keepassx.xml`

## kpt2bitwarden
**Enter keepassx text into bitwarden .csv format**
Usage: `kpt2bitwarden keepassx.xml >bitwarden.csv`

## ffpw.py
**Decode Firefox passwords**

* Required: python-pyasn1 python-pycryptodome

Usage:
```
ffpw.py [<options>]
    options:  -d/--directory <firefox-dir>
              -p/--password <masterpassword>
              -v/--verbose
```

## keepassx.sh
**Unpack selfmake archive script**

* Required: makeself find sudo sed

## keepassx2pass.py
**Convert KeePassX xml export to pass store**

Usage: `keepassx2pass.py keepassx.xml`

## safetext
**Sanitize potentially identifying invisible characters**

* Default spelling lists included: `US.safetext` and `UK.safetext`
