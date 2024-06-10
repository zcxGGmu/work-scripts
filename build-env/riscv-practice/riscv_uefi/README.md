# RISC-V QEMU virt platform
The minimum QEMU version required is [8.1](https://wiki.qemu.org/Planning/8.1) or with commit [7efd65423a](https://github.com/qemu/qemu/commit/7efd65423ab22e6f5890ca08ae40c84d6660242f) which supports separate pflash devices for EDK2 code and variable storage.

## build qemu

    git clone https://github.com/qemu/qemu.git
    cd qemu
    git submodule update --init
    ./configure --target-list=riscv64-softmmu;make -j $(nproc)
    cd -


## build edk2

    git clone --recurse-submodule https://github.com/tianocore/edk2.git edk2

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

## linux
    git clone --branch riscv_acpi https://github.com/ventanamicro/linux.git linux
    cd linux
    make ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- defconfig
    make ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- -j $(nproc)
    cd -

## opensbi
    git clone https://github.com/riscv-software-src/opensbi.git
    cd opensbi
    make ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- PLATFORM=generic -j $(nproc)
    cp build/platform/generic/firmware/fw_dynamic.bin ../
    cd -

 ## buildroot
    git clone https://github.com/buildroot/buildroot.git
    cd buildroot
    make qemu_riscv64_virt_defconfig
    make rootfs-ext2
    cd -
