[bits 32]

section .data
frame_offset dd 0
frame_count dd 0

section .text
global kernel_main
global place_pixel

extern draw_char_at
extern draw_string_at
extern font_table
extern idt_init

kernel_main:
	cli
	mov ax, 0x10		; Segment registers for data segment
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	mov esp, 0x90000	; stack: downwards from 0x90000
	mov ebp, esp

	call idt_init
	sti

main_loop:
	call color_test		; quick colour test before drawing text
	mov ebx, 0		; set x position
	mov edi, 0		; set y position
	mov dl, 5
	mov esi, test_msg	; get test_msg
	call draw_string_at	; draw test_msg

	call delay
	jmp main_loop

hang:
	hlt
	jmp hang

color_test:
	mov edi, 0x000A0000
	xor ebx, ebx
	mov ecx, 200

.fill_rows:
	mov al, bl
	mov edx, 320

.fill_cols:
	mov [edi], al
	inc edi
	dec edx
	jnz .fill_cols

	inc ebx
	dec ecx
	jnz .fill_rows

	ret

delay:
	pusha			; save registers
	mov ecx, 0xFFFFFF	; Big counter

.delay_loop:
	dec ecx
	jnz .delay_loop		; repeat until ecx = 0
	popa			; restore saved registers
	ret

place_pixel:
	push ebx
	push ecx
	push edx

	mov ebx, eax
	mov ecx, edi

	cmp ebx, 320
	jae .done
	cmp ecx, 200
	jae .done

	mov edx, ecx
	imul edx, 320
	add edx, ebx
	mov edi, 0xA0000
	add edi, edx

	mov [edi], ah

.done:
	pop edx
	pop ecx
	pop ebx
	ret


test_msg db "TEXT FFS", 0
