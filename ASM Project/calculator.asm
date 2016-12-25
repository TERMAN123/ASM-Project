page 55,80
title Calculator               [calculator.asm]
; Author : adil abuwanu
; Date   : 10/7/16
.model small
.stack 100h
.data

msg1 db "Enter[+] sign for addition,[-] sign for substraction,[*] sign
for multiplication", 0DH, 0AH, "$"
msg2 db 0DH, 0AH,"Enter the first digit: " ,0DH, 0AH,"$"
msg3 db 0DH, 0AH,"Enter the second digit: ", 0DH, 0AH, "$"
msg4 db 0DH,0AH,"The result is: ","$"
msg5 db 0DH,0AH,"The result is: -","$"
num1 db ?       ; this is a numeric variable
num2 db ?        ; this is a numeric variable
num3 db ?        ; this is a numeric variable
num4 db ?        ; this is a numeric variable
num5  db 4       ; numeric value 4 is assigned to num5
.code
extrn clrscr:proc

main proc
    mov   ax,@data    ; set up data segment
    mov   ds,ax
    call  clrscr             ; clear the screen

    mov   dx,offset msg1
    call Display_string
    call keyin
    cmp al, 43             ; checks if it is addition
    je addition              ; jump to addition
    cmp al , 45            ; checks if it is substraction
    je substraction       ; jump to substraction

    mov   dx,offset msg2
    call Display_string
    call keyin               ; getting user input for first digit
    mov num1, al         ; moving the digit to num1
    sub num1, 30h       ; adjusting it to hexa-decimal
    mov al, num1
    mov num3, al
    mov   dx,offset msg3
    call Display_string
    call keyin               ; getting user input for second digit
    mov num2, al
    sub num2, 30h            ; adjusting it to hexa-decimal

mult :
    mov al, num3
    add num1, al
    dec num2
    jnz mult
    sub num1,al
    mov   dx,offset msg4
    call Display_string      ; displaying the result
    cmp num1, 10             ; find out if there are 2 numbers
    jns digits3
    call display_chr
    mov   ax,4C00h           ; return to DOS
    int 21h

addition:
    mov   dx,offset msg2
    call Display_string
    call keyin               ; getting user input for first digit
    mov num1, al             ; moving the digit to num1
    sub num1, 30h            ; adjusting it to hexa-decimal
    mov   dx,offset msg3
    call Display_string
    call keyin               ; getting user input for second digit
    sub al, 30h              ; adjusting it to hexa-decimal
    add num1, al
    mov   dx,offset msg4
    call Display_string      ; displaying the result
    cmp num1, 10             ; find out if there are 2 numbers
    jns digits1
    call display_chr
    mov   ax,4C00h           ; return
    int 21h

substraction:
    mov   dx,offset msg2
    call Display_string
    call keyin               ; getting user input for first digit
    mov num1, al             ; moving the digit to num1
    sub num1, 30h            ; adjusting it to hexa-decimal
    mov   dx,offset msg3
    call Display_string
    call keyin               ; getting user input for second digit
    sub al, 30h              ; adjusting it to hexa-decimal
    mov num2, al
    cmp al, num1
    jns digits2
    sub num1, al
    mov   dx,offset msg4
    call Display_string      ; displaying the result
    call display_chr
    mov   ax,4C00h           ; return
    int 21h

digits1:   
;it helps the addition find out the 2nd digit when the result is greater than 10
;its range is 10-19
        sub num1, 10
        mov bl, num1
        mov num1, 1
        call display_chr
        mov num1, bl
        call display_chr
        mov   ax,4C00h       ; return to DOS
        int   21h

digits2:   
;it helps the substraction to display the negative number when the result is less than 0  
        mov dx,offset msg5  ; displaying the negative sign
        call Display_string
        mov al, num2
        sub al,num1
        mov num1,al
        call display_chr
        mov   ax,4C00h        ; return to DOS
        int   21h

digits3:
       mov num4, 0
       mov eax, num1
loop1:
	mov edx, 0
	div num5
	push dx
	inc num4
	cmp eax, 0
	jnz loop1
loop2:
        pop dx
        add dl, 30h
        mov ah, 6
        int 21h
        dec num4
        jnz loop2
        mov ax, 4c00h   ; ret to DOS
        int 21h

keyin proc
        mov ah, 1          ; getting a key from the keyboard
        int 21h
        ret
        keyin endp

display_chr proc
        add num1, 30h    ; ascii adjust back
        mov ah, 6            ; sending a single character to the screen
        mov dl, num1
        int 21h
        ret
        display_chr endp

Display_string proc
        mov   ah,9           ; send first message
          int   21h
        ret
        Display_string endp

main endp
end  main

