; lab1_7.asm
; Display string and update cursor
org 0x7C00

jmp main

section .text
    msg db "Hello", 0

main:
    mov sp, 0x7C00
    
    mov ax, 1301h
    mov bl, 0x02
    
    mov dh, 0
    mov dl, 0
    
    mov bp, msg
    mov cx, 6

    int 10h
    
