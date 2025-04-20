[bits 32]
section .text
global kernel_main

kernel_main:
    cli
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov esp, 0x90000
    mov ebp, esp

    call color_test

hang:
    hlt
    jmp hang

color_test:
    mov edi, 0xA0000
    mov ecx, 320*200
    xor eax, eax

.fill_loop:
    mov [edi], al
    inc edi
    inc eax
    loop .fill_loop

    ret