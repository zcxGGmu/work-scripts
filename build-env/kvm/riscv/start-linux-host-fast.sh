#!/bin/bash

$QEMU/qemu-system-riscv64 \
	-cpu rv64 -smp 4 \
	-M virt,aia=aplic-imsic,aia-guests=7 \
	-m 512M -nographic \
	-kernel $LINUX/arch/riscv/boot/Image \
	-initrd ./rootfs_kvm_riscv64.img \
	-append "root=/dev/ram rw console=ttyS0 earlycon=sbi"
