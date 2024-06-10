#! /bin/bash

export ARCH=riscv
export CROSS_COMPILE=riscv64-unknown-linux-gnu-

# make rootfs
wget https://busybox.net/downloads/busybox-1.36.1.tar.bz2
tar jxvf busybox-1.36.1.tar.bz2
cp -f busybox-1.36.1_defconfig busybox-1.36.1/.config
make -C busybox-1.36.1 oldconfig -j32
make -C busybox-1.36.1 install -j32

mkdir -p busybox-1.36.1/_install/etc/init.d
mkdir -p busybox-1.36.1/_install/dev
mkdir -p busybox-1.36.1/_install/proc
mkdir -p busybox-1.36.1/_install/sys
mkdir -p busybox-1.36.1/_install/modules
ln -sf /sbin/init busybox-1.36.1/_install/init
cp -f fstab busybox-1.36.1/_install/etc/
cp -f rcS busybox-1.36.1/_install/etc/init.d/
cp -f welcome busybox-1.36.1/_install/etc/
cp -f kvmtool/lkvm-static busybox-1.36.1/_install/usr/bin/
cp -f riscv-linux/arch/riscv/boot/Image busybox-1.36.1/_install/modules/
cp -f riscv-linux/arch/riscv/kvm/kvm.ko busybox-1.36.1/_install/modules/

cd busybox-1.36.1/_install; find ./ | cpio -o -H newc > ../../rootfs_kvm_riscv64.img; cd -

