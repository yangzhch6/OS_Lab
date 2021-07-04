[BITS 16]
global _input,_output,_backspace,_clear,_changepos,_isinput,_next,_clearin,_time,_loadp,_runp
global _output_color,_setgb
_setgb:
	enter 0,0
	mov ah,02h
	mov dh,[bp+2+4]
	mov dl,[bp+2+4*2]
	int 10h
	leave
	pop ecx
	jmp cx

_output_color:
    enter 0, 0
    
    push bp
    push bx

    mov bh, 0
    mov al, [bp+2+4*1]
    mov bl, [bp+2+4*2]
    mov cx, 1
    mov ah, 09h
    int 10h

    
	mov cl, 07h
    mov ch, 06h
    mov ah, 01h
    int 10h

	mov ah, 03h
    mov bh, 0
    int 10h
	inc dl 
	mov ah,02h
	int 10h

    pop bx
    pop bp
    leave
    pop ecx
    jmp cx

_input:
	enter 0,0
	mov ah,0
	int 16h     ;receive the char in al
	mov bl,07h
	mov ah,0eh 
	int 10h      ;write the char
	leave
	pop ecx
    jmp cx

_output:
    enter 0,0
	mov al,[bp+2+4];
	mov bl,0x07;color
	mov ah,0eh 
	int 10h      ;write the char
    leave
	pop ecx
    jmp cx

_backspace:
	enter 0,0
	mov ah, 0eh
    mov al, ' '
    int 10h
    mov al, 08h
    int 10h 
	leave
	pop ecx
    jmp cx


_clear:
	enter 0,0

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

	leave
	pop ecx
	jmp cx

_changepos:
	enter 0,0
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

	leave
	pop ecx
	jmp cx

_isinput:
	enter 0,0
	mov eax,0
	mov ah,01h
	int 16h
	jz nclear
    mov ah,0
	int 16h
  nclear:
	mov ah,0
	leave
	pop ecx
	jmp cx

_next:
	enter 0,0
	mov ah,0eh
	mov al,'>'
	int 10h
	leave
	pop ecx
	jmp cx

_clearin:
	enter 0,0
	mov ah,0
	int 16h
	leave
	pop ecx
	jmp cx

_time:
	enter 0,0

	mov ah,00h
	int 1Ah
	mov ax,dx
	
	leave
	pop ecx
	jmp cx

_loadp:
	enter 0,0 
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

	leave
	pop ecx 
	jmp cx

_runp:
	enter 0,0
    push cs 
    call 0B100h
    leave
    pop ecx
    jmp cx