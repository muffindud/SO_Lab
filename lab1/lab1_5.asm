; lab1_5.asm
; Display character + attribute and update cursor
org 0x7C00          ; BIOS loads boot sector to 0x7C00

jmp main            ; Jump to main

section .text
    ; msg db 'Hello' with individual attributes
    msg db 'H', 0x09, 'e', 0x0E, 'l', 0x0B, 'l', 0x0C, 'o', 0x0D

main:
    mov sp, 0x7C00  ; Set stack pointer to 0x7C00

    mov ax, 1303h   ; BIOS display char+attr and update cursor

    mov dh, 0       ; Set row cursor to 0
    mov dl, 0       ; Set column cursor to 0

    mov bp, msg     ; Load msg into bp
    mov cx, 6       ; Set loop counter to 6

    int 10h         ; Call BIOS video interrupt
