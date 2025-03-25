[bits 32]
section .text
global kernel_main

kernel_main:
    cli
    mov esp, 0x90000
    mov ebp, esp

    call clear_screen
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
    xor al, al

    mov ax, 0x10
    mov ds, ax

    mov edi, 0xB8000
    mov esi, 0x11000

.k_loop:
    lodsb

    ; inc edi
    ; mov byte [edi + 1], 0x0F
    ; inc edi

    mov [edi], al
    mov byte [edi + 1], 0x0F
    add edi, 2

    test al, al
    jz .k_done
    
    jmp .k_loop

.k_done:
    mov byte [edi], 'G'
    ret

section .data
message db "TerraOS", 0

section .bss
resb 4096
stack_top:
