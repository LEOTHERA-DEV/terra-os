[bits 32]
section .text
global kernel_main

kernel_main:
    cli
    mov ax, 0x10
    mov ds, ax
    mov es, ax

    mov esp, 0x90000
    mov ebp, esp

    call clear_screen
    call print_message

hang:
    hlt
    jmp hang

clear_screen:
    pusha
    mov edi, 0xB8000
    mov ecx, 80 * 25
    mov eax, 0x07200720
    rep stosd
    popa
    ret

print_message:
    pusha
    mov edi, 0xB8000
    mov esi, message

.print_loop:
    lodsb
    test al, al
    jz .done

    mov [edi], al
    mov byte [edi + 1], 0x0F
    add edi, 2
    jmp .print_loop

.done:
    popa
    ret

section .data
message db "Terra OS Boot build ver 0.0.1", 0