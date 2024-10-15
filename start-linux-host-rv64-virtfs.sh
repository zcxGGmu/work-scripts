#!/bin/bash

$QEMU/qemu-system-riscv64 \
    -M virt \
    -cpu rv64,v=true,sscofpmf=true \
    -m 4G -nographic \
    -smp 4 \
    -kernel $LINUX/Image \
    -append "root=/dev/vda rw console=ttyS0 loglevel=3 earlycon=sbi" \
    -drive file=$ROOTFS/rootfs.ext4,format=raw,id=hd0,cache=writeback \
    -device virtio-blk-pci,drive=hd0 \
    -virtfs local,path=/root/repo/shared,mount_tag=host0,security_model=passthrough,id=host0 \
    -rtc clock=host,base=utc
