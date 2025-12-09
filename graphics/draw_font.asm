[BITS 32]

global draw_char_at
global draw_string_at


extern font_table
extern place_pixel

%define CHAR_WIDTH 8
%define CHAR_HEIGHT 8

get_char_address:
	movzx eax, al
	shl eax, 3
	mov esi, font_table
	add esi, eax
	ret

draw_char_at:
	push esi
	push edi

	call get_char_address

	mov edi, ecx
	mov ecx, CHAR_HEIGHT

.draw_rows:
	mov bl, [esi]
	mov eax, ebx

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

	pop edi
	pop esi
	ret

draw_string_at:
	push eax
	push ebx

.next_char:
	mov al, [edi]
	test al, al
	jz .done

	push ecx
	push edx

	add ebx, CHAR_WIDTH
	inc edi
	jmp .next_char

.done:
	pop ebx
	pop eax
	ret
