#!/bin/bash

$QEMU/qemu-system-x86_64 \
    -cpu host -M q35 --enable-kvm \
    -m 512M -nographic \
    -kernel $LINUX/bzImage \
    -initrd $ROOTFS/rootfs_kvm_x86.img \
    -virtfs local,path=/home/zq/shared,mount_tag=host0,security_model=passthrough,id=host0 \
    -append "root=/dev/ram rw console=ttyS0 earlycon=ttyS0"

