[bits 32]
section .text
global kernel_main

kernel_main:
    cli
    mov esp, 0x90000
    mov ebp, esp

    call clear_screen

    mov esi, message
    call print_terraOS

hang:
    hlt
    jmp hang

clear_screen:
    cli
    pusha
    mov edi, 0xB8000
    mov ecx, 80 * 25
    mov eax, 0x0F20
    rep stosw
    popa
    sti
    ret

print_terraOS:

    cli
    ; mov edi, 0xB8000 + (12 * 160) + (36 * 2)
    mov edi, 0xB8000
.yee:
    mov byte [edi], 'E'
    add edi, 2
    mov byte [edi], 'A'
    add edi, 2
    jmp .yee

.k_loop:
    lodsb
    test al, al ; issue
    jz .k_done ; issue

    mov byte [edi], al
    mov byte [edi + 1], 0x0F
    add edi, 2

    jmp .k_loop

.k_done:
    mov edi, 0xB8000
    mov byte [edi], 'G'
    ; jmp .k_loop
    ret

message db "TerraOS", 0

section .bss
resb 4096
stack_top:
