#!/bin/bash

rm -rf ./build
mkdir build && cd ./build

# Function to map user input to the correct target architecture
get_target_arch() {
    case $1 in
        x86)
            echo "x86_64-softmmu"
            ;;
        arm)
            echo "aarch64-softmmu"
            ;;
        riscv)
            echo "riscv64-softmmu"
            ;;
        *)
            echo ""
            ;;
    esac
}

# Prompt the user to enter the target architecture
echo "Please enter the target architecture (x86/arm/riscv):"
read USER_INPUT

# Get the target architecture based on user input
TARGET_ARCH=$(get_target_arch $USER_INPUT)

# Check if a valid target architecture was provided
if [ -z "$TARGET_ARCH" ]; then
    echo "Invalid target architecture. Please enter x86, arm, or riscv."
    exit 1
fi

# Configure with the provided target architecture
../configure --enable-kvm \
             --enable-slirp \
             --enable-plugins \
             --enable-virtfs \
             --enable-debug \
             --enable-vnc \
             --enable-werror \
             --enable-vhost-net \
             --target-list="$TARGET_ARCH"

# Check if the configuration was successful
if [ $? -ne 0 ]; then
    echo "Configuration failed"
    exit 1
fi

# Build QEMU
make -j$(nproc)

# Check if the build was successful
if [ $? -ne 0 ]; then
    echo "Build failed"
    exit 1
fi

echo "QEMU successfully configured and built for $TARGET_ARCH"
