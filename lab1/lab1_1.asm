; lab1_1.asm
; Write character as tty
org 0x7C00

jmp main

main:
    mov sp, 0x7C00

    mov ah, 0Eh
    mov al, 'A'
    int 10h
