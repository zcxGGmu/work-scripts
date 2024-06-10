#! /bin/bash

WORK=`pwd`

fallocate -l 512M efi.img
sgdisk -n 1:34: -t 1:EF00 $WORK/efi.img

sudo losetup -fP $WORK/efi.img
loopdev=`losetup -j $WORK/efi.img | awk -F: '{print $1}'`
efi_part="$loopdev"p1
sudo mkfs.msdos $efi_part
mkdir -p /tmp/mnt
sudo mount $efi_part /tmp/mnt/
sudo cp $WORK/linux/arch/riscv/boot/Image /tmp/mnt/
sudo umount /tmp/mnt
sudo losetup -D $loopdev
