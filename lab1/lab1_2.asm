; lab1_2.asm
; Write character
org 0x7C00          ; BIOS loads boot sector to 0x7C00

jmp main            ; Jump to main

main:
    mov sp, 0x7C00  ; Set stack pointer to 0x7C00

    mov ah, 0Ah     ; BIOS write character function
    mov al, 'B'     ; Character to print
    int 10h         ; Call BIOS video interrupt
    