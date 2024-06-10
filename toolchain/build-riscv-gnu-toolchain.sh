#!/bin/bash

# install pre-indpency
sudo apt install autoconf automake autotools-dev curl python3 python3-pip libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev ninja-build git cmake libglib2.0-dev

# build and complie
git clone https://github.com/riscv/riscv-gnu-toolchain
cd riscv-gnu-toolchain
git rm qemu spike pk musl
git submodule update --init --recursive --progress
mkdir build && cd build
../configure --prefix=/opt/riscv64 --enable-multilib --target=riscv64-linux-multilib
sudo make linux -j8

# install
echo 'export PATH=/opt/riscv64/bin:$PATH' >> ~/.zshrc
source ~/.zshrc

riscv64-unknown-linux-gnu-gcc --version
