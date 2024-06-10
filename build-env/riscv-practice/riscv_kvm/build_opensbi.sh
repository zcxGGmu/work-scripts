#!/bin/bash

export ARCH=riscv
export CROSS_COMPILE=riscv64-unknown-linux-gnu-
git clone https://github.com/riscv-software-src/opensbi.git
cd opensbi
make PLATFORM=generic -j $(nproc)
cd -
