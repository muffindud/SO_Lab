; lab1_1.asm
; Write character as tty
org 0x7c00

jmp main

main:
    mov sp, 0x7c00

    mov ah, 0eH
    mov al, 'A'
    int 10H
