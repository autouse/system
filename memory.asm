%include "put.asm"
;
; memory list
;
memory:         xor     ebx,ebx         ;start
memory.1:       mov     eax,0000E820h
                mov     edx,534D4150h   ;SMAP
                mov     ecx,20          ;buf size
                mov     di,tmp          ;es:di -> buf :)
                int 15h
                jc      memory.error
                cmp     eax,534D4150h
                jne     memory.error
;process entry
                mov     eax,[tmp+16]
                cmp     eax,1
                jnz     memory.next     ;not ram
                mov     eax,[tmp+4]
                or      eax,eax
                jnz     memory.next     ;above 32bit
                mov     eax,[tmp]
                or      eax,eax
                jnz     memory.2        ;base is not 0
                mov     eax,[tmp+8]
                mov     [memory.lolimit],eax
                jmp     memory.next
memory.2:       cmp     eax,100000h
                jne     memory.next
                mov     eax,[tmp+8]
                mov     [memory.hilimit],eax
memory.next:    or      ebx,ebx
                jnz     memory.1
                mov     si,memory.msg.1
                call    puts
                mov     eax,[memory.lolimit]
                call    putd
                mov     si,memory.msg.2
                call    puts
                mov     eax,[memory.hilimit]
                call    putd
                mov     si,memory.msg.3
                call    puts
                jmp     memory.ok
memory.error:   mov     si,memory.msg.0
                call    puts
memory.ok:	ret



memory.msg.0    db      'Memory init error',13,10,0
memory.msg.1    db      'Memory size: low ',0
memory.msg.2    db      ' high ',0
memory.msg.3    db      13,10,0
;
memory.table    dd      500h
memory.lolimit  dd      0
memory.hilimit  dd      0

tmp:		dd 0,0,0,0,0,0,0,0