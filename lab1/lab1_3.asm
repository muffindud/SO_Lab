; lab1_3.asm
; Write character/attribute
org 0x7C00

jmp main

main:
    mov sp, 0x7C00

    mov ah, 09h
    mov al, 'C'
    mov bl, 0x05
    int 10h
    