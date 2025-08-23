[bits 32]

section .data
frame_offset dd 0

section .text
global kernel_main

kernel_main:
    cli
    ; Segment registers
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ;stack
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
    mov edi, 0xA0000 ; Start VGA graphics
    mov ecx, 320*200
    ; Clear Registers
    xor eax, eax
    xor ebx, ebx
    xor edx, edx

    mov esi, [frame_offset] ; Loading frame offset

.fill_loop:
    mov al, bl ; Colour = x position
    add al, dl ; add y
    add ax, si ; add frame offset
    add al, ah ; add variation

    mov [edi], al ; Set colour value to pixel
    inc edi ; move to next pixel

    inc bx ; move x
    cmp bx, 320 ; end of row
    jne .next_pixel
    xor bx, bx ; reset x
    inc dl ; move to next y value

.next_pixel:
    loop .fill_loop

    inc dword [frame_offset] ; increment frame offset

    ret

delay:
    pusha ; save registers
    mov ecx, 0xFFFFFF ; Big counter
.delay_loop:
    dec ecx
    jnz .delay_loop ; repeat until ecx = 0
    popa ; restore saved registers
    ret
