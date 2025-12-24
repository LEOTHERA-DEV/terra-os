[bits 32]

global idt_init

IDT_ENT_COUNT equ 256

struc idt_entry
	.offset_low resw 1
	.selector resw 1
	.zero resb 1
	.type_attr resb 1
	.offset_high resw 1
endstruc

section .bss
align 8
idt_table:
	resb IDT_ENT_COUNT * 8

section .data
idt_descriptor:
	dw IDT_ENT_COUNT *8 - 1
	dd idt_table

section .text

set_idt_gate:
	push edx

	mov edx, idt_table
	lea edx, [edx + ebx*8]

	mov word [edx + 0], ax
	mov word [edx + 2], 0x08
	mov byte [edx + 4], 0
	mov byte [edx + 5], 0x8E

	shr eax, 16
	mov word [edx + 6], ax

	pop edx
	ret

pic_remap:
	mov al, 0x11
	out 0x20, al
	out 0xA0, al

	mov al, 0x20
	out 0x21, al
	mov al, 0x28
	out 0xA1, al

	mov al, 4
	out 0x21, al
	mov al, 2
	out 0xA1, al

	mov al, 1
	out 0x21, al
	out 0xA1, al

	mov al, 0
	out 0x21, al
	out 0xA1, al
	ret

default_int_handler:
	pusha

	mov al, 0x20
	out 0x20, al

	popa
	iret

idt_init:
	cli

	call pic_remap

	mov ebx, 0

.next:
	mov eax, default_int_handler
	call set_idt_gate

	inc ebx
	cmp ebx, IDT_ENT_COUNT
	jl .next

	lidt [idt_descriptor]

	sti
	ret
