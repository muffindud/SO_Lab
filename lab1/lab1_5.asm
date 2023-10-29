; lab1_5.asm
; Display character + attribute and update cursor
org 0x7C00

jmp main

section .text
    msg db 'H', 0x09, 'e', 0x0E, 'l', 0x0B, 'l', 0x0C, 'o', 0x0D

main:
    mov sp, 0x7C00

    mov ax, 1303H

    mov dh, 0
    mov dl, 0

    mov bp, msg
    mov cx, 6

    int 10H
