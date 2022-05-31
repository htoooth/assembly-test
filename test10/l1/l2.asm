assume cs:codesg

codesg segment

start:
  ; init
  mov ax, 4244
  mov dx, 1
  mov cx, 10 
  call divdw
  jmp exit

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

exit:
  mov ax, 4c00h
  int 21h

codesg ends

end start