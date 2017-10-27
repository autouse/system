use32

bios32.find:	mov	esi,bios32.msg.1
		call	puts

		mov	esi,0E0000h

bios32.1:	mov	eax,[esi]
		cmp	eax,'_32_'
		je	bios32.2
bios32.3:	add	esi,16
		cmp	esi,0FFFF0h
		jbe	bios32.1
		mov	esi,bios32.msg.2
		call	puts
		call	putc.crlf
		ret
bios32.2:	xor	ecx,ecx
		xor	eax,eax
bios32.4:	add	al,[esi+ecx]
		inc	ecx
		cmp	ecx,16
		jb	bios32.4
		or	al,al
		jnz	bios32.3		;crc wrong
		mov	eax,[esi+4]
		mov	[bios32.entry],eax
		call	putd
		call	putc.crlf
		;                               ;bios32 pci test
		mov	esi,bios32.msg.3
		call	puts
		mov	eax,'$PCI'
		xor	ebx,ebx
		call	far [bios32.entry]	; nasm
		or	al,al
		jnz	bios32.nopci
		add	ebx,edx
		mov	[bios32.entrypci],ebx
bios32.nopci:	mov	eax,[bios32.entrypci]
		call	putd
		call	putc.crlf
		;                               ;bios32
		ret


bios32.entry	dd	0
		dw	8			;code selector

bios32.entrypci dd	0

bios32.msg.1	db	'Searching for bios32...',0
bios32.msg.2	db	'NOT found',0
bios32.msg.3	db	'bios32 PCI ',0
