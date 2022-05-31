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

codesg segment

start:
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

  mov byte ptr es:[bx].4h, ' '

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

  mov byte ptr es:[bx].9h, ' '

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

  mov byte ptr es:[bx].0ch, ' '

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

  mov byte ptr es:[bx].0fh, ' '

  add bx, 16
loop s_p

  
  mov ax, 4c00h
  int 21h

codesg ends

end start