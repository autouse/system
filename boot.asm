org 7C00h
mov si,msg
call puts
jmp v001
msg:
db 'System v0.02',0
puts:
push si
mov al,byte [cs:si]
cmp al,0
je puts.end
call putc
pop si
inc si
jmp puts
puts.end:
ret
putc:
mov ah,0Eh
mov bx,7
int 10h
ret
v001:
mov ax,0B800h
mov es,ax
l:
inc byte [es:0]
hlt
jmp l

times 512 - $ + $$ - 2 db 0
db 55h, 0AAh