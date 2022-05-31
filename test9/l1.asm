assume cs:codeseg

data segment
  db 'welcome to masm!'
data ends

codeseg segment
start:
  mov ax, data
  mov es, ax
  mov bx, 0h

  mov ax, 0B800h
  mov ds, ax
  mov bp, 0h
  mov di, 0h
  
  mov cx, 010h
s1:

  push cx
  mov cx, 3
s:
  ; 屏幕中间坐标
  mov bp, 6a0h
  mov al, es:[bx]
  ; 绿
  mov ah, 00000010B
  mov ds:[bp+di], ax

  add bp, 0a0h
  mov al, es:[bx]
  ; 红色绿底
  mov ah, 00100100B
  mov ds:[bp+di], ax

  add bp, 0a0h
  ; 白底蓝色
  mov al, es:[bx]
  mov ah, 01110001B
  mov ds:[bp+di], ax

  loop s

  inc bx
  add di, 2

  pop cx
  loop s1

  mov ax, 4c00h
  int 21h

codeseg ends

end start