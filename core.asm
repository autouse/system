; nasm adaptaion
;
; Core Object Runtime Environment
; 32 bit code version

incbin 'mbr'

;file             'cdboot.bin'

use32
		org	10000h

		call	initVGA
		call	initIDT
		call	initPIC

		sti

		call	bios32.find

		mov	byte [color],3
		mov	esi,msg.hello
		call	puts
		call	putc.crlf
		mov	byte [color],7

		mov	eax,ss
		call	putd
		mov	eax,esp
		call	putd


halt:		call	putc.crlf
		mov	byte [color],3
		mov	esi,msg.halted
		call	puts
halt.1: 	hlt
		jmp	halt.1

msg.hello	db	'Core Object Runtime Environment x86 (32-bit)',0
msg.halted	db	'System halted',0


%include 	'idt.asm'
%include 	'api.asm'
%include 	'bios32.asm'

times 2048 - $ + $$ db 0
