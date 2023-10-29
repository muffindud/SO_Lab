; lab1_3.asm
; Write character/attribute
org 0x7C00          ; BIOS loads boot sector to 0x7C00

jmp main            ; Jump to main

main:
    mov sp, 0x7C00  ; Set stack pointer to 0x7C00

    mov ah, 09h     ; BIOS write character with attribute
    mov al, 'C'     ; Character to print
    mov bl, 0x05    ; Attribute magenta on black
    int 10h         ; Call BIOS video interrupt
    