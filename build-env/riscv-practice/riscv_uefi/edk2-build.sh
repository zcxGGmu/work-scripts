#! /bin/bash

if [ ! -d  edk2]; then
    git clone --recurse-submodule https://github.com/tianocore/edk2.git edk2
fi

export WORKSPACE=`pwd`
export GCC5_RISCV64_PREFIX=/usr/bin/riscv64-linux-gnu-
export PACKAGES_PATH=$WORKSPACE/edk2
export EDK_TOOLS_PATH=$WORKSPACE/edk2/BaseTools
source edk2/edksetup.sh
make -C edk2/BaseTools clean
make -C edk2/BaseTools
make -C edk2/BaseTools/Source/C
source edk2/edksetup.sh BaseTools
build -a RISCV64 --buildtarget RELEASE -p OvmfPkg/RiscVVirt/RiscVVirtQemu.dsc -t GCC5

cp Build/RiscVVirtQemu/RELEASE_GCC5/FV/RISCV_VIRT_CODE.fd ./
cp Build/RiscVVirtQemu/RELEASE_GCC5/FV/RISCV_VIRT_VARS.fd ./

truncate -s 32M RISCV_VIRT_CODE.fd
truncate -s 32M RISCV_VIRT_VARS.fd
