# KVM RISCV64 on QEMU

## Build Qemu
You can skip this step if `qemu-system-riscv64` tool has existed in your building environment.

    #install dependency
    sudo apt install libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev -y
    git clone https://gitlab.com/qemu-project/qemu.git
    cd qemu
    git submodule update --init --recursive
    ./configure --target-list="riscv32-softmmu riscv64-softmmu"
    make -j $(nproc)
    cd -

## Build linux kernel for host and guest

    # install dependency
    sudo apt install libelf-dev
    sudo apt install libssl-dev

    export ARCH=riscv
    export CROSS_COMPILE=riscv64-unknown-linux-gnu-
    git clone https://github.com/kvm-riscv/linux.git
    mkdir riscv-linux
    make -C linux O=`pwd`/riscv-linux defconfig
    make -C linux O=`pwd`/riscv-linux -j $(nproc)

## Build libfdt and kvmtool
We need libfdt library in the cross-compile toolchain for compiling KVMTOOL RISC-V. The libfdt library is generally not available in the cross-compile toolchain so we need to explicitly compile libfdt from DTC project and add it to CROSS_COMPILE SYSROOT directory.

### Build libdft
    export ARCH=riscv
    export CROSS_COMPILE=riscv64-unknown-linux-gnu-
    export CC="${CROSS_COMPILE}gcc -mabi=lp64d -march=rv64gc"
    TRIPLET=$($CC -dumpmachine)
    SYSROOT=$($CC -print-sysroot)
    git clone https://git.kernel.org/pub/scm/utils/dtc/dtc.git
    cd dtc
    make libfdt -j $(nproc)
    make NO_PYTHON=1 NO_YAML=1 DESTDIR=$SYSROOT PREFIX=/usr LIBDIR=/usr/lib64/lp64d install-lib install-includes
    cd -

### Build kvmtool

    export ARCH=riscv
    export CROSS_COMPILE=riscv64-unknown-linux-gnu-
    git clone https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git
    cd kvmtool
    make lkvm-static -j $(nproc)
    ${CROSS_COMPILE}strip lkvm-static
    cd -

## Build OpenSBI

    export ARCH=riscv
    export CROSS_COMPILE=riscv64-unknown-linux-gnu-
    git clone https://github.com/riscv-software-src/opensbi.git
    cd opensbi
    make PLATFORM=generic -j $(nproc)
    cd -

## Make rootfs

    export ARCH=riscv
    export CROSS_COMPILE=riscv64-unknown-linux-gnu-

    wget https://busybox.net/downloads/busybox-1.36.1.tar.bz2
    tar jxvf busybox-1.36.1.tar.bz2
    cp -f busybox-1.36.1_defconfig busybox-1.36.1/.config
    make -C busybox-1.36.1 oldconfig -j32
    make -C busybox-1.36.1 install -j32

    mkdir -p busybox-1.36.1/_install/etc/init.d
    mkdir -p busybox-1.36.1/_install/dev
    mkdir -p busybox-1.36.1/_install/proc
    mkdir -p busybox-1.36.1/_install/sys
    mkdir -p busybox-1.36.1/_install/modules
    ln -sf /sbin/init busybox-1.36.1/_install/init
    cp -f fstab busybox-1.36.1/_install/etc/
    cp -f rcS busybox-1.36.1/_install/etc/init.d/
    cp -f welcome busybox-1.36.1/_install/etc/
    cp -f kvmtool/lkvm-static busybox-1.36.1/_install/usr/bin/
    cp -f riscv-linux/arch/riscv/boot/Image busybox-1.36.1/_install/modules/
    cp -f riscv-linux/arch/riscv/kvm/kvm.ko busybox-1.36.1/_install/modules/

    cd busybox-1.36.1/_install; find ./ | cpio -o -H newc > ../../rootfs_kvm_riscv64.img; cd -

## Run QEMU
Using OpenSBI emulated in qemu

    qemu-system-riscv64 -cpu rv64 -M virt -m 512M -nographic -kernel riscv-linux/arch/riscv/boot/Image -initrd ./rootfs_kvm_riscv64.img -append "root=/dev/root rw console=ttyS0 earlycon=sbi"

Using OpenSBI firmware

    qemu-system-riscv64 -cpu rv64 -M virt -m 512M -nographic -bios opensbi/build/platform/generic/firmware/fw_jump.bin -kernel riscv-linux/arch/riscv/boot/Image -initrd ./rootfs_kvm_riscv64.img -append "root=/dev/root rw console=ttyS0 earlycon=sbi"

```

OpenSBI v1.3-21-gea6533a
   ____                    _____ ____ _____
  / __ \                  / ____|  _ \_   _|
 | |  | |_ __   ___ _ __ | (___ | |_) || |
 | |  | | '_ \ / _ \ '_ \ \___ \|  _ < | |
 | |__| | |_) |  __/ | | |____) | |_) || |_
  \____/| .__/ \___|_| |_|_____/|____/_____|
        | |
        |_|

```

load kvm module and launch the new VM in riscv linux on qemu, more detail in [output_log](testlog)

    insmod modules/kvm.ko
    lkvm-static run -m 128 -c4 --console serial -p "console=ttyS0 earlycon" -k /modules/Image --debug

[reference wiki](https://github.com/kvm-riscv/howto/wiki/KVM-RISCV64-on-QEMU)

