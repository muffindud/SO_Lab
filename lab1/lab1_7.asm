; lab1_7.asm
; Display string and update cursor
org 0x7C00          ; BIOS loads boot sector to 0x7C00

jmp main            ; Jump to main

section .text
    ; Message to display
    msg db "Hello", 0

main:
    mov sp, 0x7C00  ; Set stack pointer
    
    mov ax, 1301h   ; Display string and update cursor
    mov bl, 0x02    ; Attribute green on black
    
    mov dh, 0       ; Set row cursor to 0
    mov dl, 0       ; Set column cursor to 0
    
    mov bp, msg     ; Load message into bp
    mov cx, 6       ; Set loop counter to 6

    int 10h         ; Call BIOS video interrupt
    
