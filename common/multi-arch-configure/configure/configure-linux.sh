#!/bin/bash

# Prompt the user to enter the architecture type
read -p "Please enter the architecture type (arm64/riscv): " ARCH_TYPE

# Check user input
if [ "$ARCH_TYPE" != "arm64" ] && [ "$ARCH_TYPE" != "riscv" ]; then
  echo "Invalid architecture type. Please enter 'arm64' or 'riscv'."
  exit 1
fi

# Set compile parameters
if [ "$ARCH_TYPE" == "arm64" ]; then
  ARCH="arm64"
  CROSS_COMPILE="aarch64-none-linux-gnu-"
elif [ "$ARCH_TYPE" == "riscv" ]; then
  ARCH="riscv"
  CROSS_COMPILE="riscv64-unknown-linux-gnu-"
fi

# Print configuration
echo "Configuring and compiling the kernel for architecture: $ARCH_TYPE"

# Export compile environment variables
export ARCH=$ARCH
export CROSS_COMPILE=$CROSS_COMPILE

# Remove and create the build directory
rm -rf ./build/
make mrproper
mkdir build

# Configure and compile the kernel
make O=build defconfig
make O=build -j $(nproc)

echo "Kernel compilation is complete."

