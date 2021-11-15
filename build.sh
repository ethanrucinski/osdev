#!/bin/bash


if !(i686-elf-g++ -c kernel.c++ -o kernel.o -ffreestanding -O2 -Wall -Wextra -fno-exceptions -fno-rtti); then
    echo the kernel did not compile
    exit 1 
fi

i686-elf-gcc -T linker.ld -o myos.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc

# Verify we built a multiboot image
if !(grub-file --is-x86-multiboot myos.bin); then
  echo the file is not multiboot 
  exit 1
fi

# Rebuild system image
rm -rf isodir

mkdir -p isodir/boot/grub
cp myos.bin isodir/boot/myos.bin
cp grub.cfg isodir/boot/grub/grub.cfg
grub-mkrescue -o myos.iso isodir

qemu-system-i386 -cdrom myos.iso