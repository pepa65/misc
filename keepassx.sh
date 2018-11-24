#!/bin/sh

# keepassx.sh - Unpack makeself archive helper script
# Required: makeself find sudo sed

## Construct the SFX by:
##   makeself --target /tmp/keepassx-0.4.4 --xz . \
##     keepassx-0.4.4-1.mga6.x86_64.run \
##     "self-extracting archive for KeePassX 0.4.4" \
##     /tmp/keepassx-0.4.4/keepassx.sh
## (while in the directory containing this script and the usr-tree)

t=/tmp/keepassx-0.4.4

if test "x$1" = "x-h" || "x$1" = "x--help"
then
	echo "keepassx.sh - Unpack makeself archive helper script"
	exit 0
fi

if ! cd "$t"
then
	echo "ABORT: directory '$t' should be there"
	exit 1
fi

if ! sudo chown root:root -R usr
then
	echo "ABORT: directory 'usr' should be here"
	exit 2
fi

echo "Installing the following files:"
find usr -type f |sed 's@^@  /@'
sudo cp -a usr /
cd - >/dev/null
sudo rm -rf -- "$t"
echo "Installation successful"
