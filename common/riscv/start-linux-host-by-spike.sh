#!/bin/bash

$SPIKE/spike \
	-m512 --isa rv64gch_zicntr_zihpm \
	--kernel $LINUX/build/arch/riscv/boot/Image \
	--initrd ./rootfs_kvm_riscv64.img opensbi/build/platform/generic/firmware/fw_jump.elf
