; lab1_6.asm
; Display string
org 0x7C00          ; BIOS loads boot sector to 0x7C00

jmp main            ; Jump to main

section .text
    ; Message to display
    msg db "Hello", 0

main:
    mov sp, 0x7C00  ; Set stack pointer to 0x7C00
    
    mov ax, 1300h   ; BIOS display string
    mov bl, 0x02    ; Attribute green on black
    
    mov dh, 0       ; Set row cursor to 0
    mov dl, 0       ; Set column cursor to 0
    
    mov bp, msg     ; Load message address to bp
    mov cx, 6       ; Set loop counter to 6

    int 10h         ; Call BIOS video interrupt
    
