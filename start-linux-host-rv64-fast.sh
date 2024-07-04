#!/bin/bash

$QEMU/qemu-system-riscv64 \
    -M virt \
    -cpu rv64,v=true \
    -m 4G -nographic \
    -smp 8 \
    -kernel $LINUX/Image \
    -append "root=/dev/vda rw console=ttyS0 loglevel=3 earlycon=sbi" \
    -drive file=$ROOTFS/rootfs.ext4,format=raw,id=hd0,cache=writeback \
    -device virtio-blk-pci,drive=hd0 \
    -netdev user,id=usernet,hostfwd=tcp:127.0.0.1:7722-0.0.0.0:22 \
    -device virtio-net-pci,netdev=usernet \
    -rtc clock=host,base=utc

