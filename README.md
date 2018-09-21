# ODROID-C1-FreeBSD

## Prerequisites
You need a working FreeBSD installation with an installed source-tree

Clone this repo: `git clone https://github.com/KizzyCode/ODROID-C1-FreeBSD ~/odroidc1`

## Create our root partition
```sh
# Become root and change into our working dir
su
cd ~/odroidc1/build

# Create an image for the root partition and attach it to `/dev/md0`
truncate -s 1024M root.img
mdconfig -f root.img -u0

# Create a new FS in the image and mount it
# ! Make sure that `/dev/md0` is your image !
newfs /dev/md0
mount /dev/md0 /mnt

# Build FreeBSD for ARMv6 and install it into the root image
cd /usr/src
make clean
make -j8 TARGET_ARCH=armv6 kernel-toolchain
make -j8 TARGET_ARCH=armv6 KERNCONF=ODROIDC1 buildkernel
make -j8 TARGET_ARCH=armv6 buildworld
make -j8 TARGET_ARCH=armv6 DESTDIR=/mnt installworld distribution

# Copy the `fstab` to the root image
cp fstab /mnt/etc/

# Unmount and detach the root image
umount /mnt
mdconfig -d -u0
```

## Create and attach our SD-card image
```sh
cd ~/odroidc1/build

# Create the SD-card image and attach it to `/dev/md0`
truncate -s 2048M sd.img
mdconfig -f sd.img -u0
```

## Install our bootloader and prepare the SD card
You need to either download my precompiled bootloader or [compile it yourself](https://github.com/KizzyCode/ODROID-C1-FreeBSD/blob/master/sd_fuse/build_under_fedora.md).

For now I assume that you use the precompiled version:
```sh
cd ~/odroidc1/build/sd_fuse

# ! Make sure that `/dev/md0` is your image !
bash ./sd_fusing.sh /dev/md0
```

## Prepare the boot partition
```sh
cd ~/odroidc1/build

# ! Make sure that `/dev/md0` is your image !
mount -t msdosfs /dev/md0 /mnt

# Copy the boot files
cp /usr/obj/arm.armv6/usr/src/sys/ODROIDC1/kernel.bin /mnt/
cp boot.ini /mnt/
umount /mnt
```

## Copy our root partition to the SD-card image
```sh
# ! Make sure that `/dev/md0` is your image !
dd if=root.img of=/dev/md0s2 bs=4096k

# Adjust the partition size
# ! Make sure that `/dev/md0` is your image !
growfs /dev/md0s2
```

## See also
[The FreeBSD wiki page](https://wiki.freebsd.org/FreeBSD/arm/Odroid-C1) which was the source for this project.
