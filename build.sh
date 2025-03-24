#!/bin/bash

echo 'Build script for TerraOS'
echo 'Developed by LEOTHERA | Github: @GVBRIELLE-N'
sleep 2
clear

echo 'Running build process...'
sleep 1 #adding a delay because this shit hurts my eyes
# Bootloader
nasm -f bin boot/boot.asm -o boot.bin && echo 'boot.bin compiled!' || exit 1

echo 'Compiling kernel...'
# Kernel
nasm -f elf32 kernel/kernel.asm -o kernel.o && echo 'kernel.o compiled!' || exit 1

echo 'Compiling linking kernel to program...'
x86_64-elf-ld -T kernel/linker.ld -o kernel.bin kernel.o && echo 'kernel.bin compiled!' || exit 1

echo 'Combining builds and executing...'
# Combining
cat boot.bin kernel.bin > os_image.bin && echo 'TerraOS image compiled!' && echo 'Running TerraOS...' || exit 1
qemu-system-x86_64 -drive format=raw,file=os_image.bin
clear
echo 'Closing TerraOS...'