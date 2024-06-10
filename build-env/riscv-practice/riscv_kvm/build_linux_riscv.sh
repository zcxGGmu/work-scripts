#!/bin/bash

export ARCH=riscv
export CROSS_COMPILE=riscv64-unknown-linux-gnu-
git clone https://github.com/kvm-riscv/linux.git
mkdir riscv-linux
make -C linux O=`pwd`/riscv-linux defconfig
make -C linux O=`pwd`/riscv-linux -j $(nproc)
