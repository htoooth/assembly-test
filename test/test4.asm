assume cs:code

data segment
  dd 12345678h
data ends

code segment
start:
  mov ax, 11
  mov dx, 1
  mov cx, 10

  call divdw

  mov ax, 4c00h
  int 21h

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

code ends

end start