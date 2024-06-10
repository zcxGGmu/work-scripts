#! /bin/bash

export ARCH=riscv
export CROSS_COMPILE=riscv64-unknown-linux-gnu-

# make rootfs
tar jxvf busybox-1.36.1.tar.bz2
cp -f busybox-1.36.1_defconfig busybox-1.36.1/.config
make -C busybox-1.36.1 oldconfig -j32
make -C busybox-1.36.1 install -j32

mkdir -p busybox-1.36.1/_install/dev
mkdir -p busybox-1.36.1/_install/proc
mkdir -p busybox-1.36.1/_install/sys
mkdir -p busybox-1.36.1/_install/tmp
cp -f init busybox-1.36.1/_install/init

cd busybox-1.36.1/_install; find ./ | cpio -o -H newc > ../../rootfs.cpio; cd -

