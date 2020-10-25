IDEAL
MODEL small
STACK 100h
P386
DATASEG
; --------------------------
	colorfile db 'doors\color.txt', 0
	homescreen db 'doors\home\home.bmp', 0
	paintersceen db 'doors\exit\exit.bmp', 0
	settingsblack db 'doors\settings\black.bmp', 0
	settingscyan db 'doors\settings\cyan.bmp', 0
	settingsgray db 'doors\settings\gray.bmp', 0
	settingsgreen db 'doors\settings\green.bmp', 0
	settingsorenge db 'doors\settings\orenge.bmp', 0
	settingspurple db 'doors\settings\purple.bmp', 0
	settingsred db 'doors\settings\red.bmp', 0
	notepadplace db 'doors\notepad\write.txt', 0
	creditscreen db 'doors\credit\credit.bmp', 0
	notepadhandle dw ?
	notepadarray db 256 dup (?)
	screenHeight equ 200
	screenLength equ 320
	FileAddress equ [bp+4]
	imLength dw (?)
	imHeight dw (?)
	buffer db 320 dup (?)
	FileHandle dw (?)
	imY dw ?
	imX dw ?
	index db ?
	color db ?
	Text_Buffer dw ?
	x dw 0
	y dw 0
	firstH db 0
	firstM db 0
	secondH db 0
	secondM db 0
	colorhandle dw ?
	coloredit db ?
	colortopaint db 0Fh
; --------------------------
CODESEG

proc OpenFile
	push bp 
	mov bp, sp 
	push ax bx cx dx si di es
	; openFile
	mov ah, 3Dh    ;open existing file
	xor al, al ; Read
	mov dx, FileAddress    ; [bp+4]
	int 21h

	mov [fileHandle], ax
	jmp @@ProcEnd

@@procEnd:
	pop es di si dx cx bx ax
	pop bp
	ret 2
endp OpenFile
; --------------------------

proc CloseFile
	push ax bx cx dx si di es
	mov bx, [fileHandle]
	mov ah, 3Eh
	int 21h
@@ProcEnd:
	pop es di si dx cx bx ax
	ret
endp CloseFile

proc GetColor
	mov ah, 3dh
    mov al, 0
    mov dx, offset colorfile
    int 21h
    mov [color], al
    mov ah, 3fh
    mov bl, [color]
    mov cx, 2
    mov dx, offset color
    int 21h
	ret
endp GetColor

proc readfile
    mov [filehandle], ax
    mov ah, 3fh
    mov bx, [filehandle]
    mov cx, 2
    mov dx, offset filehandle
    int 21h
	ret
endp readfile

proc writefile
	mov ah, 3Dh
	mov al, 1
	mov dx, offset colorfile
	int 21h
	mov [colorhandle], ax
	mov ah, 40h
	mov bx, [colorhandle]
	mov dx, offset coloredit
	int 21h
	mov bx, [colorhandle]
	mov ah, 3Eh
	int 21h
ret
endp writefile

proc Print
	push bp
	mov bp, sp
	push ax bx cx dx si di es
	;Skip file header
	xor al, al                          
	mov bx, [FileHandle]
	xor cx, cx
	mov dx, 1078                  

	;SEEK - set current file position
	mov ah, 42h
	int 21h
	jmp @@readFile
	
	jmp @@procEnd
	
@@readFile:
	mov ax, 0A000h         ; segment of memoey
	mov es, ax

	mov ax, screenLength    ; 320
	mov bx, [imY]        	; Y      
	mul bx                  ;  BX = y
	
	mov di, ax 
	add di, [imX]        	; X

	mov bx, [imHeight]		; Height
	dec bx                  ; Height - 1
	
	mov ax, screenLength
	mul bx                   ; start of first line
	add di, ax               ; start of last line

	cld                      ;clear direction flag

	mov cx, [imHeight]        ;Height
	
@@ReadLine:
	push cx                  

	mov bx, [FileHandle]        ; FileHandle
	mov cx, [imLength]        ; Length
	mov dx, offset buffer         ;[bp+4]
	mov ah, 3Fh
	int 21h
	
	;no error
	jnc @@CopyToVRAM
	
	pop cx ; clear stack
	jmp @@procEnd
	
@@CopyToVRAM:
	mov si, offset buffer    ; [bp+4]
	mov cx, [imLength]   ; Length    
	
	rep movsb           ; full line

	sub di, [imLength]   ; Length   ; start of line
	sub di, 320                    ; start of last line

	pop cx
	loop @@readLine
	
@@procEnd:
	pop es di si dx cx bx ax
	pop bp
	ret
endp Print
; --------------------------

proc background
	mov [imX], 0
	mov [imY], 0
	push offset homescreen
	call OpenFile
	
	mov [imLength], 320
	mov [imHeight], 200
	
	call Print
	
	call CloseFile
	
	mov [FileHandle], 0
	
	call GetColor
	sub [color], '0'	
	mov [x], 0
	mov [y], 0
	mov cx, 200
line1:
    push cx
    mov cx, 320
line2:
    push cx
    mov ah,0Dh
    mov cx,[X] 
    mov dx,[Y]
    int 10h ; al = color
    cmp al, 0h
    jne next1
    mov ah, 0Ch
    mov al, [color]
    xor bh, bh
    int 10h
next1:
    inc [x]
    pop cx
    loop line2
    pop cx
    mov [x], 0
    inc [y]
    loop line1
	ret
endp background

; --------------------------

proc clearclock
	mov [x], 279
	mov [y], 183
    mov cx, 9
column:
	push cx
	mov cx, 41
line:
	push cx
	mov ah,0Dh
	mov cx,[X] 
	mov dx,[Y]
	int 10h ; al = color
	cmp al, 0fh
	je next
	mov cx,[X] 
	mov dx,[Y]
	mov ah, 0Ch
	mov al, [color]
	mov bh, 0
	int 10h
next:
	inc [x]
	pop cx
	loop line
	pop cx
	mov [x], 279
	inc [y]
	loop column 

	ret
endp clearclock

proc check_time
	mov ah, 2Ch
	int 21h
    xor ax, ax
    mov al, cl
    mov cl, 10
    div cl
	add ah, '0'
	ret
endp check_time

; --------------------------

proc time
	call check_time
    cmp [secondM], ah
	je end_create
    mov ah, 2Ch
    int 21h
    xor ax, ax
    mov al, ch
    mov ch, 10
    div ch
    mov [secondH], ah
    mov [firstH], al
    xor ax, ax
    mov al, cl
    mov cl, 10
    div cl
    mov [secondM], ah
    mov [firstM], al
    add [secondH], '0'
    add [firstH], '0'
    add [secondM], '0'
    add [firstM], '0'

	mov ax, 2h
	int 33h
	
	mov  dl, 35   ;Column
	mov  dh, 23  ;Row
	mov  bh, 0    ;Display page
	mov  ah, 02h  ;SetCursorPosition
	int  10h

	mov  al, [firstH]
	mov  bl, 0fh  ; Color is white
	mov  bh, 0    ;Display page
	mov  ah, 0Eh  ;Teletype
	int  10h
	
	mov  al, [secondH]
	mov  bl, 0fh  ;Color is white
	mov  bh, 0    ;Display page
	mov  ah, 0Eh  ;Teletype
	int  10h
	
	mov  al, ':'
	mov  bl, 0fh  ;Color is white
	mov  bh, 0    ;Display page
	mov  ah, 0Eh  ;Teletype
	int  10h
	
	mov  al, [firstM]
	mov  bl, 0fh  ;Color is white
	mov  bh, 0    ;Display page
	mov  ah, 0Eh  ;Teletype
	int  10h
	
	mov  al, [secondM]
	mov  bl, 0fh  ;Color is white
	mov  bh, 0    ;Display page
	mov  ah, 0Eh  ;Teletype
	int  10h
	call clearclock
	mov ax, 1h
	int 33h
end_create:
	ret
endp time

proc printer ;check if you clicked painter button
	mov ax, 03h
	int 33h
	mov ax, cx
	push dx
	xor dx, dx
	mov cx, 2
	div cx
	mov cx, ax
	pop dx
	cmp cx, 69
	jb skippainter
	cmp dx, 150
	jb skippainter
	cmp cx, 104
	ja skippainter
	cmp dx, 185
	ja skippainter
	mov ax, 13h
	int 10h
	mov ax, 01
	int 33h
	mov [imX], 0
	mov [imY], 0
	push offset paintersceen
	call OpenFile
	
	mov [imLength], 320
	mov [imHeight], 200
	
	call Print
	
	call CloseFile

paint:
	mov ax, 03h
	int 33h
	cmp bx, 1
	jne paint
	push dx
	mov ax, cx
	mov cx, 2
	xor dx,dx
	div cx
	pop dx
	mov cx, ax
	mov al, [colortopaint]
	cmp cx, 288
	jb countinuepaint ;exit button
	cmp cx, 302
	ja countinuepaint
	cmp dx, 21
	jb countinuepaint
	cmp dx, 35
	ja countinuepaint
	jmp home
countinuepaint:

allpaint:
	cmp dx, 22
	jb realpaint
	cmp dx, 34
	ja realpaint
blackpaint:
	cmp cx, 176
	jb greenpaint
	cmp cx, 188
	ja greenpaint
	mov [colortopaint], 0
greenpaint:
	cmp cx, 190
	jb cyanpaint
	cmp cx, 202
	ja cyanpaint
	mov [colortopaint], 2
cyanpaint:
	cmp cx, 204
	jb redpaint
	cmp cx, 216
	ja redpaint
	mov [colortopaint], 3
redpaint:
	cmp cx, 218
	jb purplepaint
	cmp cx, 230
	ja purplepaint
	mov [colortopaint], 4
purplepaint:
	cmp cx, 232
	jb orengepaint
	cmp cx, 244
	ja orengepaint
	mov [colortopaint], 5
orengepaint:
	cmp cx, 246
	jb graypaint
	cmp cx, 258
	ja graypaint
	mov [colortopaint], 6
graypaint:
	cmp cx, 260
	jb realpaint
	cmp cx, 271
	ja realpaint
	mov [colortopaint], 7
realpaint:
	cmp cx, 287
	ja paint
	cmp dx, 36
	jb paint
	mov ah, 0ch
	mov al, [colortopaint]
	int 10h
	jmp paint
skippainter:
ret
endp printer

proc notepad ;check if you clicked notepad button
	mov ax, 03h
	int 33h
	mov ax, cx
	push dx
	xor dx, dx
	mov cx, 2
	div cx
	mov cx, ax
	pop dx
	cmp cx, 118
	jb skipnotepad
	cmp dx, 150
	jb skipnotepad
	cmp cx, 153
	ja skipnotepad
	cmp dx, 185
	ja skipnotepad
	jmp note
note:
	mov ax, 13h
	int 10h
	mov ax, 01
	int 33h
	mov cx, 256
	mov bx, offset notepadarray 
input:
	mov ah, 01
	int 21h
	cmp al, 01Bh
	je write_notepad
	cmp al, 08h
	je delete
	mov [bx], al
	inc bx
	loop input
	jmp write_notepad
delete:
	mov [bx], 0
	dec bx
	jmp input
write_notepad:
	mov ah, 3Dh
	mov al, 1
	mov dx, offset notepadplace
	int 21h
	mov [notepadhandle], ax
	mov ah, 40h
	mov bx, [notepadhandle]
	mov cx, 256
	mov dx, offset notepadarray
	int 21h
	mov bx, [notepadhandle]
	mov ah, 3Eh
	int 21h
	jmp home
skipnotepad:
ret
endp notepad

proc settings ;check if you clicked settings button
	mov ax, 03h
	int 33h
	mov ax, cx
	push dx
	xor dx, dx
	mov cx, 2
	div cx
	mov cx, ax
	pop dx
	cmp cx, 167
	jb skipsettings
	cmp dx, 150
	jb skipsettings
	cmp cx, 202
	ja skipsettings
	cmp dx, 185
	ja skipsettings
	jmp settingss
settingss:
	mov ax, 02
	int 33h
	cmp [color], 0
	je black
	jmp notblack
black:
	mov ax, 13h
	int 10h
	mov [imX], 0
	mov [imY], 0
	push offset settingsblack
	call OpenFile
	
	mov [imLength], 320
	mov [imHeight], 200
	
	call Print
	
	call CloseFile
	jmp countinuesettings
notblack:
	cmp [color], 2
	je green
	jmp notgreen
green:
	mov ax, 13h
	int 10h
	mov [imX], 0
	mov [imY], 0
	push offset settingsgreen
	call OpenFile
	
	mov [imLength], 320
	mov [imHeight], 200
	
	call Print
	
	call CloseFile
	jmp countinuesettings
notgreen:
	cmp [color], 3
	je cyan
	jmp notcyan
cyan:
	mov ax, 13h
	int 10h
	mov [imX], 0
	mov [imY], 0
	push offset settingscyan
	call OpenFile
	
	mov [imLength], 320
	mov [imHeight], 200
	
	call Print
	
	call CloseFile
	jmp countinuesettings
notcyan:
	cmp [color], 4
	je red
	jmp notred
red:
	mov ax, 13h
	int 10h
	mov [imX], 0
	mov [imY], 0
	push offset settingsred
	call OpenFile
	
	mov [imLength], 320
	mov [imHeight], 200
	
	call Print
	
	call CloseFile
	jmp countinuesettings
notred:
	cmp [color], 5
	je purple
	jmp notpurple
purple:
	mov ax, 13h
	int 10h
	mov [imX], 0
	mov [imY], 0
	push offset settingspurple
	call OpenFile
	
	mov [imLength], 320
	mov [imHeight], 200
	
	call Print
	
	call CloseFile
	jmp countinuesettings

notpurple:
	cmp [color], 6
	je orenge
	jmp notorenge
orenge:
	mov ax, 13h
	int 10h
	mov [imX], 0
	mov [imY], 0
	push offset settingsorenge
	call OpenFile
	
	mov [imLength], 320
	mov [imHeight], 200
	
	call Print
	
	call CloseFile
	jmp countinuesettings
notorenge:
gray:
	mov ax, 13h
	int 10h
	mov [imX], 0
	mov [imY], 0
	push offset settingsgray
	call OpenFile
	
	mov [imLength], 320
	mov [imHeight], 200
	
	call Print
	
	call CloseFile

countinuesettings:
	mov ax, 01
	int 33h
	settingsloop:
	mov ax, 03
	int 33h
	cmp bx, 1
	jne settingsloop
	mov ax, cx
	mov cx, 2
	push dx
	xor dx, dx
	div cx
	mov cx, ax
	pop dx
@black:
	cmp cx, 18
	jb @green
	cmp cx, 30
	ja @green
	cmp dx, 43
	jb @green
	cmp dx, 55
	ja @green
	mov [coloredit], "0"
	call writefile
	jmp home
@green:
	cmp cx, 32
	jb @cyan
	cmp cx, 44
	ja @cyan
	cmp dx, 43
	jb @cyan
	cmp dx, 55
	ja @cyan
	mov [coloredit], "2"
	call writefile
	jmp home
@cyan:
	cmp cx, 46
	jb @red
	cmp cx, 58
	ja @red
	cmp dx, 43
	jb @red
	cmp dx, 55
	ja @red
	mov [coloredit], "3"
	call writefile
	jmp home
@red:
	cmp cx, 60
	jb @purple
	cmp cx, 72
	ja @purple
	cmp dx, 43
	jb @purple
	cmp dx, 55
	ja @purple
	mov [coloredit], "4"
	call writefile
	jmp home
@purple:
	cmp cx, 74
	jb @orenge
	cmp cx, 86
	ja @orenge
	cmp dx, 43
	jb @orenge
	cmp dx, 55
	ja @orenge
	mov [coloredit], "5"
	call writefile
	jmp home
@orenge:
	cmp cx, 88
	jb @gray
	cmp cx, 100
	ja @gray
	cmp dx, 43
	jb @gray
	cmp dx, 55
	ja @gray
	mov [coloredit], "6"
	call writefile
	jmp home
@gray:
	cmp cx, 102
	jb lowsens
	cmp cx, 114
	ja lowsens
	cmp dx, 43
	jb lowsens
	cmp dx, 55
	ja lowsens
	mov [coloredit], "7"
	call writefile
lowsens:
	cmp cx, 17
	jb normalsens
	cmp cx, 38
	ja normalsens
	cmp dx, 87
	jb normalsens
	cmp dx, 97
	ja normalsens
	mov ax, 1Ah
	mov bx, 12h
	mov cx, 12h
	mov dx, 12h
	int 33h
	jmp home
normalsens:
	cmp cx, 45
	jb highsens
	cmp cx, 78
	ja highsens
	cmp dx, 87
	jb highsens
	cmp dx, 97
	ja highsens
	mov ax, 1Ah
	mov bx, 32h
	mov cx, 32h
	mov dx, 32h
	int 33h
	jmp home
highsens:
	cmp cx, 85
	jb settingsloop
	cmp cx, 106
	ja settingsloop
	cmp dx, 87
	jb settingsloop
	cmp dx, 97
	ja settingsloop
	mov ax, 1Ah
	mov bx, 64h
	mov cx, 64h
	mov dx, 64h
	int 33h
	jmp home
skipsettings:
ret
endp settings

proc turnoff ;check if you clicked turnoff button
	mov ax, 03h
	int 33h
	mov ax, cx
	push dx
	xor dx, dx
	mov cx, 2
	div cx
	mov cx, ax
	pop dx
	cmp cx, 216
	jb skipturnoff
	cmp dx, 150
	jb skipturnoff
	cmp cx, 251
	ja skipturnoff
	cmp dx, 185
	ja skipturnoff
	jmp off
off:
	jmp exit
skipturnoff:
ret
endp turnoff

proc xorall
	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx
	ret
endp xorall

; --------------------------

start:
    mov ax, @data
    mov ds, ax
	
; -------------------------- video mode
home:
	mov ax, 13h
	int 10h
	xor ax, ax
	int 33h
	
	

; -------------------------- set background

	call background
	mov ax, 1h
	int 33h


main:
	call xorall
	call time
	mov ax, 03h
	int 33h
	cmp bx, 1
	je click
	jmp countinueMain
click:
	call printer
	call notepad
	call settings
	call turnoff
countinueMain:
	jmp main
	
	xor ax, ax
	int 16h
	
; --------------------------

exit:
	mov ax, 3
	int 10h
    mov ax, 4c00h
    int 21h
END start