[BITS 16]
[ORG 0x7C00]

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

    call enable_a20

    mov ah, 0x00
    mov al, 0x13
    int 0x10

    mov ax, 0x1000
    mov es, ax
    xor bx, bx

    mov si, msg_loading
    call print

    mov ah, 0x02
    mov al, 20
    mov ch, 0
    mov dh, 0
    mov cl, 2
    int 0x13
    jc error

    mov si, msg_done
    call print

    mov si, msg_kernel_loaded
    call print

    call switch_to_pm
    hlt

print:
    mov ah, 0x0E

.loop:
    lodsb
    test al, al
    jz .done
    int 0x10
    jmp .loop

.done:
    ret

enable_a20:
    in al, 0x92
    or al, 2
    out 0x92, al
    ret

error:
    mov si, msg_error
    call print
    hlt

switch_to_pm:
    cli
    lgdt [gdt_descriptor]

    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp CODE_SEG:init_pm

[BITS 32]
init_pm:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov esp, 0x90000
    mov ebp, esp

    jmp CODE_SEG:0x10000

msg_loading db "Loading Kernel...", 0
msg_done    db "Done!", 0
msg_error   db "Error!", 0
msg_kernel_loaded db "Kernel Loaded!", 0

gdt:
    dq 0x0000000000000000
    dq 0x00CF9A000000FFFF
    dq 0x00CF92000000FFFF
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt - 1
    dd gdt

CODE_SEG equ 0x08
DATA_SEG equ 0x10

times 510-($-$$) db 0
dw 0xAA55