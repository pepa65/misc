# misc
*miscellaneous utilities and programs*

## difth
**Show the differences between 2 Thai language input files 
and either produce a html file, or output result to the terminal**

Packages required: swath dwdiff

Usage:  `difth <file1> <file2> [<html-out>]`

file1 and file2 mandatory, file html-out optional (otherwise to stdout)

## count
**Count character occurrences in file**

Packages required: uni2ascii

Usage: `count <file> [-s]`

-s means sort by code point instead of frequency

## rmkernels
**Remove old kernels from Debian/Ubuntu**

Usage: `rmkernels`

## backup
**A utility to back up a list of files and directories**

Usage: `$self [-h|--help] [<backup-list> [<backup-file>]]`

## duckdns
**Update duckdns.org DDNS service**

Usage: `duckdns [date]`

## merge2ass
**Merge 2 subtitle files into one**

Usage: `merge2ass <movie> <subtitle1> <subtitle2> [-p|--play-movie]`
 or: `merge2ass --detect <movie> [-p | --play-movie]`
 or: `merge2ass [-h | --help]`

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
Required: wget, convert (imagemagick) [for peters projection]
```

## mountgcfs
**Mount gocryptfs encrypted directory**

Required: zenity fuse gocryptfs tar grep procps coreutils (and <command>)

Set <mount>, <dir> and <name> in this script (and optionally <command>)

Setup: `gocryptfs -init [-plaintextnames] <dir>/<name>`

Usage: `mountgcfs`

## healbitrot
**Automatic check and self-healing for bitrot**

 Required: bitrot, par2, grep, find, libc-bin(getconf), coreutils(rm,mv,cp,mkdir,cd,du)
```
Usage: healbitrot [<dir>]...
   <dir> are the directories to check
   if no directories specified, the file in $BITROT_BACKUPS_DEST is read
```

*The python script `bitrot` is included*

## spr
**Script to paste stdin to sprunge.us**

* Original: Copyright Han Boetes <hboetes@gmail.com>
* Modified by TerrorBite //github.com/TerrorBite
* Licence: public domain

Requires: any POSIX shell, netcat (nc), coreutils (cat, od), date (if /dev/urandom not present)

```
Usage examples:
    spr <file
    spr <<<$string
    spr  # end the input with Ctrl-D on a new line
```

## sct.c
**Utility to set the screen "temperature" to adjust the red-blue balance**

See the file for instructions to compile and use.
