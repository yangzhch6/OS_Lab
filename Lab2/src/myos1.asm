;����Դ���루myos1.asm��
;ע���ڸó����У�ֻ�ɰ��´�дABCD
;ע���ڸó����У�ֻ�ɰ��´�дABCD
;ע���ڸó����У�ֻ�ɰ��´�дABCD
;ע���ڸó����У�ֻ�ɰ��´�дABCD
;ע���ڸó����У�ֻ�ɰ��´�дABCD
org  8000h		       ; BIOS���������������ص�0:7C00h��������ʼִ��
OffSetA equ 8200h
OffSetB equ 8400h
OffSetC equ 8600h
OffSetD equ 8800h
	mov	ax, cs	       ; �������μĴ���ֵ��CS��ͬ
	mov	ds, ax	       ; ���ݶ�
	mov	bp, Message		 ; BP=��ǰ����ƫ�Ƶ�ַ
	mov	ax, ds		 ; ES:BP = ����ַ
	mov	es, ax		 ; ��ES=DS
	mov	cx, MessageLength  ; CX = ������=9��
	mov	ax, 1301h		 ; AH = 13h�����ܺţ���AL = 01h��������ڴ�β��
	mov	bx, 0007h		 ; ҳ��Ϊ0(BH = 0) �ڵװ���(BL = 07h)
    mov dh, 0		       ; �к�=0
	mov	dl, 0			 ; �к�=0
	int	10h			 ; BIOS��10h���ܣ���ʾһ���ַ�
LoadnA:
     ;�����̻�Ӳ���ϵ����������������ڴ��ES:BX����
      mov ax,cs                ;�ε�ַ ; ������ݵ��ڴ����ַ
      mov es,ax                ;���öε�ַ������ֱ��mov es,�ε�ַ��
      mov bx, OffSetA  ;ƫ�Ƶ�ַ; ������ݵ��ڴ�ƫ�Ƶ�ַ
      mov ah,2                 ; ���ܺ�
      mov al,1                 ;������
      mov dl,0                 ;�������� ; ����Ϊ0��Ӳ�̺�U��Ϊ80H
      mov dh,0                 ;��ͷ�� ; ��ʼ���Ϊ0
      mov ch,0                 ;����� ; ��ʼ���Ϊ0
      mov cl,2                 ;��ʼ������ ; ��ʼ���Ϊ1
      int 13H ;                ���ö�����BIOS��13h����
      ; �û�����a.com�Ѽ��ص�ָ���ڴ������� 
	  
LoadnB:
	;�����̻�Ӳ���ϵ����������������ڴ��ES:BX����
      mov ax,cs                ;�ε�ַ ; ������ݵ��ڴ����ַ
      mov es,ax                ;���öε�ַ������ֱ��mov es,�ε�ַ��
      mov bx, OffSetB  ;ƫ�Ƶ�ַ; ������ݵ��ڴ�ƫ�Ƶ�ַ
      mov ah,2                 ;���ܺ�
      mov al,1                 ;������
      mov dl,0                 ;�������� ; ����Ϊ0��Ӳ�̺�U��Ϊ80H
      mov dh,0                 ;��ͷ�� ; ��ʼ���Ϊ0
      mov ch,0                 ;����� ; ��ʼ���Ϊ0
      mov cl,3                 ;��ʼ������ ; ��ʼ���Ϊ1
      int 13H                  ;���ö�����BIOS��13h����
      ; �û�����a.com�Ѽ��ص�ָ���ڴ�������	
LoadnC:
	;�����̻�Ӳ���ϵ����������������ڴ��ES:BX����
      mov ax,cs                ;�ε�ַ ; ������ݵ��ڴ����ַ
      mov es,ax                ;���öε�ַ������ֱ��mov es,�ε�ַ��
      mov bx, OffSetC  ;ƫ�Ƶ�ַ; ������ݵ��ڴ�ƫ�Ƶ�ַ
      mov ah,2                 ;���ܺ�
      mov al,1                 ;������
      mov dl,0                 ;�������� ; ����Ϊ0��Ӳ�̺�U��Ϊ80H
      mov dh,0                 ;��ͷ�� ; ��ʼ���Ϊ0
      mov ch,0                 ;����� ; ��ʼ���Ϊ0
      mov cl,4                 ;��ʼ������ ; ��ʼ���Ϊ1
      int 13H                  ;���ö�����BIOS��13h����
      ; �û�����a.com�Ѽ��ص�ָ���ڴ�����?
LoadnD:
	;�����̻�Ӳ���ϵ����������������ڴ��ES:BX����
      mov ax,cs                ;�ε�ַ ; ������ݵ��ڴ����ַ
      mov es,ax                ;���öε�ַ������ֱ��mov es,�ε�ַ��
      mov bx, OffSetD  ;ƫ�Ƶ�ַ; ������ݵ��ڴ�ƫ�Ƶ�ַ
      mov ah,2                 ;���ܺ�
      mov al,1                 ;������
      mov dl,0                 ;�������� ; ����Ϊ0��Ӳ�̺�U��Ϊ80H
      mov dh,0                 ;��ͷ�� ; ��ʼ���Ϊ0
      mov ch,0                 ;����� ; ��ʼ���Ϊ0
      mov cl,5                 ;��ʼ������ ; ��ʼ���Ϊ1
      int 13H                  ;���ö�����BIOS��13h����
      ; �û�����a.com�Ѽ��ص�ָ���ڴ�����?	  
	  
	  
start:
	  mov bl,[Key]
	  cmp bl,1
	  jnz jumpA
	  call OffSetA
jumpA:
	  mov bl,[Key+1]
	  cmp bl,1
	  jnz jumpB
	  call OffSetB
jumpB:
	  mov bl,[Key+2]
	  cmp bl,1
	  jnz jumpC
	  call OffSetC
jumpC:
	  mov bl,[Key+3]
	  cmp bl,1
	  jnz jumpD
	  call OffSetD
jumpD:
	  mov ah,1
	  int 16h
      jz start
	  mov bx,ax
	  mov bh,0
	  mov al,[Key+bx-41h]
	  cmp al,1
	  jnz one
	  mov byte[Key+bx-41h],0	
input:	  
	  mov ah,0
	  int 16h
	  jmp start
one:	  
	  mov byte[Key+bx-41h],1
      jmp input
Message:
      db 'Press A,B,C,D to run/stop the program '
MessageLength  equ ($-Message)	  
Key:  
	  db 0,0,0,0

   ;   times 510-($-$$) db 0
   ;   db 0x55,0xaa

