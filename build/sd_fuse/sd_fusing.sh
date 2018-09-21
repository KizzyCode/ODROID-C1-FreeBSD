#
# (C) Copyright 2014 Hardkernel Co,.Ltd
#
#!/bin/bash
set -e

BL1="bl1.bin.hardkernel"
UBOOT="u-boot.bin"

if [[ -z "$1" ]]; then
        echo "usage ./sd_fusing.sh <SD card reader's device file>"
        exit 0
fi

if [[ ! -f "$BL1" ]]; then
        echo "Error: $BL1 is not exist."
        exit 0
fi

if [[ ! -f "$UBOOT" ]]; then
        echo "Error: $UBOOT is not exist."
        exit 0
fi

dd if="$BL1" of="$1" bs=512
dd if="$UBOOT" of="$1" bs=512 seek=64 conv=sync
dd if=/dev/zero of="$1" bs=512 seek=1024 count=64

gpart destroy -F "$1"
gpart create -s mbr "$1"

gpart add -t fat16 -b 1134 -s 64M "$1"
gpart add -t freebsd -b 132206 "$1"

dd if="$BL1" bs=512 count=1 of="$BL1".mbr.tmp
gpart bootcode -b "$BL1".mbr.tmp "$1"

newfs_msdos -F 16 "$1"s1
newfs "$1"s2

sync
echo
echo "*> SD-card has been prepared successfully"
