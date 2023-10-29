; lab1_1.asm
; Write character as tty
org 0x7C00          ; BIOS loads boot sector to 0x7C00

jmp main            ; Jump to main

main:
    mov sp, 0x7C00  ; Set stack pointer to 0x7C00

    mov ah, 0Eh     ; BIOS tty function
    mov al, 'A'     ; Character to print
    int 10h         ; Call BIOS video interrupt
