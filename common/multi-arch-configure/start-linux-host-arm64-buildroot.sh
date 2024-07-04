#!/bin/bash

$QEMU/qemu-system-aarch64 \
	-M virt -m 4G -cpu cortex-a53 \
	-nographic -kernel $LINUX/Image \
	-drive file=$ROOTFS/rootfs.ext4,format=raw,if=none,id=disk0 \
	-device virtio-blk-device,drive=disk0 \
	-append "root=/dev/vda rw console=ttyAMA0"
