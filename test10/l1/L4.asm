assume cs:codesg

data1 segment
  dd 345980, 590827, 803530, 703530
  dd 345981, 590828, 803531, 703531
  dd 345982, 590829, 803532, 703523
  dd 345983, 590820, 803533, 703534
  dd 345984, 590821, 803534, 703535
  dd 345985, 590822, 803535, 703536
data1 ends 

data segment
  db 10 dup (0)
data ends

codesg segment

start:
  ; init
  mov bx, data
  mov es, bx
  mov bx, 0

  mov bx, data1
  mov ds, bx
  mov bx, 0

  mov cx, 6
  mov dh, 8
  mov dl, 3
  mov si, 0
  mov bx, 0
start_s:
  mov di, dx
  mov ax, ds:[bx+si]
  mov dx, ds:[bx+si+2]
  push cx
  mov cx, 10

  push si
  push ds
  push bx
  mov bx, data
  mov ds, bx

  mov si, 0
  call dtoc

  mov si, 0
  ; mov dh, 8
  ; mov dl, 3
  mov dx, di
  mov cl, 2
  call show_str
  
  pop bx
  pop ds
  add bx, 16
  inc dh
  pop si
  pop cx
  loop start_s

  mov cx, 6
  mov dh, 8
  mov dl, 12
  mov si, 4
  mov bx, 0
start_s1:
  mov di, dx
  mov ax, ds:[bx+si]
  mov dx, ds:[bx+si+2]
  push cx
  mov cx, 10

  push si
  push ds
  push bx
  mov bx, data
  mov ds, bx

  mov si, 0
  call dtoc

  mov si, 0
  ; mov dh, 8
  ; mov dl, 3
  mov dx, di
  mov cl, 2
  call show_str
  
  pop bx
  pop ds
  add bx, 16
  inc dh
  pop si
  pop cx
  loop start_s1


  mov cx, 6
  mov dh, 8
  mov dl, 21
  mov si, 8
  mov bx, 0
start_s2:
  mov di, dx
  mov ax, ds:[bx+si]
  mov dx, ds:[bx+si+2]
  push cx
  mov cx, 10

  push si
  push ds
  push bx
  mov bx, data
  mov ds, bx

  mov si, 0
  call dtoc

  mov si, 0
  ; mov dh, 8
  ; mov dl, 3
  mov dx, di
  mov cl, 2
  call show_str
  
  pop bx
  pop ds
  add bx, 16
  inc dh
  pop si
  pop cx
  loop start_s2

  jmp exit

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