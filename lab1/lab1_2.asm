; lab1_2.asm
; Write character
org 0x7c00

jmp main

main:
    mov sp, 0x7c00

    mov ah, 0aH
    mov al, 'B'
    int 10H
    