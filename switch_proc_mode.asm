[bits 16]
switch_to_proc:         ; protected mode switch
    cli                 ; disable interrupts
    ; TODO: LOAD GLOBAL DATA TABLE DESCRIPTOR 
    mov eax, cr0        
    or eax, 0x1         ; enable proc mode in register cr0
    mov cr0, eax
    jmp CODE_SEG:start_32 ; jump to func below

[bits 32]               ; use 32 bit
start_32:
    ; TODO: update segment registers, setup stack, move to master boot record