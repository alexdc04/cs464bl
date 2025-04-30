# tools
AS = nasm
CC = gcc
LD = ld
OBJCOPY = objcopy

# flags
ASFLAGS = -f bin
CFLAGS  = -m32 -ffreestanding -c
LDFLAGS = -m elf_i386 -T link.ld

# files
BOOTLOADER_SRC = bootloader.asm
KERNEL_SRC = kernel.c
KERNEL_OBJ = kernel.o
KERNEL_BIN = kernel.bin
BOOTLOADER_BIN = bootloader.bin
DISK_IMG = disk.img

all: $(DISK_IMG)

$(BOOTLOADER_BIN): $(BOOTLOADER_SRC)
	$(AS) $(ASFLAGS) $< -o $@

$(KERNEL_OBJ): $(KERNEL_SRC)
	$(CC) $(CFLAGS) $< -o $@

$(KERNEL_BIN): $(KERNEL_OBJ) link.ld
	$(LD) $(LDFLAGS) -o $@ $<
	# OR: $(OBJCOPY) -O binary kernel.elf kernel.bin 

$(DISK_IMG): $(BOOTLOADER_BIN) $(KERNEL_BIN)
	cat $(BOOTLOADER_BIN) $(KERNEL_BIN) > $(DISK_IMG)

run: $(DISK_IMG)
	qemu-system-i386 -fda $(DISK_IMG)

clean:
	rm -f *.o *.bin *.img
