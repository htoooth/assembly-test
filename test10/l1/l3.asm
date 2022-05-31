assume cs:codesg

data segment
  db  10 dup (0)
data ends

codesg segment

start:
  ; init
  mov ax, 12666
  mov bx, data
  mov ds, bx
  mov si, 0
  call dtoc

  mov dh, 8
  mov dl, 3
  mov cl, 2
  call show_str
  
  jmp exit

dtoc:
  push si
  push bx
  push dx

  mov si, 10
  mov bx, 0

dtoc_s:  
  mov dx, 0
  div si
  mov cx, ax
  push dx
  inc bx

  jcxz dtoc_s2
  jmp dtoc_s

dtoc_s2:
  mov cx, bx
  mov bx, 0

dtoc_s3:
  pop dx
  mov al,dl
  add al, 30h
  mov ds:[bx], al
  inc bx
  loop dtoc_s3

dtco_ok:
  pop dx
  pop bx
  pop si
  ret

show_str:
    push ax
    push bx
    push es
    push bp
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
    mov si, 0

    ; 复制颜色参数
    mov ax, 0
    mov al, cl
  code:
    mov cl, ds:[bx]
    mov ch, 0
    jcxz ok

    mov ch, al
    mov word ptr es:[bp+si], cx
    inc bx
    add si, 2
    jmp code
  ok:
    pop si
    pop bx
    pop bp
    pop es
    pop ax

    ret

exit:
  mov ax, 4c00h
  int 21h

codesg ends

end start