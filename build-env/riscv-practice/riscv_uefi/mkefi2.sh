#! /bin/bash

WORK=`pwd`
mkfs.msdos -C efi2.img 65536
DEV=$(losetup -f)
sudo losetup $DEV efi2.img
sudo mount $DEV /mnt
sudo cp $WORK/linux/arch/riscv/boot/Image /mnt
#sudo cp ./rootfs.cpio /mnt
sudo umount /mnt
sudo losetup -d $DEV
