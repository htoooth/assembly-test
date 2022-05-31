; jump1
assume cs:code

data segment
  dd 12345678h
data ends

code segment
start:
  mov ax, 11
  mov dx, 1
  mov cx, 10

  div cx

  mov ax, 4c00h
  int 21h
code ends

end start