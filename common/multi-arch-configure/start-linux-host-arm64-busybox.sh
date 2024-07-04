#!/bin/bash

$QEMU/qemu-system-aarch64 \
	-M virt -m 4G -cpu cortex-a53 \
	-nographic -kernel $LINUX/Image \
	-initrd $ROOTFS/rootfs.img \
	-L $QEMU_SRC/pc-bios/ \
	-append "root=/dev/vda rw console=ttyAMA0"
