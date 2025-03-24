# Custom x86 Bootloader

This project is a simple custom bootloader for x86 systems. It starts in 16-bit real mode, performs basic hardware setup, then transitions the CPU to 32-bit protected mode and loads a simple kernel.

## Features
- Real mode initialization
- BIOS interrupt usage
- A20 line enabling
- Global Descriptor Table (GDT) setup
- Protected mode transition
- Kernel hand-off

## Tools Used
- NASM (Netwide Assembler)
- QEMU (for emulation)
- Bochs (for debugging)

## Build & Run
```bash
make
