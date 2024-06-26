#!/bin/bash

$QEMU/qemu-system-x86_64 \
	-accel kvm \
	-kernel $LINUX/build/arch/x86/boot/bzImage \
	-boot c -m 2048M \
	-hda $BUILDROOT/output/images/rootfs.ext4 \
	-append "root=/dev/sda rw console=ttyS0,115200 acpi=off nokaslr" \
	-serial stdio -display none

