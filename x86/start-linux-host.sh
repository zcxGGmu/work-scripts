#!/bin/bash

$QEMU/qemu-system-x86_64 \
	-accel kvm \
	-kernel $LINUX/bzImage \
	-boot c -m 2048M \
	-hda $BUILDROOT/output/images/rootfs.ext4 \
	-append "root=/dev/sda rw console=ttyS0,115200 acpi=off nokaslr" \
	-virtfs local,path=/tmp/shared,mount_tag=host0,security_model=passthrough,id=host0 \
	-serial stdio -display none

