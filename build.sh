#!/bin/bash

echo 'Running TerraOS build script'

# Assemble the bootloader
echo 'Building Bootloader...'
nasm -f bin boot/boot.asm -o boot.bin || exit 1

# Assemble the kernel
echo 'Building Kernel...'
nasm -f elf32 kernel/kernel.asm -o kernel.o || exit 1

# Link the kernel
echo 'Linking files...'
ld -T kernel/linker.ld -o kernel.elf kernel.o || exit 1

# Convert the kernel to a binary
echo 'Converting to binary...'
objcopy -O binary kernel.elf kernel.bin || exit 1

# Combine the bootloader and kernel
echo 'Combining builds...'
cat boot.bin kernel.bin > os_image.bin || exit 1

echo 'Build successfull!'
echo "[DEBUG] required number of sections:"
echo $(( $(stat -c%s kernel.bin) / 512 + 1 ))

# Run the OS in QEMU
echo 'Running TerraOS'
qemu-system-x86_64 -drive format=raw,file=os_image.bin

# qemu-system-x86_64 -drive format=raw,file=os_image.bin -no-reboot -d int
