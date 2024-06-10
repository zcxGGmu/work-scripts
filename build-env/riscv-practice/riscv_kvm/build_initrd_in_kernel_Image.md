# Build initrd in kernel Image

## Build initrd

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

   cd busybox-1.36.1/_install; find ./ | cpio -o -H newc > ../../rootfs.cpio.gz; cd -


## Modify kernel config

    cd linux
    make ARCH=riscv CROSS_COMPILE=riscv64-unknown-linux-gnu- defconfig

    CONFIG_INITRAMFS_SOURCE="../rootfs.cpio.gz"
    CONFIG_INITRAMFS_ROOT_UID=0
    CONFIG_INITRAMFS_ROOT_GID=0
    CONFIG_RD_GZIP=y

    make ARCH=riscv CROSS_COMPILE=riscv64-unknown-linux-gnu- -j $(nproc)

    cd -
## Lunch the VM

    qemu-system-riscv64 -cpu rv64 -M virt -m 512M -nographic -bios opensbi/build/platform/generic/firmware/fw_jump.bin -kernel linux/arch/riscv/boot/Image
