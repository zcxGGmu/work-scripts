#! /bin/bash

./qemu-system-riscv64 \
-M virt,pflash0=pflash0,pflash1=pflash1,acpi=off \
-m 4096 -smp 2   -nographic -serial mon:stdio \
-device virtio-gpu-pci -full-screen \
-device qemu-xhci -device usb-kbd \
-device virtio-rng-pci \
-bios ./fw_dynamic.bin \
-blockdev node-name=pflash0,driver=file,read-only=on,filename=RISCV_VIRT_CODE.fd \
-blockdev node-name=pflash1,driver=file,filename=RISCV_VIRT_VARS.fd  \
-device virtio-blk-device,drive=hd0 \
-drive file=./efi.img,format=raw,id=hd0


./qemu-system-riscv64 \
-M virt,aia=aplic-imsic,aia-guests=7,pflash0=pflash0,pflash1=pflash1,acpi=on \
-m 4096 -smp 4  -nographic \
-serial mon:stdio \
-bios ./fw_dynamic.bin \
-blockdev node-name=pflash0,driver=file,read-only=on,filename=RISCV_VIRT_CODE.fd \
-blockdev node-name=pflash1,driver=file,filename=RISCV_VIRT_VARS.fd \
-device virtio-blk-device,drive=hd0 \
-drive file=./efi.img,format=raw,id=hd0

# not successful
./qemu-system-riscv64 -machine virt,aia=aplic-imsic -cpu rv64,sscofpmf=true \
-smp 8 -m 2G  -nographic -serial mon:stdio \
-bios opensbi/build/platform/generic/firmware/fw_dynamic.bin \
-drive file=RISCV_VIRT_CODE.fd,if=pflash,format=raw,unit=1 \
-drive file=RISCV_VIRT_VARS.fd,if=pflash,format=raw  \
-drive file=buildroot/output/images/rootfs.ext2,format=raw,id=hd0 \
-device virtio-blk-device,drive=hd0 \
-drive file=./efi.img,format=raw,id=hd1 \
-device virtio-blk-device,drive=hd1


