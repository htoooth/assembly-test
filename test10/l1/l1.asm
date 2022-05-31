assume cs:codesg

data segment
  db 'Welcome to masn1!', 0
  db 'Welcome to masn2!', 0
  db 'Welcome to masn3!', 0
data ends

codesg segment

start:
  ; init
  mov ax, data
  mov ds, ax 
  mov si, 0

  mov cx, 3
  mov dh, 8
  mov dl, 3
s:
  push cx
  mov cl, 2
  call show_str

  add si, 18
  inc dh

  pop cx
  loop s

  jmp exit

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