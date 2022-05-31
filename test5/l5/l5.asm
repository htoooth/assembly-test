assume cs:code

a segment
  db 1,2,3,4,5,6,7,8
a ends

b segment
  db 1,2,3,4,5,6,7,8
b ends

c segment
  db 0,0,0,0,0,0,0,0
c ends

code segment

start: mov cx, 8
       mov bx, 0

s:     mov dx, a
       mov ds, dx
       mov ah, 0
       mov al, [bx]

       mov dx, b 
       mov ds, dx
       add al, [bx]

       mov dx, c
       mov ds, dx
       mov [bx], al

       inc bx
       loop s

       mov ax, 4c00h
       int 21h

code ends

end start