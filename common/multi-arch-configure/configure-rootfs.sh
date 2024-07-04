#!/bin/bash

# Prompt the user to enter the architecture type
read -p "Please enter the architecture type (arm64/riscv): " ARCH_TYPE

# Check user input
if [ "$ARCH_TYPE" != "arm64" ] && [ "$ARCH_TYPE" != "riscv" ]; then
  echo "Invalid architecture type. Please enter 'arm64' or 'riscv'."
  exit 1
fi

# Set build parameters based on architecture type
if [ "$ARCH_TYPE" == "arm64" ]; then
  DEFCONFIG="qemu_aarch64_virt_defconfig"
elif [ "$ARCH_TYPE" == "riscv" ]; then
  DEFCONFIG="qemu_riscv64_virt_defconfig"
fi

# Print configuration
echo "Configuring and compiling Buildroot for architecture: $ARCH_TYPE"

# Clean up any previous build
make clean

# Configure Buildroot
make $DEFCONFIG

# Compile Buildroot
make -j8

echo "Buildroot compilation is complete."

