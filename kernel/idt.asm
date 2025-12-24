[bits 32]

global idt_init

%define IDT_ENT 256 ; IDT Entries
%define IDT_SIZE IDT_ENT * 8

section .bss
align 16
idt_table:
	resb IDT_SIZE

section .data
idt_descriptor:
	dw IDT_SIZE - 1
	dd idt_table


section .text
isr_stub:
	iret


idt_init:
	pusha

	mov edi, idt_table
	mov ecx, IDT_ENT

.fill_idt:
	mov eax, isr_stub
	mov word [edi], ax
	mov word [edi + 2], 0x08
	mov byte [edi + 4], 0
	mov byte [edi + 5], 0x8E
	shr eax, 16
	add edi, 8
	loop .fill_idt

	lidt [idt_descriptor]

	popa
	ret
