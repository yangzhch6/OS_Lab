[BITS 16]
global _program_test, _change_int34to37,_change_int21h
extern _int_34_overide,_int_35_overide,_int_36_overide,_int_37_overide
extern _int_21h0_overide,_int_21h1_overide,_int_21h2_overide,_int_21h_default
_program_test:
    enter 0,0
    push ds
    push es
    push bx
    push bp
    push sp
    push si
    push di

    int 34
    int 35
    int 36
    int 37
    mov ah,0
    int 21h
    mov ah,1
    int 21h 
    mov ah,2
    int 21h 
    mov ah,3
    int 21h 

	pop di 
    pop si 
    pop sp 
    pop bp
    pop bx
    pop es
    pop ds

	leave
	pop ecx
    jmp cx

_change_int21h:
    push bx
    push es
    push ax
    push ds
    cli

    mov bx, 0
    mov es, bx
    mov word[es:33*4],INT_21H
    mov bx,cs
    mov word[es:33*4+2],bx

    sti
    pop ds
    pop ax
    pop es
    pop bx

    pop ecx
    jmp cx

INT_21H:
    push ax
    push bx
    push cx
    push dx
    push ds
    push es
    cli
    
    mov bx, 0
    mov ds, bx

    push bx
AH0:
    cmp ah,0
    jnz AH1
    call _int_21h0_overide
    jmp END
AH1:    
    cmp ah,1
    jnz AH2
    call _int_21h1_overide
    jmp END
AH2:
    cmp ah,2
    jnz DEFAULT_21h
    call _int_21h2_overide
    jmp END
DEFAULT_21h:
    call _int_21h_default
END:    
    sti
    pop es
    pop ds
    pop dx
    pop cx
    pop bx
    pop ax
    iret 

_change_int34to37:
    push bx
    push es
    push ax
    push ds
    cli

    mov bx, 0
    mov es, bx
    mov word[es:34*4],INT_34
    mov bx,cs
    mov word[es:34*4+2],bx
    mov word[es:35*4],INT_35
    mov bx,cs
    mov word[es:35*4+2],bx
    mov word[es:36*4],INT_36
    mov bx,cs
    mov word[es:36*4+2],bx
    mov word[es:37*4],INT_37
    mov bx,cs
    mov word[es:37*4+2],bx

    sti
    pop ds
    pop ax
    pop es
    pop bx

    pop ecx
    jmp cx

INT_34:
    push ax
    push bx
    push cx
    push dx
    push ds
    push es
    cli
    
    mov bx, 0
    mov ds, bx
    push bx
    call _int_34_overide
    
    sti
    pop es
    pop ds
    pop dx
    pop cx
    pop bx
    pop ax
    iret 

INT_35:
    push ax
    push bx
    push cx
    push dx
    push ds
    push es
    cli
    
    mov ax, 0
    mov ds, ax
    push ax
    call _int_35_overide
    
    sti
    pop es
    pop ds
    pop dx
    pop cx
    pop bx
    pop ax
    iret 
INT_36:
    push ax
    push bx
    push cx
    push dx
    push ds
    push es
    cli
    
    mov ax, 0
    mov ds, ax
    push ax
    call _int_36_overide
    
    sti
    pop es
    pop ds
    pop dx
    pop cx
    pop bx
    pop ax
    iret
INT_37:
    push ax
    push bx
    push cx
    push dx
    push ds
    push es
    cli
    
    mov ax, 0
    mov ds, ax
    push ax
    call _int_37_overide
    
    sti
    pop es
    pop ds
    pop dx
    pop cx
    pop bx
    pop ax
    iret