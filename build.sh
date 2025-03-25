#!/bin/bash

echo 'Building TerraOS...'

# Assemble the bootloader
nasm -f bin boot/boot.asm -o boot.bin || exit 1

# Assemble the kernel
nasm -f elf32 kernel/kernel.asm -o kernel.o || exit 1

# Link the kernel
ld -T kernel/linker.ld -o kernel.elf kernel.o || exit 1

# Convert the kernel to a binary
objcopy -O binary kernel.elf kernel.bin || exit 1

# Combine the bootloader and kernel
cat boot.bin kernel.bin > os_image.bin || exit 1

# Run the OS in QEMU
qemu-system-x86_64 -drive format=raw,file=os_image.bin