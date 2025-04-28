; bootloader.asm (512 bytes)
[org 0x7C00]
bits 16

start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    mov si, msg
    call print_string

    mov ax, 0x1000
    mov es, ax
    xor bx, bx
    call read_kernel
    jc disk_fail
    jmp 0x1000:0x0000

disk_fail:
    mov si, msg_err
    call print_string
    hlt

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

read_kernel:
    mov ah, 0x02
    mov al, 0x09
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, 0x00
    int 0x13
    ret

msg     db "bootloader starting...", 0
msg_err db "disk error!", 0

times 510-($-$$) db 0
dw 0xAA55
