all: disk.img

bootloader.bin: bootloader.asm
	nasm -f bin bootloader.asm -o bootloader.bin

kernel_entry.o: switch_proc_mode.asm
	nasm -f elf32 switch_proc_mode.asm -o kernel_entry.o

kernel.o: kernel.c
	gcc -m32 -ffreestanding -c kernel.c -o kernel.o

kernel.bin: kernel_entry.o kernel.o linker.ld
	ld -m elf_i386 -T linker.ld kernel_entry.o kernel.o -o kernel.elf
	objcopy -O binary kernel.elf kernel.bin

disk.img: bootloader.bin kernel.bin
	dd if=/dev/zero of=disk.img bs=512 count=2880
	dd if=bootloader.bin of=disk.img conv=notrunc
	dd if=kernel.bin of=disk.img bs=512 seek=1 conv=notrunc

run: disk.img
	qemu-system-i386 -drive format=raw,file=disk.img

clean:
	rm -f *.bin *.o *.elf disk.img
