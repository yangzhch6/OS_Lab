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
	xor ax,ax
	push ds
	push es
	mov al,34h			; 设控制字值
	out 43h,al				; 写控制字到控制字寄存器
	mov ax,1193182/20	; 每秒20次中断（50ms一次）
	out 40h,al				; 写计数器0的低字节
	mov al,ah				; AL=AH
	out 40h,al
	mov ax,cs
	mov es,ax
	mov ds,ax
	mov word[es:20h],INT_08H
	mov word[es:22h],ax
	pop es
	pop ds
	int 8
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
    call restart

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
	push ds;保存ds
	push cs	
	pop ds	;同步ds
	pop word[ds_save]
	pop word[ret_save];保存save的返回地址
	mov word[si_save],si;保存中介寄存器
	mov si,word[_CurrentProc]
	mov word[si],ax
	mov word[si+4],bx
	mov word[si+4*2],cx
	mov word[si+4*3],dx
	mov word[si+4*5],di
	mov word[si+4*6],bp
	mov word[si+4*7],es
	mov word[si+4*9],ss
	push word[ds_save];保存ds
	pop  word[si+4*8]
	pop word[si+4*11];保存ip
	pop word[si+4*12];保存cs
	pop word[si+4*13];保存flag
	mov word[si+4*10],sp;保存sp
	mov ax,word[si_save]
	mov word[si+4*4],ax
	mov ax,cs
	mov ds,ax
	mov ax,word[ret_save]
	jmp ax

restart:
	pop ax;把restart的返回地址出栈，防止内核栈内存泄漏
	mov si,word[_CurrentProc]
	mov ax,word[si];reset ax
	mov bx,word[si+4];reset bx
	mov cx,word[si+4*2];reset cx
	mov dx,word[si+4*3];reset dx
	mov di,word[si+4*5];reset di
	mov bp,word[si+4*6];reset bp
	mov es,word[si+4*7];reset es
 	mov ss,word[si+4*9];reset stack
	mov sp,word[si+4*10];reset stack，栈已变回用户栈
	push word[si+4*13];flag 入栈，模仿int
	push word[si+4*12];cs入栈
	push word[si+4*11];ip 入栈
	push word[si+4*8];ds 入栈
	mov si,word[si+4*4];reset si
	push ax
	mov al,20h			; AL = EOI
	out 20h,al			; 发送EOI到主8529A
	out 0A0h,al			; 发送EOI到从8529A
	pop ax
	pop ds;ds出栈，恢复
	sti
	iret


global _stackcopy
_stackcopy:
	enter 0,0
	mov si,word[_CurrentProc]
	mov ax,word[bp+2+4] ;当前堆栈的栈顶
	sub ax,1
	mov bx,word[bp+2+4*2] ;父进程的堆栈起始位置
	mov di,word[bp+2+4*3] ;子进程的sp
	push ds
	mov ds,word[si+4*9]
copy:
	mov dh,byte[bx]
	mov byte[di],dh
	sub di,1
	sub bx,1
	cmp bx,ax
	jnz copy
	;复制结束
	pop ds
	leave
	add di,1
	mov ax,di ;返回子进程sp
	pop ecx
	jmp cx


global _INT33_to_36
_INT33_to_36:
	xor ax,ax
	push ds
	push es
	mov ax,cs
	mov es,ax
	mov ds,ax
	mov word[es:0xCC],INT_33
	mov word[es:0xCE],ax
	mov word[es:0xD0],INT_34
	mov word[es:0xD2],ax
	mov word[es:0xD4],INT_35
	mov word[es:0xD6],ax
	pop es
	pop ds
	pop ecx
	jmp cx

extern _do_fork
extern _do_wait
extern _do_exit

INT_33:
	call save
	push 0
	call _do_fork
	call restart

INT_34:
	call save
	push 0
	call _do_wait
	call restart

INT_35:
	enter 0,0
	mov ax,[bp+2+6+4] ;获得输入的参数
	push 0
	push ax
	mov ax,cs
	mov ds,ax
	push 0
	call _do_exit

global _fork
global _wait
global _exit

_fork:
	cli
	int 0x33
	sti
	pop ecx
	jmp cx

_wait:
	cli
	int 0x34
	sti
	pop ecx
	jmp cx

_exit:
	cli 
	int 0x35
	sti
	pop ecx
	jmp cx

