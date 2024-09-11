#!/bin/bash

$QEMU/qemu-system-riscv64 \
	-M virt,aia=aplic-imsic,aia-guests=5 \
	-cpu rv64,smaia=true,ssaia=true,smcdeleg=true,ssccfg=true,smcntrpmf=true,sscofpmf=true,sscsrind=true,smcsrind=true,smctr=true,ssctr=true \
	-m 4G -nographic \
	-smp 4 \
	-kernel $LINUX/Image \
	-append "root=/dev/vda rw console=ttyS0 loglevel=3 earlycon=sbi" \
	-drive file=$ROOTFS/rootfs.ext4,format=raw,id=hd0,cache=writeback \
	-device virtio-blk-pci,drive=hd0 \
	-netdev user,id=usernet,hostfwd=tcp:127.0.0.1:7722-0.0.0.0:22 \
	-device virtio-net-pci,netdev=usernet -L $QEMU_SRC/pc-bios/ \
	-rtc clock=host,base=utc

