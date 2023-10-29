; lab1_2.asm
; Write character
org 0x7C00

jmp main

main:
    mov sp, 0x7C00

    mov ah, 0Ah
    mov al, 'B'
    int 10h
    