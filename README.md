# misc
**Miscellaneous utilities and programs**

Almost all these utilities can be used by downloading them and running them
like `bash <utility>`. Running like `bash <utility> -h` is always safe and will
provide some sort of help text. If necessary packages are missing, this will be
reported at runtime.

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

# bacme
**Simply request certificates from Let's Encrypt using ACME**
Usage:
```
bacme [-h] [-v] [-t] [-e <email>] [-w <docroot>] [<domain>[...]]
Options:
  -h/--help             This help text
  -v/--verbose          Verbose mode: additional debug output
  -t/--test             Test with Let's Encrypt Staging API to not get banned
  -e/--email <email>    Contact email for Let's Encrypt
  -w/--webroot <dir>    Path to document root of the webserver
If <dir> is not specified, some manual action is required The <dir> may be an
rsync-compatible remote location like: user@server:/var/www/html/

Instead of specifying <email>/<dir>/<domain>[...] on the commandline, they may
be put in environment variables BACME_EMAIL, BACME_WEBROOT and BACME_DOMAINS.
The first <domain> must be the root domainname, followed by the subdomains.

Example:
bacme -e me@mail.me -w me@server:/var/www/html example.com www.example.com
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

When called through a symlink other than 'dg' then subdomains get probed.

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

## earthdata
**Get NASA earth foto and put it on the MATE desktop**

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

* Required: coreutils(mkdir cd mktemp rm)
git+autoconf+autopoint+automake/wget[git/release] pkg-config gettext
libncursesw5-dev groff[optional html-help] texinfo make gcc
libmagic-dev[optional filetype detection]
* Usage:
```
buildnano [<version> | -g|--git | -c|--current]
    <version>:     Build <version>
    -g/--git:      Build from current git HEAD (not stable release version)
    -c/--current:  Build from local git repo (as is)
```

## getjulia
**Installing Julia from the generic binaries**

Usage:
```
getjulia [-u|--uninstall | -p|--purge]
  -u/--uninstall:  Remove Julia
  -p/--purge:      Remove Julia and also all user directories
```
* Environment: `TMP` (optional) root path of the temporary working directory
* Required: `wget tar coreutils(mktemp rm mv)`

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

## bb
**Wrapperscript around borgbackup**

Usage:
```
bb [ init|check|help|unlock|prune | list [<prefix>] | info|delete <name> |
     backup [<dir>] | rename <name> <newname> | mount [<name>] | unmount ]
  init:  init repo (set BORG_REPO variable in $self or on commandline)
  check:  check repo
  help:  output this help text (also without any argument)
  unlock:  unlock the repo when left locked
  prune:  prune the backups
  list [<prefix>]:  list backups in repo [starting with <prefix>]
  info <name>:  list details of [backup <name> in] repo
  delete <name>:  delete [backup <name> from] repo
  backup [Dovecot|Peter|Kelly|MyDocuments]:  backup $basedir[/<dir>]
  rename <name> <newname>:  rename backup <name> to <newname>
  mount [<name>]:  mount [backup <name> from] repo on $(basename "$mnt")
  unmount:  unmount from $(basename "$mnt")
```

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

## ffpw
**Manage Firefox passwords: view, import, export**

* Required: python3-pyasn1 less
* Copyright: 2018 Louis Abraham <louis.abraham@yahoo.fr> MIT License
* Adapted: gitlab.com/pepa65/misc <pepa65@passchier.net> GPLv3

Usage:
```
ffpw [<filter>] [<file>] [-v|--verbose] [-h|--help]
	  <filter>:      [ -u|-url | -n|--username | -p|--password ] <regex>
  	<file>:        -i|--import | -e|--export [<csv-file>]
  The <regex> filter can be generic or specific for urls/usernames/passwords.
  The <csv-file> can be empty or '-': import from stdin or export to stdout.
  If <file> is not specified, the output is formatted and piped to a viewer.
    -v/--verbose:  More verbose output to stderr
    -h/--help:     This help text
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
Usage:  pdfslice [-h|--help ] | <range> <in.pdf> [<out.pdf>]
    Where <range> is:  [<from>],[<to>] | [<from>][+[<number>]]
      If <from> & <to> start with a minus sign they count from the back;
        if omitted they default to first & last page;
        <number> specifies the number of pages, if omitted defaults to 1.
    -h/--help:  Just display this help text.
```
* Required: poppler-utils(pdfseparate pdfunite pdfinfo) coreutils(mktemp rm ls)

## rmkernels
**Remove old kernels from Debian/Ubuntu**
Usage: `rmkernels`

## bootctlu
**Setting up and registering gummiboot on Ubuntu/Void/Arch**
Usage:
```
bootctlu - Install & register gummiboot/systemd-boot on Ubuntu/Void/Arch

bootctlu [-h|--help] [-I|--install] [-U|--uninstall]
         [-n|--nogo] [-q|--quiet] [-v|--verbose]
         [-i|--imgdir <dir>] [-e|--esp <dir>]
         [-m|--memtest] [-s|--secureboot] [-r|--register]
    -h/--help:          Only display this help text.
    -I/--install:       Only install the script and kernel install hooks
    -U/--uninstall:     Only uninstall the script and kernel install hooks
    -n/--nogo:          No writing to the system at all.
    -q/--quiet:         Only fatal errors output to the terminal.
    -v/--verbose:       Show more detail of the actions.
    -i/--imgdir <dir>:  Kernel & initrd images directory, default:
                          /boot, overrides BOOTCTLU_IMGDIR.
    -e/--esp <dir>:     EFI System Partition mountpoint, default:
                          /boot/efi, overrides BOOTCTLU_ESP.
    -m/--memtest:       Also download and set up a MemTest86 entry.
    -s/--secureboot:    Also install secureboot files.
    -r/--register:      Also register the efi-loader with UEFI.
	Extraneous arguments ignored to work as install/remove kernel hook.
```
* Required: util-linux(lsblk) coreutils(tee sort cut mkdir cat cp ls rm cd) grep sed systemd(file:systemd-bootx64.efi)/wget[if not present] sudo[unless run as root, or only invoked with -n/--nogo]. For -m/--memtest: wget tar. For -r/--register: efibootmgr.

## noiseclean
**Filter out noise based on sample**
* Required: ffmpeg(ffmpeg ffprobe) sox

## fillform
**Auto fill form for multiple cases**
* Required: flpsed sed ghostscrips(ps2pdf) poppler-utils(pdfunite)
coreutils(cd wc rm ls)

Usage:
```
fillform [-s|--separate] [<dir>]
  When -s/--separate is given, the separate .pdf files for each form are kept
  as well as the concatenated file. Directory <dir> has the input files.
```

## w2usb
**Write image/hybridiso to (USB) disk device**
Usage: 'w2usb <dev> <file>'

## spd
**Commandline interface for testing internet bandwidth using speedtest.net**
Usage:
```
spd [-h] [-u] [-d] [-1] [-B] [-I] [-b] [-c] [-C CHAR] [-H] [-j] [-L] [-l]
    [-m STR] [-x INT] [-s ID] [-X ID] [-M URL] [-i IP] [-t SECS] [-S] [-N] [-V]

optional arguments:
  -h, --help            show this help message and exit
  -u, --no-download     Do not perform download test
  -d, --no-upload       Do not perform upload test
  -1, --single          Only use a single connection instead of multiple. This
                        simulates a typical file transfer.
  -B, --bytes           Display values in bytes instead of bits. Does not
                        affect the image generated by --share, nor output from
                        --json or --csv
  -I, --share           Generate and provide a URL to the speedtest.net share
                        results image, not displayed with --csv
  -b, --simple          Suppress verbose output, only show basic information
  -c, --csv             Suppress verbose output, only show basic information
                        in CSV format. Speeds listed in bit/s and not affected
                        by --bytes
  -C CHAR, --csv-delimiter CHAR
                        Single character delimiter to use in CSV output.
                        Default ","
  -H, --csv-header      Print CSV headers
  -j, --json            Suppress verbose output, only show basic information
                        in JSON format. Speeds listed in bit/s and not
                        affected by --bytes
  -L, --list            Display a list of speedtest.net servers sorted by
                        distance
  -l, --local           Use built-in server list
  -m STR, --match STR   Match STR with country / countrycode / city of the
                        server
  -x INT, --max INT     The maximum number of servers to try, default: 5
  -s ID, --server ID    Specify a numerical server ID. Can be supplied
                        multiple times
  -X ID, --exclude ID   Exclude a server ID. Can be supplied multiple times
  -M URL, --mini URL    URL of Speedtest Mini server
  -i IP, --source IP    Source IP address to bind to
  -t SECS, --timeout SECS
                        HTTP timeout in seconds. Default 10
  -S, --secure          Use HTTPS instead of HTTP when communicating with
                        speedtest.net operated servers
  -N, --no-pre-allocate
                        Do not pre-allocate upload data. Pre-allocation is
                        enabled by default to improve upload performance. To
                        support systems with insufficient memory, use this
                        option to avoid a MemoryError
  -V, --version         Show the version number and exit
```

# tn
**Try TCP on host & port**
* Required: perl

# kenburns
* Required: ruby ffmpeg

Usage:
```
kenburns [options] input1 [input2...] output
    -h, --help                       Prints this help
        --size=INTxINT               Video WIDTHxHEIGHT [default: 1280x800]
        --slide-duration=FLOAT       Slide DURATION (seconds) [default: 4]
        --fade-duration=FLOAT        Transition DURATION (seconds) [default: 1]
        --fps=INT                    Frame RATE (frames/second) [default: 30]
        --zoom-direction=STRING      DIRECTION [default: random]
        --zoom-rate=FLOAT            RATE [default: 0.1]
        --scale-mode=STRING          MODE (pad|crop_center|pan) [default: auto]
    -l, --loopable                   Create loopable video
        --audio=FILE                 Use FILE as audio track
        --subtitles=FILE             Use FILE as subtitles track
    -y, --yes                        Overwrite OUTPUT without asking
```

# megadl
**Download mega.nz and MegaCrypter files**

Usage:
```
megadl v2.1 - Download mega.nz and MegaCrypter files

Usage: megadl [<options>] <URL> | -l|--list <file>
  -s|--speed <speed>         Download speed limit <int>B|K|M, example: 20K
  -p|-password <password>    Password for MegaCrypter links (same for all)
  -m|--metadata              Only display file metadata in JSON format
  -q|--quiet                 Quiet mode
  -h|--help                  This help text
Single <URL> mode options:
  -o|--output <filename>    Store the output file with this name
URL list in <file>:
  Line format in file (FILENAME is optional):  URL FILENAME
Repo: https://github.com/pepa65/misc
```

# buildsignal
**Build Signal desktop AppImage**
* Required: sudo
