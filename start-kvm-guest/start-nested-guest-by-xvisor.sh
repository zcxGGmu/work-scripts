#!/bin/bash

$QEMU/build/qemu-system-riscv64 \
	-M virt,aia=aplic-imsic \
	-m 4G -nographic \
	-bios $OPENSBI/build/platform/generic/firmware/fw_jump.bin \
	-kernel $XVISOR/build/vmm.bin \
	-initrd $XVISOR/build/disk.img \
	-append 'vmm.bootcmd="vfs mount initrd /;vfs run /boot.xscript;vfs cat /system/banner.txt"'
