assume cs: codesg

data segment
  db '1975', '1976', '1977', '1978', '1979', '1980', '1981', '1982', '1983'
  db '1984', '1985', '1986', '1987', '1988', '1989', '1990', '1991', '1992'
  db '1993', '1994', '1995'

  dd 16,22, 382, 1356, 2390, 8000, 16000, 24486, 50065, 97479, 140417, 197514
  dd 345980, 590827, 803530, 1183000,1843000,2759000,3743000,4649000,5937000

  dw 3, 7, 9, 13, 28,38,130, 220,476, 778, 1001, 1442, 2258, 2793, 4037, 5635, 8226
  dw 11542, 14430, 15257, 17800
data ends

table segment
  db 21 dup ('year summ ne ?? ')
table ends

data1 segment
  db 10 dup (0)
data1 ends

codesg segment

start:
  call s_start
  call p_all
  
  jmp exit

p_all:
    mov ax, table
    mov ds, ax
    mov bx, 0
    mov si, 0

; 年份
    mov cx, 21
    mov dh, 4
    mov dl, 0
  p_field_y:
    push cx

    mov cl, 2

    call show_str
    add si, 16
    inc dh

    pop cx
    loop p_field_y
;     jmp p_ok

; 收入
    mov cx, 21
    mov dh, 4
    mov dl, 10
    mov bx, 0
    mov si, 5
  p_field_c:
    mov di, dx
    mov ax, ds:[bx+si]
    mov dx, ds:[bx+si+2]
    push cx
    mov cx, 10

    push si
    push ds
    push bx
    mov bx, data1
    mov ds, bx

    mov si, 0
    call dtoc

    mov si, 0
    mov dx, di
    mov cl, 2
    call show_str

    pop bx
    pop ds
    add bx, 16
    inc dh
    pop si
    pop cx
    loop p_field_c
    ; jmp p_ok

; 员工
    mov cx, 21
    mov dh, 4
    mov dl, 20
    mov bx, 0
    mov si, 10
  p_field_s:
    mov di, dx
    mov ax, ds:[bx+si]
    mov dx, 0 
    push cx
    mov cx, 10

    push si
    push ds
    push bx
    mov bx, data1
    mov ds, bx

    mov si, 0
    call dtoc

    mov si, 0
    mov dx, di
    mov cl, 2
    call show_str

    pop bx
    pop ds
    add bx, 16
    inc dh
    pop si
    pop cx
    loop p_field_s
    ; jmp p_ok

; 平均收入
    mov cx, 21
    mov dh, 4
    mov dl, 30
    mov bx, 0
    mov si, 13
  p_field_m:
    mov di, dx
    mov ax, ds:[bx+si]
    mov dx, 0
    push cx
    mov cx, 10

    push si
    push ds
    push bx
    mov bx, data1
    mov ds, bx

    mov si, 0
    call dtoc

    mov si, 0
    mov dx, di
    mov cl, 2
    call show_str

    pop bx
    pop ds
    add bx, 16
    inc dh
    pop si
    pop cx
    loop p_field_m
    jmp p_ok

  p_ok:
    ret


  ; 计算
s_start:
    ; 先复制，一个字段，在复制一个字段，再计算

    ; 年份复制
    mov ax, data
    mov ds, ax

    mov ax, table
    mov es, ax

    ; bp 记录所有的长度
    mov bp, 0


    ; 复制年份
    mov cx, 21
    mov si, 0
    mov bx, 0
  s_y: mov si, 0
    mov ax, ds:[bp+si]
    mov es:[bx].0h[si], ax
    add si, 2
    mov ax, ds:[bp+si]
    mov es:[bx].0h[si], ax

    mov byte ptr es:[bx].4h, 0 

    add bp, 4
    add bx, 16
    loop s_y


    ; 复制收入
    mov cx, 21
    mov si, 0
    mov bx, 0
  s_c: mov si, 0
    mov ax, ds:[bp+si]
    mov es:[bx].5h[si], ax
    add si, 2
    mov ax, ds:[bp+si]
    mov es:[bx].5h[si], ax

    mov byte ptr es:[bx].9h, 0

    add bp,4
    add bx, 16
    loop s_c


    ; 复制雇员数
    mov cx, 21
    mov si, 0
    mov bx, 0
  s_s: mov si, 0
    mov ax, ds:[bp+si]
    mov es:[bx].0ah[si], ax

    mov byte ptr es:[bx].0ch, 0

    add bp, 2
    add bx, 16
    loop s_s


    ; 开始计算
    ; 人均收入
    mov cx, 21
    mov si, 0
    mov bx, 0
  s_p: mov si, 0
    mov ax, es:[bx].5h[si]
    add si, 2
    mov dx, es:[bx].5h[si]
    div word ptr es:[bx].0ah
    mov es:[bx].0dh, ax

    mov byte ptr es:[bx].0fh, 0

    add bx, 16
    loop s_p
    jmp s_ok

  s_ok:
    ret

dtoc:
    push bx
    push si
    push di
  
    mov bx, 0
    mov di, cx
  dtoc_run:
    call divdw ; 商：dx ax; 余：cx
    push cx
    inc bx
  
    mov cx, ax
    jcxz dtoc_s1
    jmp dtoc_s2
  dtoc_s1:
    mov cx, dx
    jcxz dtoc_s3
    jmp dtoc_s2
  
  dtoc_s2:   
    mov cx, di
    jmp dtoc_run
  
  dtoc_s3:
    mov cx, bx
  dtoc_s4:
    pop bx
    mov al, bl
    add al, 30h
    mov ds:[si], al
    inc si
    loop dtoc_s4
    mov byte ptr ds:[si], 0
    jmp dtco_ok
  
  dtco_ok:
    pop di
    pop si
    pop bx
    ret

divdw:
    push bx
  
    mov bx, ax
    mov ax, dx
    mov dx, 0
    div cx
  
    push ax
    mov ax, bx
    div cx
  
    mov cx, dx
    pop dx
  
    pop bx
    ret

show_str:
    push ax
    push bx
    push es
    push bp
    push di
    push si

  init:  
    mov ax, 0B800h
    mov es, ax

    ; 计算开始地址
    ; 1 计算行：行 * 160
    ; 2 计算列：列 * 2
    ; bp 为屏幕位置
    mov bp, 0
    mov ax, 0
    mov al, dh
    mov bl, 160
    mul bl
    mov bp, ax

    mov ax, 0
    mov al, dl
    mov bl, 2
    mul bl
    add bp, ax
    ; 结束计算

    mov ax, 0
    mov bx, 0
    mov di, 0

    ; 复制颜色参数
    mov ax, 0
    mov al, cl
  code:
    mov cl, ds:[si]
    mov ch, 0
    jcxz ok

    mov ch, al
    mov word ptr es:[bp+di], cx
    inc si
    add di, 2
    jmp code
  ok:
    pop si
    pop di
    pop bp
    pop es
    pop bx
    pop ax

    ret

exit:
  mov ax, 4c00h
  int 21h


codesg ends

end start