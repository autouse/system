use32

;put dword eax
putd:		push	eax
		shr	eax,16
		call	putw
		pop	eax
		call	putw
		ret
;put word ax
putw:		push	ax
		mov	al,ah
		call	putb
		pop	ax
		call	putb
		ret
; put byte al
putb:		push	ax
		shr al,4
		call	puth
		pop	ax
		call	puth
		ret
; put hex al
puth:		and	al,0Fh
		add	al,'0'
		cmp	al,'9'
		jle	putc
		add	al,7
; put char al
putc:		mov	edi,eax
		mov	eax,[cursor.y]
		mul	byte [screen.w]
		add	eax,[cursor.x]
		shl	eax,1
		add	eax,[screen.base]
		xchg	eax,edi
		mov	ah,[color]
		mov	[edi],ax
		mov	eax,[cursor.x]
		inc	eax
		cmp	eax,[screen.w]
		jae	putc.crlf
		mov	[cursor.x],eax
		jmp	putc.3
putc.crlf:	xor	eax,eax
		mov	[cursor.x],eax
		mov	eax,[cursor.y]
		inc	eax
		cmp	eax,[screen.h]
		jae	putc.2
		mov	[cursor.y],eax
		jmp	putc.3
putc.2: 	mov	edi,[screen.base]
		mov	esi,[screen.w]
		shl	esi,1
		add	esi,edi
		mov	eax,[screen.h]
		dec	eax
		mul	byte [screen.w]
		shr	eax,1
		mov	ecx,eax
		cld
		rep
		movsd	; nasm
		mov	ah,[color]
		mov	al,' '
		mov	ecx,[screen.w]
		rep
		stosw	; nasm
putc.3: 	test	byte [cursor.update],1
		jz	putc.4
		call	sethwcursor
putc.4: 	ret

; put string esi
puts.1: 	call	putc
		inc	esi
puts:		mov	al,[esi]
		or	al,al
		jnz	puts.1
		ret


sethwcursor:	mov	dx,3D4h
		mov	al,15
		out	dx,al
		mov	al,byte[screen.w]
		mul	byte[cursor.y]
		add	ax,word[cursor.x]
		inc	dx
		out	dx,al
		mov	al,14
		dec	dx
		out	dx,al
		inc	dx
		mov	al,ah
		out	dx,al
		ret

gethwcursor:	mov	dx,3D4h
		mov	al,14
		out	dx,al
		inc	dx
		in	al,dx
		mov	ah,al
		mov	al,15
		dec	dx
		out	dx,al
		inc	dx
		in	al,dx
		div	byte [screen.w]
		xor	edx,edx
		mov	dl,ah
		mov	[cursor.x],edx
		mov	dl,al
		mov	[cursor.y],edx
		ret
initVGA:	call	gethwcursor
		mov	byte [color],4
		mov	al,'V'
		call	putc
		mov	byte [color],2
		mov	al,'G'
		call	putc
		mov	byte [color],1
		mov	al,'A'
		call	putc
		mov	byte [color],7
		mov	esi,msg.initvga
		call	puts
		call	putc.crlf
		ret
msg.initvga	db	' console initialized',0


screen.base	dd	0B8000h
screen.w	dd	80
screen.h	dd	25
cursor.x	dd	0
cursor.y	dd	0
cursor.update	db	1
color		db	7