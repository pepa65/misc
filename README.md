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

## xran
**Arrange 2 screens with different pixel densities beside each other**

Usage:
```
xran [-h|-n] [:<lD> [:<rD>]] [<lP> [<rP>]] [+|-<O>] [-s][<S>]
  Starting parameters:  :eDP1 :HDMI1 100 100 +0  (when no default set yet)
    <lD>, <rD>:  Names of the left and right Displays, preceded by ':'.
    <lP>, <rP>:  Scaling of left and right display in whole Percentages;
                  if <rP> is zero, the right-hand side display is turned off.
    +|-<O>:      Vertical alignment Offset of the top edge of the screens,
                  must start with '+'/'-' (positive: left display is lower).
    -s [<S>]:    Save as scheme <S>; load <S> when no -s is given. When no
                  <S> is given, the default scheme is used (loaded/saved).
    -n|--norun:  Don't run the xrandr command (just display the commandline).
    -h|--help:   Just display this help text.
  The configfile for storing saved schemes is: ~/.xran
  The mode used for both screens is: 1920x1080
```

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

## dg
**Extended dig**

Usage: `dg[x] <domain> [<dnsrecordtype>]`

When called as something else than `dg` then subdomains get probed

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

## yt2srt
**Convert YouTube subtitles to .srt**

Usage: `yt2srt <input file>`

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

## buildnano
**Build nano from source (release or git repo) on Ubuntu or Debian**

* Required: coreutils(mkdir cd mktemp rm) git+autoconf+autopoint+automake/wget[git/release] pkg-config gettext libncursesw5-dev groff[optional html-help] texinfo make gcc libmagic-dev[optional filetype detection]

Usage: `buildnano [-g|--git]`

## getborg
**Get borgbackup for Pi (armv7l) or PC (x86_64)**

* Required: wget sudo coreutils(mktemp rm mv chmod hash)

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

Usage: `buildgocryptfs [-n|--new-go]`
    `-n`/`--new-go`:  force the installation of go even if one is present
* Required: go coreutils(ls) pkg-config libssl-dev [to install go: wget sudo tar coreutils(mktemp mv rm tail)]

* Environment variables:
 - If GO_OS is not set to the OS, 'linux' will be used.
 - If GO_ARCH (architecture) is not set, 'amd64' or 'armv6l' will be used.
 - If GO_VERSION is not set to a specific go version, the latest is used.
 - When TMPDIR is set, it is used for the temporary directory

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

## keepassxml2json
**Convert KeePassX xml export to json for Ironclad**

Usage: `keepassxml2json [-d|--debug] <in.xml> <out.json>`

* Required: grep sed coreutils(tail tr cd mv rm ls)

## tpm
**Terminal Password Manager (uses standard 'pass' database)**
* Copyright: **2013-2016 Sören Tempel, 2019 pepa65**
* License: **GPL3+**

Usage: 'tpm <command> <entry>'
    command: help / show / insert / delete

* Environment variables: **TPM_DIR TPM_KEY**

## safetext
**Sanitize potentially identifying invisible characters**

* Default spelling lists included: `US.safetext` and `UK.safetext`

## savedio
**Export saved.io links through the API into a json file, and convert it into 3 formats:
- A 'Netscape.html' file (supposedly) importable by Shaarli
- An encoded php-array that Shaarli uses as internal storage 'datastore.php'
- An html5 page with links**

* Required: wget date jq gzip coreutils(base64 head tail)

* Environment variables: SAVEDIO_KEY SAVEDIO_DEVKEY SAVEDIO_DIR

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
**Print an A5 document on A4 size pages for booklet folding**
Usage:
```
a5toa4 [<Options>] <a5.pdf> [<a4.pdf>]
    Options:  -h/--help:                  Display this help text
              -v/--verbose:               Verbose output of processing steps
              -s/--split & -r/--reverse:  See below
    Print the resulting A4 document on a single-sided printer by:
      1. Printing all the even pages.
      2. Reinserting the stack of printed pages in such a way that the blank
         sides will now be used to print the rest of the pages in step 3.
      3. Printing all the odd pages.
    If -s/--split is given, the printing can be done by:
      1. Printing the first half of the N pages, from 1 to N/2.
      2. See step 2 above.
      3. Printing the second half of the N pages, from N/2+1 to N.
    If -r/--reverse is given, the order of printing in step 3 is reversed, as
      appropriate for normal full-duplex printing (not the whole stack of
      papers gets flipped, just individual pages automatically).
    For more than 1 copy, be sure to select COLLATE before printing!
    For printing on Letter size paper, select FIT TO PAGE before printing!
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

## rmkernels
**Remove old kernels from Debian/Ubuntu**

Usage: `rmkernels`

## bootctlu
**Setting up and registering gummiboot on Ubuntu/Void/Arch**

Usage:
```
bootctlu [-h|--help] [-n|--nogo] [-q|--quiet] [-v|--verbose]
         [-i|--imgdir <images dir>] [-e|--esp <EFI-mount>]
         [-m|--memtest] [-r|--register]
    -h/--help:                 Only display this help text.
    -n/--nogo:                 No writing to the system at all.
    -q/--quiet:                Only fatal errors output to the terminal.
    -v/--verbose:              Show more detail of the actions.
    -i/--imgdir <images dir>:  Kernel & initrd images directory, default:
                               /boot, overrides BOOTCTLU_IMGDIR.
    -e/--esp <EFI-mount>:      EFI System Partition mountpoint, default:
                               /boot/efi, overrides BOOTCTLU_ESP.
    -m/--memtest:              Also download and set up a MemTest86 entry.
    -r/--register:             Also register the efi-loader with UEFI.
```
* Required: util-linux(lsblk) coreutils(tee sort cut mkdir cat cp ls rm cd) grep sed systemd(file:systemd-bootx64.efi)/wget[if not present] sudo[unless run as root, or only invoked with -n/--nogo]. For -m/--memtest: wget tar. For -r/--register: efibootmgr.

## noiseclean
**Filter out noise based on sample**
* Required: ffmpeg(ffmpeg ffprobe) sox
