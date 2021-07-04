     Dn_Rt equ 1                  ;D-Down,U-Up,R-right,L-Left
     Up_Rt equ 2                  
     Up_Lt equ 3                  
     Dn_Lt equ 4                  
     delay equ 50000		  ; ��ʱ���ӳټ���,���ڿ��ƻ�����ٶ�
     ddelay equ 580			    ; ��ʱ���ӳټ���,���ڿ��ƻ�����ٶ�
     wide equ 25                
     len equ 40                 
     str_len equ 4             
	 
	org 0x8600                   
        mov ax,cs
	mov ds,ax					; DS = CS
	mov ax,0B800h			    ; �ı������Դ���ʼ��ַ
	mov es,ax					; es = B800h
loop1:
	dec word[count]				; �ݼ���������
	jnz loop1					; >0����ת;
        mov word[count],delay 
	dec word[dcount]				; �ݼ���������
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
	mov ax,-1
	sub ax,bx
        jz  ul2ur
	jmp show

ul2dl:
      mov word[x],15
      cmp word[y],-1
      jz ul2dr
      mov byte[rdul],Dn_Lt	
      jmp show
ul2ur:
      mov word[y],1
      mov byte[rdul],Up_Rt	
      jmp show
ul2dr:
      mov word[y],1
      mov byte[rdul],Dn_Rt
      jmp show
	
	
DnLt:
	inc word[x]
	dec word[y]
	mov bx,word[y]
	mov ax,-1
	sub ax,bx
        jz  dl2dr
	mov bx,word[x]
	mov ax,wide
	sub ax,bx
        jz  dl2ul
	jmp show

dl2dr:
      mov word[y],1
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
    x    dw 20
    y    dw 20
    color db 0FH
    inf db 'MYOS'
times 512-($-$$) db 0