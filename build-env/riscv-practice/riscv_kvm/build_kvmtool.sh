#!/bin/bash

export ARCH=riscv
export CROSS_COMPILE=riscv64-unknown-linux-gnu-

# make libdft
export CC="${CROSS_COMPILE}gcc -mabi=lp64d -march=rv64gc"
TRIPLET=$($CC -dumpmachine)
SYSROOT=$($CC -print-sysroot)

git clone https://git.kernel.org/pub/scm/utils/dtc/dtc.git
cd dtc
make libfdt -j $(nproc)
make NO_PYTHON=1 NO_YAML=1 DESTDIR=$SYSROOT PREFIX=/usr LIBDIR=/usr/lib64/lp64d install-lib install-includes
cd -

# make kvmtool
git clone https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git
cd kvmtool
make lkvm-static -j $(nproc)
${CROSS_COMPILE}strip lkvm-static
cd -
