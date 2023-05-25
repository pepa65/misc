# misc
**Miscellaneous utilities and programs**

Almost all these utilities can be used by downloading them and running them
like `bash <utility>`. Running like `bash <utility> -h` is always safe and will
provide some sort of help text. If necessary packages are missing, this will be
reported at runtime.

## a5toa4
**Print an A5 document on A4 size pages for booklet folding**

* Usage:
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

## backup
**Backup a list of files and directories**

* Usage:
```
backup - Backup a list of files and directories

Usage: backup [-h|--help | <backup-list> [<backup-file> [<backup-log>]]]
  backup-list:  File with list of all files to be backed up, one per line
      Multiple file/dir(s) possible with bash globbing (with * ? and [...]).
      (default:  ./backup.lst)
  backup-file:  Output file name (.txz will be appended if not ending in .txz)
      Backup-file can also be specified in the first line of backup-list, like:
        @<backup-file> but will be overridden by the command-line if given
      (default:  backup.txz)
  backup-log:   Log file  (default:  backup.log)
Lines in backup-list are file/dirnames, except when the first character is:
  '@' (at):       <backup-file> (only in the very first line)
  ' ' (space):    skipped line
  '#' (pound):    comment line
  '$' (dollar):   command line
  '%' (percent):  gpg-password
Links are followed to backup the actual file contents if possible.
```

## bacme
**Simply request certificates from Let's Encrypt using ACME**

* Usage:
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

## bb
**Wrapperscript around borgbackup**

* Usage:
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

## bitwarden2xml
**Enter bitwarden data into keepassx database**

* Required: csvtool
* Usage: `bitwarden2xml bitwarden.csv >keepassx.xml`

## bootctlu
**Install/register systemd-boot on Ubuntu/Void/Arch**

* Usage:
```
bootctlu v0.2.5 - Install/register systemd-bootmanager on Ubuntu

Usage:  bootctlu [<option>...]
  <option>:
    -h/--help:          Only display this help text.
    -V/--version:       Only display the version.
    -v/--verbose:       Show more detail of the actions.
    -q/--quiet:         Fatal errors only output to the terminal.
    -n/--nogo:          No writing to the system at all.
    -I/--install:       Only install the script and kernel install hooks.
    -U/--uninstall:     Only uninstall the script and kernel install hooks.
    -M/--maxkernels:    Maximum number of kernels to install, default 2.
    -i/--imgdir <dir>:  Kernel & initrd images directory, default: '/boot'.
                        /boot, overrides BOOTCTLU_BOOT.
    -e/--esp <dir>:     EFI System Partition mountpoint, default: '/boot/efi'.
                        /boot/efi, overrides BOOTCTLU_ESP.
    -L/--label:         Label for the UEFI entry.
    -m/--memtest:       Also download and set up a MemTest86 entry.
    -s/--secureboot:    Also install secureboot files.
    -r/--register:      Also register the bootmanager with UEFI.
  Extra arguments ignored so this can work as install/remove kernel hook.
```

* Required: gdisk(sgdisk) coreutils(tee sort cut mkdir cat cp mv rm cd ls diff)
  grep sed systemd(systemd-boot*.efi) uuid-runtime(uuidgen) xargs
  - memtest: wget tar
  - register: efibootmgr
  - install: diffutils(diff)

## buildgocryptfs
**Build gocryptfs**

* Usage: `buildgocryptfs [-n|--new-go]`
  - `-n`/`--new-go`:  force the installation of go even if one is present
* Required: go coreutils(ls) pkg-config libssl-dev [to install go: wget sudo tar coreutils(mktemp mv rm tail)]
* Environment variables:
 - If GO_OS is not set to the OS, 'linux' will be used.
 - If GO_ARCH (architecture) is not set, 'amd64' or 'armv6l' will be used.
 - If GO_VERSION is not set to a specific go version, the latest is used.
 - When TMPDIR is set, it is used for the temporary directory

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

## buildsignal
**Build Signal desktop AppImage**

* Required: sudo

## chmc
**Change Mojang Minecraft name for local LAN play with TLauncher**
* Usage: `chmc [OLD NEW]` (Without arguments, display current name(s))

## colorcount
**Count color capacity of terminal**

## count
**Count character occurrences in file**

* Required: uni2ascii
* Usage: `count <file> [-s]`
  - `-s means sort by code point instead of frequency`

## difth
**Show differences between 2 Thai language sources in html or terminal**

* Required: swath dwdiff sed coreutils(cat type mkdir chmod mktemp rm)
* Usage:
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

## dg
**Extended dig**

* Usage: `dg[x] <domain> [<dnsrecordtype>]`
  - When called through a symlink other than 'dg' then subdomains get probed.

## duckdns
**Update duckdns.org DDNS service**

* Usage:
```
duckdns [-d|--date | -h|--help]
  -d/--date:  add a timestamp in the log
  -h/--help:  display this help text and values of domain and token
```

## earthdata
**Get NASA earth foto and put it on the MATE desktop**

## earthwallpaperlive
**Set current earthimage as wallpaper**

* Usage:
```
earthwallpaperlive [<projection>]
  <projection> is one of: mercator (default), peters, rectangular, random
```
* Required: wget imagemagick(convert) [for peters projection]

## ffpw
**Manage Firefox passwords: view, import, export**

* Required: python3-pyasn1 less
* Copyright: 2018 Louis Abraham <louis.abraham@yahoo.fr> MIT License
* Adapted: gitlab.com/pepa65/misc <pepa65@passchier.net> GPLv3
* Usage:
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

## fillform
**Auto fill form for multiple cases**

* Required: flpsed sed ghostscrips(ps2pdf) poppler-utils(pdfunite) coreutils(cd wc rm ls)
* Usage:
```
fillform [-s|--separate] [<dir>]
  When -s/--separate is given, the separate .pdf files for each form are kept
  as well as the concatenated file. Directory <dir> has the input files.
```

# fonts
**Preview fonts interactively from the commandline**
* Usage:
```
┌─┐┌─┐┌┐┌┌┬┐┌─┐
├─ │ ││││ │ └─┐
┘  └─┘┘└┘ ┴ └─┘
fonts - Preview fonts interactively from the commandline

Usage:  fonts [FONT | <option> ...]
  Options:
  FONT                   Filename (.otf .ttf .woff) of the font
                         (If not given, fonts can be explored interactively)
  -h/--help              Show this help message and exit
  -V/--version           Show the version of 'fonts' and exit
  -S/--previewsize WxH   Width and height of the font preview window in pixels
  -P/--position +X+Y     Position of the font preview window
  -p/--prompt PROMPT     Prompt for the fuzzy searcher
  -s/--fontsize SIZE     Font size
  -b/--background COLOR  Background color of the font preview window
  -f/--fontcolor COLOR   Font color of the font preview window
  -t/--text "TEXT"       Text in the font preview window
Options can be set by environment variables: FONTS_PREVIEWSIZE FONTS_POSITION
  FONTS_PROMPT FONTS_FONTSIZE FONTS_BACKGROUND FONTS_FONTCOLOR FONTS_TEXT
```

## fonttable
**Display every unicode character**
```
Usage:  fonttable [-c] [-s] [-u] [START..END] [-f FONT]
  -c/--cache           UnicodeData.txt data embedded in this script.
  -s/--show-unihan     Also show CJK data from the Unihan database.
  -u/--unihan-cache    Use a cached copy of the list of valid CJK characters
                       instead of looking for Unihan_DictionaryIndices.txt.
  START..END           Only show range from START to END(inclusive)
                       Multiple ranges allowed: fonttable 2590..f 1fb00..ff
  -f/--font FONT       Show every Unicode glyph which is defined in FONT.
```

## forks
**Check forks of significance on github**

## getborg
**Get borgbackup for Pi (armv7l) or PC (x86_64)**

* Required: wget sudo coreutils(mktemp rm mv chmod hash)

## getjulia
**Installing Julia from the generic binaries**

* Usage:
```
getjulia [-u|--uninstall | -p|--purge]
  -u/--uninstall:  Remove Julia
  -p/--purge:      Remove Julia and also all user directories
```
* Environment: `TMP` (optional) root path of the temporary working directory
* Required: `wget tar coreutils(mktemp rm mv)`

## healbitrot
**Automatic check and self-healing for bitrot**

* Required: bitrot par2 grep find libc-bin(getconf) coreutils(rm mv cp mkdir cd du)
* Usage:
```
healbitrot [-h|--help] [<dir>...]
      <dir>:  directory to check; only if none given, the file in \$BITROT_DIRS
      is read, one directory per line. Bitrot data is stored in \$BITROT_DATA.
      -h/--help:  display this help text
```

**The python script `bitrot` is included**

## instai
**User-(un)install AppImage with icon and .desktop file**

* Usage: 'instai [-l|--list] [-u|--uninstall] <AppImage>'

## parsejson
**Parse JSON with bash**
* Usage:  `parsejson [ -h|--help | <string> | <filename> ]`
* When no argument is given, input is read on stdin.

## keepassx.sh
**Unpack selfmake archive script**

* Required: makeself find sudo sed

## keepassx2pass.py
**Convert KeePassX xml export to pass store**

* Usage: `keepassx2pass.py keepassx.xml`

## keepassxml2json
**Convert KeePassX xml export to json for Ironclad**

* Usage: `keepassxml2json [-d|--debug] <in.xml> <out.json>`
* Required: grep sed coreutils(tail tr cd mv rm ls)

## KeeWeb.html
**Browser-based KeePass application**

## kenburns
* Required: ruby ffmpeg
* Usage:
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

## kpt2bitwarden
**Enter keepassx text into bitwarden .csv format**

* Usage: `kpt2bitwarden keepassx.xml >bitwarden.csv`

## localdebs
**Create a local repo for deb packages**

## mailout
**Send mail according to template and CSV**
* Usage: `mailout [-s|--send]`
If the -s/--send flag is not given, no mails will be actually be sent.
The file mail.template is the body of the email and contains CSV header
names enclosed by "{{" and "}}", like: {{password}}. The CSV header field
designated by the variable 'emailheader' must be present and is used to send
the emails to. If variables 'firstnameheader' and 'lastnameheader' are set
(to a header field of the CSV file), then the mails will be addressed to:
"{{$firstname}} {{$lastname}} <{{$email}}>" instead of "{{$email}}".
* Input files: `$csv` `$template` (set in script)
* Required: mailer[github.com/pepa65/mailer] sed csvtool coreutils(wc)
* Set appropriate values to all required variables in the script.

## makeself
**Create self-extracting tar.gz archive**

## mathsym
**Convert ASCII a-z/A-Z/0-9 into 'Math' symbols from Unicode block 1D400-7FF**

```
mathsym - Convert ASCII a-z/A-Z/0-9 into 'Math' symbols from Unicode block 1D400-7FF
Usage:  mathsym ([<format>] <string>)...
    <format>:
SHORT   IN FULL                  A-Z,a-z UNICODE    0-9 UNICODE    MISSING
^       Bold Serif               U+1D400-433        U+1D7CE-7D7
/       Italic Serif             U+1D434-467                       h
^/      Bold Italic Serif        U+1D468-48B                       EFHILMR
@       Script                   U+1D49C-4CF                       ego
^@      Bold Script              U+1D4D0-503
%       Fractur                  U+1D504-537                       CHIRZ
^%      Bold Fraktur             U+1D538-56B
=       Doublestruck             U+1D56C-59F        U+1D7D8-7E1    CHNPQRZ
-       Sansserif                U+1D5A0-5D3        U+1D7E2-7EB
^-      Bold Sansserif           U+1D5D4-607        U+1D7EC-7F5
/-      Italic Sansserif         U+1D608-63B
^/-     Bold Italic Sansserif    U+1D63C-66F
.       Monospaced               U+1D670-6A4        U+1D7F6-7FF
    Format can be specified SHORT or IN FULL (case insensitive).
    If no applicable <format> is given, <string> is rendered in Monospaced.
Beware of missing symbols in some ranges! Complete are:
 Bold Serif, Sansserif, Bold Sansserif and Monospaced.
```

## megadl
**Download mega.nz and MegaCrypter files**

* Usage:
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

## merge2ass
**Merge 2 subtitle files into one**

* Usage:
```
merge2ass <movie> <subtitle1> <subtitle2> [-p|--play-movie]
    or: `merge2ass --detect <movie> [-p | --play-movie]
    or: `merge2ass [-h | --help]
```

## mgcfs
**Manage access to gocryptfs encrypted directory**

* Required: gocryptfs(http://github.com/rfjakob/gocryptfs) fuse grep procps tar coreutils(cat rm type ls mktemp stat shred mkdir chmod sleep sync)
* Optional: zenity/whiptail/cryptsetup(askpass) <run>
* Optional environment variables: $MGCFS_MOUNT/DIR/NAME/RUN/PLAIN
* Usage:
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

## mkuki
**Create EFI Unified Kernel Image**

* Required: `coreutils`(`tr mktemp uname cat readlink wc mkdir cp ls head cut`) `grep sed`
  - install: `sudo efibootmgr fdisk mount`
* From: https://github.com/jirutka/efi-mkuki
* Usage:
```
mkuki v0.1.6 - Create EFI Unified Kernel Image
  An EFI Unified Kernel Image (UKI) is a single EFI PE executable that can
  combine an EFI stub loader, a kernel image, an initramfs image, a splash
  image, the kernel commandline, and CPU microcode images.
Usage: mkuki [<option>...]
<option>:
  -h|--help                Only display this help text
  -V|--version             Only display the version
  -I|--install             Install resulting UKI in '<esp>/EFI/Linux/'
  -l|--label <txt>         UEFI label in quotes for install (optional)
  -d|--device <device>     '<esp>' to use for install (optional)
  -k|--kernel <file>       Linux kernel file (default: '/boot/vmlinuz')
  -i|--initrd <file>       Initramfs file (default: '/boot/initrd.img')
  -m|--microcode <file>    Microcode file (optional, multiple allowed)
  -c|--cmdline <txt/file>  Kernel cmdline in quotes, or a file containing
                               it, start with / or . (default: '/proc/cmdline')
  -o|--output <file>       Output file (default: '')
  -r|--release <file>      Release file (default: '/etc/os-release')
  -s|--splash <file>       Splash image: BMP 800x600 24bit (optional)
  -e|--efistub <file>      EFI stub file (default: 'linux*.efi.stub') in
                           '/usr/lib/systemd/boot/efi', *: x64 | ia32 | aa64 | arm
```

## mvdocker
**Move docker container including volumes**

`Usage:  ./mvdocker [-i|--install] <container_id> [<container_options>]`

## noiseclean
**Filter out noise based on sample**

* Required: ffmpeg(ffmpeg ffprobe) sox

## pair.c
**Utility to pair Logitech USB unifying or nano receivers with wireless input devices**

See the file for instructions to compile and use.

## pdfslice
**Make a pdf from a page range in a source document**

* Usage:
```
Usage:  pdfslice [-h|--help ] | <range> <in.pdf> [<out.pdf>]
    Where <range> is:  [<from>],[<to>] | [<from>][+[<number>]]
      If <from> & <to> start with a minus sign they count from the back;
        if omitted they default to first & last page;
        <number> specifies the number of pages, if omitted defaults to 1.
    -h/--help:  Just display this help text.
```
* Required: poppler-utils(pdfseparate pdfunite pdfinfo) coreutils(mktemp rm ls)

## pp
**Settings to be included in .bashrc**

## deploy
**Provision virtual machine**
* Usage: `deploy <host> [=]`
  - `<host>`: Host from ~/.ssh/config
  - `=`: If `=` is given, setting up the authorized_key is skipped

## qemu-create-os-img
**Create a fresh Debian/Ubuntu qemu image**

* Usage:
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

## rmbg
**Make background of image transparent**
* Required: imagemagick(convert)

```
rmbg - Make background of image transparent
  Convert images into shaped transparent png files by floodfilling
  the background with transparency (antialiased alpha channel).
  Unless a different starting pixel is specified, the top left
  pixel is used as the 'background' color to remove and
  floodfill starts from all four image edges.
Usage:  rmbg [-f PCT] [-s|-S] [-p X,Y] [-v] <image>...
  -f <fuzz>     How strict to match the background, default 20%
  -s            Speedy antialiasing (much faster, slightly less acurate)
  -S            No antialiasing (faster still)
  -p <x>,<y>    Start from pixel at x,y instead of 0,0
  -v            Verbose operation
```

## rmkernels
**Remove old kernels from Debian/Ubuntu**

* Usage: `rmkernels`

## savedio
**Export saved.io links through the API into a json file, and convert it into 3 formats:
- A 'Netscape.html' file (supposedly) importable by Shaarli
- An encoded php-array that Shaarli uses as internal storage 'datastore.php'
- An html5 page with links**

* Required: wget date jq gzip coreutils(base64 head tail)
* Environment variables: `SAVEDIO_KEY` `SAVEDIO_DEVKEY` `SAVEDIO_DIR`

## safetext
**Sanitize potentially identifying invisible characters**

* Default spelling lists included: `US.safetext` and `UK.safetext`

## scrypt.c
**Mount LUKS encrypted vault as non-root**

* Adjust the #define variables at the top of `scrypt.c` before compiling
* Install for all users:
  - `sudo gcc scrypt.c -o /usr/local/bin/scrypt`
  - `sudo chmod u+s /usr/local/bin/scrypt`
  - `sudo ln -s /usr/local/bin/scrypt /usr/local/bin/uscrypt`
* Install instead for local user only:
  - `sudo gcc scrypt.c -o ~/bin/scrypt`
  - `sudo chmod 4501 ~/bin/scrypt`
  - `sudo ln -s ~/bin/scrypt ~/bin/uscrypt`
* Example vault creation (matching the variables):
   - `truncate -s 400M /data/MyDocuments/SECURE/vault`
  - `sudo cryptsetup -I hmac-sha256 luksFormat /data/MyDocuments/SECURE/vault`
  - `sudo cryptsetup luksOpen /data/MyDocuments/SECURE/vault vault`
  - `sudo mkfs.ext4 /dev/mapper/vault`

## sct.c
**Utility to set the screen "temperature" to adjust the red-blue balance**

See the file for instructions on how to compile and use.

## spc2tab
**Convert leading spaces into tabs**

* Usage: `spc2tab [TABSIZE]  <INPUTFILE`
  - Pipe/redirect input to stdin!

## spd
**Commandline interface for testing internet bandwidth using speedtest.net**

* Usage:
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

## srtshift
**Shift times in a .srt subtitle file**
* Usage:  `srtshift <srt-file> <time>`
* `<srt-file>` is the .srt subtitle filename
* `<shift>` is the timeshift in full milliseconds
* Output: stdout

## subs
**Download subtitles from subscene.com**

* Usage: `subs -h|--help | <search terms>`

## subshift
**Subtitle conversion tool**

* Usage:
```
subshift <infile.sub/srt> <outfile.sub/srt> [action...]
  action: (+|-)<frames>              [Shift in frames]
          (+|-)<hh>:<mm>:<ss>.<ms>   [Shift in time]
          *<s>.<ms>                  [Time stretch/contract factor in seconds]
          @<framerate>               [like: 23.976 / 25 / 29.97]'
```

## ti
**Show images with filename in terminal using Sixel**

## tn
**Try TCP on host & port**

* Required: perl

## tpm
**Terminal Password Manager (uses standard 'pass' database)**

* Copyright: **2013-2016 Sören Tempel, 2019 pepa65**
* License: **GPL3+**
* Usage: 'tpm <command> <entry>'
  - command: help / show / insert / delete
* Environment variables: `TPM_DIR` `TPM_KEY`

## transfer
**Transfer files via transfer.sh**

* Features:
  - For upload (files and directories) and download (https:// links)
  - En/decryption option (gpg)
  - Gives a single link for multiple files or directories (tar/zip)
  - Display QR code option for links (qrencode)
* Required: `curl`
* Optional: `gpg tar qrencode`

## unsubscribe.php
**Facilitate list-unsubscribe links**

## w2usb
**Write image/hybridiso to (USB) disk device**

* Usage: 'w2usb <dev> <file>'

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

## ypass
**GUI for 'pass' the standard unix password manager**

Yad GUI frontend for pass, the standard unix password manager.
Can view, edit and delete.

* Required: yad pass coreutils(type sleep shred ls) sed diffutils(diff).

## yt2srt
**Convert YouTube subtitles to .srt**

* Usage: `yt2srt <input file>`

