[bits 16]           ; begin code in 16-bit real mode
[org 0x7c00]        ; load code at address 0x7c00
    mov ah, 0x0E    ; trigger BIOS teletype mode to print chars to screen
    mov al, 'H'     ; load character H into address AL (last byte of accumulator)
    int 0x10        ; call BIOS interrupt 0x10, prints char in AL
    mov al, 'i'     
    int 0x10        ; repeat above steps for character i
    cli             ; clear interrupts
    hlt             ; stop processor

times 510 - ($ - $$) db 0 ; pad the rest of the file with zeros to reach required file size
dw 0xAA55                 ; boot signature, tells BIOS that disk is bootable
