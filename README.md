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
