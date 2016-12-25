page 55,80
title Fibonacci                    [fibonacci.asm]
;Author  : Adil Abuwani
;Date     : 12/25/16
.model small
.386
.stack 100h
.data

msg1 db “Enter an integer to determine the Fibonacci length”, 0DH, 0AH, “$”
msg2 db 0DH, 0AH”Fibonacci sequence: “, 0DH, 0AH, “$”
num1 db ?  ; this is a numeric value
num2 db ?  ; this is a numeric value
counter db 10; numeric value 10 is assigned to counter
num3 dd 1  ; numeric value 1 is assigned to num3
num4 dd 0 ;  numeric value 0 is assigned to num4
num5 dd 1 ;  numeric value 1 is assigned to num5
.code
extrn clrscr:proc

main proc
    mov   ax,@data    ;set up data segment
    mov   ds,ax
    call  clrscr            ; clear the screen
    
    mov   dx,offset msg1
    call Display_string
    call keyin            ;asking for 1st digit 
    mov num1, al
    sub num1, 30h  ; adjusting to hexa-decimal
    call keyin            ; asking for 2nd digit
    mov num2, al
    sub num2, 30h  ; adjusting to hexa-decimal
    mov al, num1
number::                 ; this loop help to make the two digits into a single number 
    add num1, al
    dec counter  
    jnz number
    sub num1, al
    mov al, num2
    add num1, al
    mov   dx,offset msg2
    call Display_string
    sub num1, 2
    call display_result

fibo:
    mov   dx,offset msgNL
    call Display_string
;assigning num5, num4 to eax and ebx respectively to avoid moving it to ‘al’ after every step
    mov eax, num5    
    mov ebx, num4
    mov ecx, 0000h
    add ecx, ebx
    add ecx, eax
    mov num3, ecx
    mov num5, ecx
    mov num4, eax
    call display_result
    sub num1, 1
    cmp num1, 0
    jns fibo
    mov ax, 4c00h   ; return to DOS
    int 21h

keyin proc
        mov ah, 1            ; getting a key from the keyboard
        int 21h
        ret
        keyin endp
display_chr proc
        add num1, 30h        ; ascii adjust back
        mov ah, 6            ; sending a single character to the screen
        mov dl, num1
        int 21h
        ret
        display_chr endp
display_result proc
       mov eax, num3
       call display_chr
       ret
       display_result endp 
Display_string proc
        mov   ah,9           ; send first message
        int   21h
        ret
        Display_string endp

main endp
end  main

