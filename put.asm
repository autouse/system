;put dword eax
putd:           push    eax
                shr     eax,16
                call    putw
                pop     eax
                call    putw
                ret
;put word ax
putw:           push    ax
                mov     al,ah
                call    putb
                pop     ax
                call    putb
                ret
; put byte al
putb:           push    ax
                shr al,4
                call    puth
                pop     ax
                call    puth
                ret
; put hex al
puth:           and     al,0Fh
                add     al,'0'
                cmp     al,'9'
                jle     putc
                add     al,7
; put char al
putc:           mov     ah,0Eh
                mov     bx,0002h
                int     10h
                ret
; put string cs:si
puts.1:         call    putc
                inc     si
puts:           mov     al,[si]
                or      al,al
                jnz     puts.1
                ret
