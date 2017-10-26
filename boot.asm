; system boot record
    org 7C00h
; main function
    call biosSetFullBlockCursor
    mov si,systemMessage
    call puts
;   call memory

inputLoop:
    call biosKey
    cmp al,0Dh
    jne skipNextLine
    call putc
    mov al,0Ah
skipNextLine:
    call putc
    jmp inputLoop
; end execution
    jmp halt
; binary invoke
binaryInvoke:
    mov si,offsetTable
    mov ax,[si+1]
    call ax
; offset table
offsetTable:
    dw putc
    dw puts
    dw biosKey
    dw biosSetFullBlockCursor
    dw halt
    dw 0
; name table
nameTable:
    db 'putc',0
    db 'puts',0
    db 'biosKey',0
;    db 'biosSetFullBlockCursor',0
    db 'halt',0
    db 0
; data
systemMessage:
    db 0Dh,0Ah,'Intel x86 cpu core interface',0Dh,0Ah,'.',0
; bios
biosSetFullBlockCursor:
    mov cx,7
    mov ah,1
    int 10h
    ret
biosKey:
    mov ah,0
    int 16h
    ret
; halt system
halt:
    hlt
    jmp halt
;puts:
;    push si
;    mov al,byte [cs:si]
;    cmp al,0
;    je puts.end
;    call putc
;    pop si
;    inc si
;    jmp puts
;puts.end:
;    ret
;putc:
;    mov ah,0Eh
;    mov bx,7
;    int 10h
;    ret
;;

%include "memory.asm"

; some free space
times 512 - $ + $$ - 2 - 64 db 0
; active partition type 7F
db 80h,0,0,0,7Fh,0,0,0,0,0,0,0,0,0,0,0
dd 0,0,0,0,0,0,0,0,0,0,0,0
; boot signature
db 55h, 0AAh