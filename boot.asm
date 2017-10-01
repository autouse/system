mov ax,0B800h
mov es,ax
l:
inc byte [es:0]
hlt
jmp l

times 512 - $ + $$ - 2 db 0
db 55h, 0AAh