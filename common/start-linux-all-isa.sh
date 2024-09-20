#!/bin/bash

$QEMU/qemu-system-riscv64 \
	-M virt,aia=aplic-imsic,aia-guests=5 \
	-cpu rv64,v=true,smaia=true,ssaia=true,smstateen=true,sscofpmf=true,svinval=true,svnapot=true,svpbmt=true,zacas=true,zbkb=true,zbkc=true,zbkx=true,zcb=true,zfh=true,zfhmin=true,zicond=true,zknd=true,zkne=true,zknh=true,zkr=true,zksed=true,zksh=true,zkt=true,ztso=true,zvbb=true,zvbc=true,zvfh=true,zvfhmin=true,zvkb=true,zvkg=true,zvkned=true,zvknha=true,zvknhb=true,zvksed=true,zvksh=true,zvkt=true \
	-m 4G -nographic \
	-smp 4 \
	-kernel $LINUX/Image \
	-append "root=/dev/vda rw console=ttyS0 loglevel=3 earlycon=sbi" \
	-drive file=$ROOTFS/rootfs.ext4,format=raw,id=hd0,cache=writeback \
	-device virtio-blk-pci,drive=hd0 \
	-netdev user,id=usernet,hostfwd=tcp:127.0.0.1:7722-0.0.0.0:22 \
	-device virtio-net-pci,netdev=usernet -L $QEMU_SRC/pc-bios/ \
	-rtc clock=host,base=utc

