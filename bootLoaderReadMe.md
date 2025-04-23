The main bootloader code, organized into sections:

1. Setup Memory Segments
```
xor ax, ax
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x7C00
```
- Clears registers to 0.
- Sets the data segment (DS), extra segment (ES), and stack segment (SS) to 0.
- Initializes the stack pointer (SP) at 0x7C00.


2. Print Startup Message
```
mov si, msg
call print_string
```
- Loads the address of the msg ("bootloader starting...") into SI.
- Calls print_string, a subroutine that prints each character using BIOS interrupt 0x10.

3. Prepare to Load Kernel
```
mov ax, 0x1000
mov es, ax
xor bx, bx
```
- Sets ES:BX to 0x1000:0x0000 — this is where the kernel will be loaded.

4. Read Kernel from Disk
```
call read_kernel
jc disk_fail

```
- Calls read_kernel to read 1 sector from the disk.
- If there's a disk error (carry flag set), it jumps to the disk_fail routine.

5. Transfer Control to Kernel
```
jmp 0x1000:0x0000
```
- If the kernel loads successfully, jump to the memory address where it was loaded and start executing it.

6. Disk Read Error Handling
```
disk_fail:
    mov si, msg_err
    call print_string
    hlt
```
- If loading the kernel fails:
    Prints the error message disk error!
    Halts the CPU.


7. Subroutine: print_string
```
print_string:
    mov ah, 0x0E
.print_loop:
    lodsb
    test al, al
    jz .done
    int 0x10
    jmp .print_loop
.done:
    ret

```
- Uses BIOS interrupt 0x10 to print characters.
Loops through characters until a 0 byte (null terminator) is found.


8. Subroutine: read_kernel
```
read_kernel:
    mov ah, 0x02  ; BIOS function: read sectors
    mov al, 0x01  ; Read 1 sector
    mov ch, 0     ; Cylinder 0
    mov cl, 2     ; Sector 2
    mov dh, 0     ; Head 0
    mov dl, 0x00  ; Drive 0 (floppy) (use 0x80 for HDD)
    int 0x13
    ret

```
- Invokes BIOS interrupt 0x13 to read 1 sector (sector 2) into memory at ES:BX.
After loading, it returns to the caller.


9. Bootloader Messages
```
msg     db "bootloader starting...", 0
msg_err db "disk error!", 0
```
1) msg: Message printed at startup.
2) msg_err: Message printed on disk load failure.


10. Boot Sector Padding
```
times 510-($-$$) db 0
dw 0xAA55
```
- Fills the file to exactly 512 bytes.
Ends with magic number 0xAA55, which BIOS checks to verify the sector is bootable.


11) How to Assemble and Test

11.1) Assemble the Bootloader
```
make
```
11.2) Test with QEMU Emulator
```
qemu-system-x86_64 -drive format=raw,file=bootloader.bin
```
