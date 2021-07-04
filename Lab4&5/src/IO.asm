[BITS 16]
global _input,_output,_backspace,_clear,_changepos,_isinput,_clear_pos
global _next,_clearin,_time,_loadp,_runp,_output_color,_setgb,_getgb
global _getdate,_getnow
global _change_int08h,_change_int09h,
extern _int_08h_overide,_int_09h_overide
_change_int09h:
    push bx
    push es
    push ax
    cli
    mov bx, 0
    mov es, bx
    mov ax, [es:9*4]
    mov [old_09H], ax
    mov ax, [es:9*4+2]
    mov [old_09H+2], ax
    mov word[es:9*4],INT_09H
    mov word[es:9*4+2], 0
    sti
    pop ax
    pop es
    pop bx
    pop ecx
    jmp cx

old_09H: dw 0,0

INT_09H:
    push ax
    push bx
    push cx
    push dx
    push ds
    push es


    mov ax, 0
    mov ds, ax
    push ax

    call _int_09h_overide
    
    pushf
    call far [old_09H]

    pop es
    pop ds
    pop dx
    pop cx
    pop bx
    pop ax
    iret 


_change_int08h:
    push bx
    push es
    push ax
    cli
    
    mov bx, 0
    mov es, bx
    mov ax, [es:8*4]
    mov [old_08H], ax
    mov ax, [es:8*4+2]
    mov [old_08H+2], ax
    mov word[es:8*4],INT_08H
    mov word[es:8*4+2], 0

    sti
    pop ax
    pop es
    pop bx
    pop ecx
    jmp cx

old_08H: dw 0,0

INT_08H:
    push ax
    push bx
    push cx
    push dx
    push ds
    push es


    mov ax, 0
    mov ds, ax
    push ax

    call _int_08h_overide
    pushf
    call far [old_08H]

    pop es
    pop ds
    pop dx
    pop cx
    pop bx
    pop ax
    iret
_getgb:
    enter 0,0
    push bp
    push bx
    push cx
    push dx

    mov ah, 03h
    mov bh, 0
    int 10h
    mov eax, 0
    mov ax, dx

    pop dx
    pop cx
    pop bx
    pop bp
    leave
    pop ecx
    jmp cx
    
_setgb:
    enter 0,0
    push bp
    push bx
    push cx
    push dx

    mov cl, 07h
    mov ch, 06h
    mov ah, 01h
    int 10h

    mov bh, 0
    mov dh, [bp+2+4*1]
    mov dl, [bp+2+4*2]
    mov ah, 02h
    int 10h

    pop dx
    pop cx
    pop bx
    pop bp
    leave
    pop ecx
    jmp cx

_output_color:
    enter 0, 0
    
	push ds
    push es
    push bx
    push bp
    push sp
    push si 
    push di


    mov bh, 0
    mov al, [bp+2+4*1]
    mov bl, [bp+2+4*2]
    mov cx, 1
    mov ah, 09h
    int 10h

	mov ah, 03h;读取光标位置
    mov bh, 0
    int 10h
	inc dl
	cmp dl,80 ;如果到头则换行
	jnz continue
	mov dl,0
	inc dh
continue: 
	mov ah,02h ;改变光标位置
	int 10h

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

_input:
	enter 0,0
    push ds
    push es
    push bx
    push bp
    push sp
    push si 
    push di

	mov ah,0
	int 16h     ;receive the char in al
	mov bl,07h
	mov ah,0eh 
	int 10h      ;write the char

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

_output:
    enter 0,0
	
	push ds
    push es
    push bx
    push bp
    push sp
    push si 
    push di

	mov al,[bp+2+4];
	mov bl,0x07;color
	mov ah,0eh 
	int 10h      ;write the char

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

_backspace:
	enter 0,0

	push ds
    push es
    push bx
    push bp
    push sp
    push si 
    push di

	mov ah, 0eh
    mov al, ' '
    int 10h
    mov al, 08h
    int 10h 

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

_clear_pos:
    enter 0,0

	push ds
    push es
    push bx
    push bp
    push sp
    push si 
    push di

	mov ah,06h
	mov al,0
	mov ch,[bp+2+4]
	mov cl,[bp+2+4*2]
	mov dh,[bp+2+4*3]
	mov dl,[bp+2+4*4]
	mov bh,07h
	int 10h

	mov ah,02h
	mov bh,0
	mov dh,0
	mov dl,0
	int 10h

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
_clear:
	enter 0,0

	push ds
    push es
    push bx
    push bp
    push sp
    push si 
    push di

	mov ah,06h
	mov al,0
	mov ch,0
	mov cl,0
	mov dh,24
	mov dl,79
	mov bh,07h
	int 10h

	mov ah,02h
	mov bh,0
	mov dh,0
	mov dl,0
	int 10h

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

_changepos:
	enter 0,0

	push ds
    push es
    push bx
    push bp
    push sp
    push si 
    push di
	;record the position we need to display 
	mov dh,[bp+2+4]     ;bh = x
	mov dl,[bp+2+4*2]   ;bl = y 
	mov al,[bp+2+4*4]   ;al =alp
	mov bl,[bp+2+4*3] ; change the color 
	mov ah,02h
	int 10h
	mov cx,1  
	mov ah,09h
	int 10h

	mov ah,02h ; set the position back 
	mov dh,0
	mov dl,0
	int 10h

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

_isinput:
	enter 0,0

	push ds
    push es
    push bx
    push bp
    push sp
    push si 
    push di

	mov eax,0
	mov ah,01h
	int 16h
	jz nclear
    mov ah,0
	int 16h
  nclear:
	mov ah,0

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

_next:
	enter 0,0

	push ds
    push es
    push bx
    push bp
    push sp
    push si 
    push di

	mov ah,0eh
	mov al,'>'
	int 10h

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

_clearin:
	enter 0,0

	push ds
    push es
    push bx
    push bp
    push sp
    push si 
    push di

	mov ah,0
	int 16h

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

_time:
	enter 0,0

	push ds
    push es
    push bx
    push bp
    push sp
    push si 
    push di

	mov ah,00h
	int 1Ah
	mov ax,dx
	
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

_loadp:
	enter 0,0 

	push ds
    push es
    push bx
    push bp
    push sp
    push si 
    push di

	mov ax,cs 
	mov es,ax 
	mov bx,0B100h
	mov ah,2           ;功能号
	mov al,[bp+2+4*4]  ;扇区数量
	mov dl,0           ;驱动器
	mov dh,[bp+2+4*2]  ;磁头
	mov ch,[bp+2+4*1]  ;柱面
	mov cl,[bp+2+4*3]  ;起始是扇区号
	int 13h

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

_runp:
	enter 0,0

	push ds
    push es
    push bx
    push bp
    push sp
    push si 
    push di

    push cs 
    call 0B100h

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
_getdate:
enter 0,0
	push ds
    push es

	mov ah,04h
	int 1Ah
	mov ax,dx
	
    pop es
    pop ds

	leave
	pop ecx
	jmp cx
_getnow:
    enter 0,0
	push ds
    push es

	mov ah,02h
	int 1Ah
	mov ax,cx
	
    pop es
    pop ds

	leave
	pop ecx
	jmp cx   