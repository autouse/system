org 7C00h
mov ah,1
mov cx,7
int 10h
mov ax, 1003h
mov bx, 0
int 10h
mov ah,0
mov al,6
;int 10h
;
mov si,msg
call puts
jmp v001
msg:
db 0Dh,0Ah,'Core i386 version 0.03',0Dh,0Ah,0
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

times 512 - $ + $$ - 2 - 64 db 0
db 80h,0,0,0,7Fh,0,0,0,0,0,0,0,0,0,0,0
dd 0,0,0,0,0,0,0,0,0,0,0,0
db 55h, 0AAh