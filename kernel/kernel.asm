[bits 32]

section .data
frame_offset dd 0

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

main_loop:
    call color_test
    call delay
    jmp main_loop

hang:
    hlt
    jmp hang

color_test:
    mov edi, 0xA0000
    mov ecx, 320*200
    xor eax, eax
    xor ebx, ebx
    xor edx, edx

    mov esi, [frame_offset]

.fill_loop:
    mov al, bl
    add al, dl
    add ax, si
    add al, ah

    mov [edi], al
    inc edi

    inc bx
    cmp bx, 320
    jne .next_pixel
    xor bx, bx
    inc dl

.next_pixel:
    loop .fill_loop

    inc dword [frame_offset]

    ret

delay:
    pusha
    mov ecx, 0xFFFFFF
.delay_loop:
    dec ecx
    jnz .delay_loop
    popa
    ret