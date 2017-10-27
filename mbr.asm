use16
		org	7C00h

		xor	sp,sp
		mov	ss,sp
		mov	ds,sp

		push	dx
		mov	si,msg.hello
		call	puts
		pop	ax
		push	ax
		call	putb
		pop	dx

		mov	ah,42h
		mov	si,dap
		int	13h
		jc	error

		mov	si,msg.start
		call	puts

		cli
		lgdt	[gdtr] ; nasm fix
		mov	eax,cr0
		or	al,1
		mov	cr0,eax
		jmp	8:flat

error:		push	ax
		mov	si,msg.error
		call	puts
		pop	ax
		mov	al,ah
		call	putb
halt:		hlt
		jmp	halt

gdt		times 8 db 0 ;nasm fix			;null
		db	0FFh,0FFh,0,0,0,09Ah,0CFh,0	;code 32  limit 4G base 0
		db	0FFh,0FFh,0,0,0,092h,08Fh,0	;data     limit 4G base 0
stack.limit	db	0FFh,3h,00,10h,0,092h,0,0	;stack    limit 1k base 1000
gdtr		dw	$-gdt-1 			;gdt limit
		dd	gdt

use32
flat:		mov	ax,16
		mov	ds,ax
		mov	es,ax
		mov	fs,ax
		mov	gs,ax
		mov	ax,24
		mov	ss,ax
		xor	esp,esp
		mov	sp,word[stack.limit]
		inc	sp
		jmp	10000h
use16
;
msg.hello	db	'Loading from drive ',0
msg.error	db	' failed, error code is ',0
msg.start	db	' completed, starting at 10000',13,10,0
;
;
;
dap		db	10h
		db	00h
		db	03h		;sectors to read
		db	00h
		dw	00000h		;offset
		dw	01000h		;segment
		dd	1		;lba
		dd	0
;
;


%include 'biosapi.asm'

; some free space
times 512 - $ + $$ - 2 - 64 db 0
; active partition type 7F
db 80h,0,0,0,7Fh,0,0,0,0,0,0,0,0,0,0,0
dd 0,0,0,0,0,0,0,0,0,0,0,0
; boot signature
db 55h, 0AAh
