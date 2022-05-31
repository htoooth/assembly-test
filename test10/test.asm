assume cs:codeseg

codeseg segment
start:
  mov ax, 6
  call ax
  inc ax
  mov bp, sp
  add ax, [bp]

  mov ax, 4c00h
  int 21h

codeseg ends

end start