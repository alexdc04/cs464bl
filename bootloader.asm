; bootloader.asm (512 bytes)
[org 0x7C00] 
bits 16

start:
    ; Setup basic segments
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    ; Print bootloader starting message
    mov si, msg
    call print_string

    ; Create space at segment 0x1000 to load kernel
    mov ax, 0x1000
    mov es, ax
    xor bx, bx

    ; Read kernel into memory at ES:BX
    call read_kernel
    jc disk_fail

    ; Jump to loaded kernel
    jmp 0x1000:0x0000

disk_fail:
    ; If failed to load kernel, print error and halt
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
    mov ah, 0x02            ; BIOS function: read sectors
    mov al, 0x01            ; Read 1 sector
    mov ch, 0               ; Cylinder 0
    mov cl, 2               ; Sector 2
    mov dh, 0               ; Head 0
    mov dl, 0x00            ; Drive 0 (floppy) - use 0x80 for HDD
    int 0x13
    ret

; Messages
msg     db "bootloader starting...", 0
msg_err db "disk error!", 0

; Pad bootloader to 512 bytes
times 510-($-$$) db 0
dw 0xAA55
