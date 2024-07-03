#!/bin/bash

$QEMU/build/qemu-system-riscv64 \
	-cpu rv64,v=true -M virt -m 512M -nographic \
	-kernel $LINUX/build/arch/riscv/boot/Image \
	-initrd ./rootfs_kvm_riscv64.img \
	-append "root=/dev/ram rw console=ttyS0 earlycon=sbi" \
	-drive file=./my_vm_disk.qcow2,if=none,id=hd0,format=qcow2 \
	-device virtio-blk-device,drive=hd0 \
	-netdev user,id=usernet,hostfwd=tcp:127.0.0.1:7723-0.0.0.0:22 \
	-device e1000e,netdev=usernet

