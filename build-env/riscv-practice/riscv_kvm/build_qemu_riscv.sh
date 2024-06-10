#!/bin/bash

git clone https://gitlab.com/qemu-project/qemu.git
cd qemu
git submodule update --init --recursive
./configure --target-list="riscv32-softmmu riscv64-softmmu"
make -j $(nproc)
cd -

