#!/bin/sh

$QEMU/qemu-system-riscv64 \
	-M virt --enable-kvm \
	-cpu rv64 \
	-m 256m  \
	-kernel $LINUX/Image \
	-append "rootwait root=/dev/vda ro" \
	-drive file=$ROOTFS/rootfs.ext4,format=raw,id=hd0 \
	-device virtio-blk-device,drive=hd0 \
	-nographic 
