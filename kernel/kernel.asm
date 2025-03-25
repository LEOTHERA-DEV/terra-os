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
    mov edi, 0xB8000

.k_loop:
    lodsb

    mov [edi], esi

    ; inc edi
    ; mov byte [edi + 1], 0x0F
    ; inc edi

    mov [edi], al
    inc edi
    mov byte [edi + 1], 0x0E
    inc edi


    test al, al
    jz .k_done
    
    jmp .k_loop

.k_done:
    mov edi, 0xB8000
    mov byte [edi], 'G'
    ret

message db "TerraOS", 0

section .bss
resb 4096
stack_top:
