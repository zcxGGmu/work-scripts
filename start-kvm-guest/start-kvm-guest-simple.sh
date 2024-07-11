#!/bin/bash

$QEMU/qemu-system-riscv64 \
	-cpu rv64 -M virt --enable-kvm \
	-m 512M -nographic \
	-kernel $LINUX/Image \
	-initrd $ROOTFS/rootfs_kvm_riscv64.img \
	-virtfs local,path=/root/repo/shared,mount_tag=host0,security_model=passthrough,id=host0 \
	-append "root=/dev/ram rw console=ttyS0 earlycon=sbi"
