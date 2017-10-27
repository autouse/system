use32

initIDT:	lidt	[idtr] ; nasm
		mov	esi,idt.msg.1
		call	puts
		call	putc.crlf
		ret

exception.test: mov	esi,exception.msg
		mov	al,4
		xchg	al,[color]
		push	ax
		call	puts
		pop	ax
		mov	[color],al
		call	putc.crlf
exception.halt: hlt
		jmp	exception.halt
		iret
exception.msg:	db	'EXCEPTION',0

timer:		push eax	;
		push ecx	;
		push edx	;
		push esi	;
		push edi	; nasm
		mov	al,byte[cursor.x]
		mov	ah,byte[cursor.y]
		mov	dl,byte[color]
		mov	dh,byte[cursor.update]
		push	ax
		push	dx
		mov	byte [cursor.y],0
		mov	byte [color],6
		mov	byte [cursor.update],0
		mov	ax,word[screen.w]
		sub	ax,8
		mov	word[cursor.x],ax
		mov	eax,[time]
		call	putd
		inc	dword [time]
		pop	dx
		pop	ax
		mov	byte[cursor.x],al
		mov	byte[cursor.y],ah
		mov	byte[color],dl
		mov	byte[cursor.update],dh

		mov	al,20h
		out	20h,al
		pop edi	; nasm
		pop esi	;
		pop edx	;
		pop ecx	;
		pop eax	;
		iret
time		dd	0

keyboard:	push eax
		push ecx
		push edx
		push esi
		push edi
		mov	al,[color]
		push	ax
		mov	byte [color],5
		mov	al,' '
		call	putc
		in	al,60h
		call	putb
		pop	ax
		mov	[color],al

		mov	al,20h
		out	20h,al
		pop edi
		pop esi
		pop edx
		pop ecx
		pop eax
		iret

initPIC:	mov	dx,20h
		mov	al,11h
		out	dx,al
		inc	dx
		mov	al,20h
		out	dx,al
		mov	al,4
		out	dx,al
		mov	al,1
		out	dx,al
		mov	al,0FCh 		;set mask
		out	dx,al
		mov	esi,initPIC.msg
		call	puts
		call	putc.crlf
		ret
initPIC.msg	db	'Interrupt controller initialized',0

%macro		trap	1
		dw	%1 & 0FFFFh	;low
		dw	8		;cs
		db	0		;reserved
		db	8Fh		;trap 386+
		dw	%1 >> 16	;high
%endmacro
%macro		intr	1
		dw	%1 & 0FFFFh	;low
		dw	8		;cs
		db	0		;reserved
		db	8Eh		;interrupt 386+
		dw	%1 >> 16	;high
%endmacro

idt:
%rep 32
		trap exception.test-$$
%endrep
		intr	timer-$$
		intr	keyboard-$$

idtr		dw	$-idt-1
		dd	idt

idt.msg.1	db	'Interrupt descriptor table initialized',0
