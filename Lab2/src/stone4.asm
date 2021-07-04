     Dn_Rt equ 1                  ;D-Down,U-Up,R-right,L-Left
     Up_Rt equ 2                  
     Up_Lt equ 3                  
     Dn_Lt equ 4                  
     delay equ 50000		  ; 计时器延迟计数,用于控制画框的速度
     ddelay equ 580					; 计时器延迟计数,用于控制画框的速度
     wide equ 25
     len equ 80
     str_len equ 7
     
	org 0x8800
        mov ax,cs
	mov ds,ax					; DS = CS
	mov ax,0B800h			        ; 文本窗口显存起始地址
	mov es,ax					; es = B800h
loop1:
	dec word[count]				; 递减计数变量
	jnz loop1					; >0：跳转;
        mov word[count],delay 
	dec word[dcount]				; 递减计数变量
        jnz loop1
	
	mov word[count],delay
	mov word[dcount],ddelay
	
      mov al,1
      cmp al,byte[rdul]
      jz  DnRt
      mov al,2
      cmp al,byte[rdul]
      jz  UpRt
      mov al,3
      cmp al,byte[rdul]
      jz  UpLt
      mov al,4
      cmp al,byte[rdul]
      jz  DnLt

DnRt:
	inc word[x]
	inc word[y]
	mov bx,word[x]
	mov ax,wide
	sub ax,bx
        jz  dr2ur
	mov bx,word[y]
	mov ax,len - str_len
	sub ax,bx
        jz  dr2dl
	jmp show
dr2ur:
      mov word[x],wide-2
      cmp word[y],len - str_len 
      jz dr2ul
      mov byte[rdul],Up_Rt	
      jmp show
dr2dl:
      mov word[y],len-2-str_len 
      mov byte[rdul],Dn_Lt	
      jmp show
dr2ul:
      mov word[y],len-2-str_len
      mov byte[rdul],Up_Lt
      jmp show

UpRt:
	dec word[x]
	inc word[y]
	mov bx,word[y]
	mov ax,len-str_len
	sub ax,bx
        jz  ur2ul
	mov bx,word[x]
	mov ax,14
	sub ax,bx
        jz  ur2dr
	jmp show
ur2ul:
      mov word[y],len-2-str_len
      cmp word[x],14
      jz ur2ld
      mov byte[rdul],Up_Lt	
      jmp show
ur2dr:
      mov word[x],15
      mov byte[rdul],Dn_Rt	
      jmp show
ur2ld:
      mov word[x],15
      mov byte[rdul],Dn_Lt
      jmp show
	
	
UpLt:
	dec word[x]
	dec word[y]
	mov bx,word[x]
	mov ax,14
	sub ax,bx
        jz  ul2dl
	mov bx,word[y]
	mov ax,40
	sub ax,bx
        jz  ul2ur
	jmp show

ul2dl:
      mov word[x],15
      cmp word[y],40
      jz ul2dr
      mov byte[rdul],Dn_Lt	
      jmp show
ul2ur:
      mov word[y],41
      mov byte[rdul],Up_Rt	
      jmp show
ul2dr:
      mov word[y],41
      mov byte[rdul],Dn_Rt
      jmp show
	
	
DnLt:
	inc word[x]
	dec word[y]
	mov bx,word[y]
	mov ax,40
	sub ax,bx
        jz  dl2dr
	mov bx,word[x]
	mov ax,wide
	sub ax,bx
        jz  dl2ul
	jmp show

dl2dr:
      mov word[y],41
      cmp word[x],wide
      jz dl2ur
      mov byte[rdul],Dn_Rt	
      jmp show
	
dl2ul:
      mov word[x],wide-2
      mov byte[rdul],Up_Lt	
      jmp show
dl2ur:
      mov word[x],wide-2
      mov byte[rdul],Up_Rt
      jmp show
	
show:	
    mov ax,word[x]
	mov bx,80
	mul bx
	add ax,word[y]
	mov bx,2
	mul bx
	mov bx,ax
	dec byte[color]                                  
	jz reset
here:
	mov cx,str_len
	mov si,inf
input_str:
	mov ah,byte[color]
	mov al,[si]			
	mov [es:bx],ax  		        
	inc si
	inc bx
	inc bx
	loop input_str
	RET

reset:
	mov byte[color],07H
	jmp here

datadef:
    count dw delay
    dcount dw ddelay
    rdul db Dn_Lt        
    x    dw  20
    y    dw  60
    color db 0FH
    inf db 'Welcome'
times 512-($-$$) db 0