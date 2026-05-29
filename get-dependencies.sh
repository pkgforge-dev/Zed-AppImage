#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm libmd libbsd

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

# If the application needs to be manually built that has to be done down here
BINARY=https://github.com/zed-industries/zed/releases/latest/download/zed-linux-$ARCH.tar.gz
if ! wget --retry-connrefused --tries=30 "$BINARY" 2>/tmp/download.log; then
	cat /tmp/download.log
	exit 1
fi
tar xfv ./zed-linux*.gz
rm -f ./zed-linux*.gz

awk -F'/' '/Location:/{print $(NF-1); exit}' /tmp/download.log > ~/version
