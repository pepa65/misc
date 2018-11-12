#!/bin/sh

# keepassx.sh - Unpack makeself archive script
# Requires: makeself find sudo sed
## Construct the SFX by:
##   makeself --target /tmp/keepassx-0.4.4 --xz . \
##     keepassx-0.4.4-1.mga6.x86_64.run \
##     "self-extracting archive for KeePassX 0.4.4" \
##     /tmp/keepassx-0.4.4/keepassx.sh
## (while in the directory containing this script and the usr-tree)

t=/tmp/keepassx-0.4.4
cd "$t"
sudo chown root:root -R usr
echo "Installing the following files:"
find usr -type f |sed 's@^@  /@'
sudo cp -a usr /
cd - >/dev/null
sudo rm -rf -- "$t"
echo "Installation successful"
