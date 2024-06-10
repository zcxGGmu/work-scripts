#!/bin/bash

cd busybox-1.33.1-kvm-riscv64/_install; find ./ | cpio -o -H newc > ../../rootfs_kvm_riscv64.img; cd -
