[BITS 32]

global draw_char_at
global draw_string_at

extern font_table
extern place_pixel

%define CHAR_WIDTH 8
%define CHAR_HEIGHT 8

get_char_address:
	sub al, 0x20
	movzx eax, al
	shl eax, 3
	mov esi, font_table
	add esi, eax
	ret

draw_char_at:
	push ebx
	push esi
	push edi
	push ebp

	call get_char_address

	mov eax, ebx
	mov ecx, CHAR_HEIGHT

.draw_rows:
	mov bl, [esi]
	mov ebp, 8

.draw_bits:
	shl bl, 1
	jc .draw_pixel

.skip_pixel:
	inc eax
	dec ebp
	jnz .draw_bits
	jmp .next_row

.draw_pixel:
	push edx
	push edi
	push eax
	mov ah, dl

	call place_pixel
	pop eax
	pop edi
	pop edx

	inc eax
	dec ebp
	jnz .draw_bits

.next_row:
	inc edi
	inc esi
	loop .draw_rows

	pop ebp
	pop edi
	pop esi
	pop ebx
	ret

draw_string_at:		;TODO: Handle IDT
	push eax
	push ebx

.next_char:
	mov al, [esi]
	test al, al
	jz .done

	push ecx
	push edx

	call draw_char_at

	pop edx
	pop ecx

	add ebx, CHAR_WIDTH
	inc esi
	jmp .next_char

.done:
	pop ebx
	pop eax
	ret
