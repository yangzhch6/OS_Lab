[BITS 16]
global _input,_output,_backspace,_clear,_changepos,_isinput,_clear_pos
global _next,_clearin,_time,_loadp,_runp,_output_color,_setgb,_getgb
global _getdate,_getnow
global _change_int08h,_change_int09h
extern _int_08h_overide,_int_09h_overide
extern _CurrentProc,_Schedule
;***************************************
;          BIOS中断重载
;***************************************
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
    cli 
    call save
    push 0
    call _int_08h_overide
    push 0
    call _Schedule
    jmp restart

;********************************
;   基本输入输出实现
;********************************

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

	; mov ax,cs 
	; mov es,ax 
    mov bx,[bp+2+4*6]  ;跨段segment
    mov es,bx
	mov bx,[bp+2+4*5]  ;0B100h
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

;**********************************
; save && restart
;**********************************	
ds_save dw 0
ret_save dw 0
si_save dw 0
kernelsp dw 0	

save:
    ;push flags
    ;push cs
    ;push ip
    ;push adress
	push ds     
	push cs
	pop ds      ;让ds = cs
	pop word[ds_save] ;保存ds
	pop word[ret_save] ;保存返回地址
	mov word[si_save],si ;保存当前si 
	mov si,word[_CurrentProc] ;获取当前PCB地址 
    ;先保存通用寄存器和某些段寄存器
    mov word[si],ax       
    mov word[si+1*4],bx
    mov word[si+2*4],cx
    mov word[si+3*4],dx
    mov word[si+5*4],di
    mov word[si+6*4],bp
    mov word[si+7*4],es
    mov word[si+9*4],ss 
    ;对ds及其他寄存器操作
    push word[ds_save]; push ds 
    pop word[si+8*4]  ; pop ds
    pop word[si+11*4] ; store ip
    pop word[si+12*4] ; store cs
    pop word[si+13*4] ; store falgs
    mov word[si+10*4],sp ;保存当前sp 
    mov ax,word[si+4*15]
    cmp ax,0   ;判断是否为内核的PCB
    jnz skipPCB ;如果不是内核PCB
    mov word[kernelsp],sp ;保存内核的sp至指定地址
skipPCB: ;跨段操作
    mov ax,word[si_save]  ;
    mov word[si+4*4],ax   ;保存si
    ;调整段寄存器
    mov ax,cs
    mov ds,ax
    mov ss,ax
    mov es,ax
    mov ax,word[kernelsp] ;获取当前内核的sp
    mov sp,ax             ;保存sp  
    mov ax,word[ret_save] ;跳转回原来的位置
    jmp ax

restart:
    mov si,word[_CurrentProc];获取当前PCB表
    ;还原通用寄存器以及di,bp,es,ss
    mov ax,word[si]
    mov bx,word[si+1*4]
    mov cx,word[si+2*4]
    mov dx,word[si+3*4]
    mov di,word[si+5*4]
    mov bp,word[si+6*4]
    mov es,word[si+7*4]
    mov ss,word[si+9*4]
    ;再次保存当前sp；即内核sp
    mov word[kernelsp],sp
    mov sp,word[si+10*4] ;还原PCB表中的sp
    push word[si+13*4] ;push falgs
    push word[si+12*4] ;push cs
    push word[si+11*4] ;push ip
    push word[si+8*4]  ;push ds
    mov si,[si+4*4]    ;pop si
    push ax  ;保护ax
    mov al,20h
    out 20h,al
    out 0A0h,al
    pop ax
    pop ds  ;获取ds寄存器的值
    sti
    iret


;************************************************
;
;       系统功能调用
;
;************************************************
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