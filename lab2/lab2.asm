; lab2.asm
; ECHO keyboard input
; Support for enter and backspace
org 0x7C00          ; BIOS loads boot sector to 0x7C00

jmp main            ; Jump to main

escape_backspace:
    mov ah, 03h     ; Call get cursor position
    int 10h         ; Call BIOS video services

    cmp dl, 0x00    ; Check if cursor is at the beginning of the line
    je new_line_backspace
    
    sub dl, 0x01    ; Move cursor back one character

    mov ah, 02h     ; Call set cursor position
    int 10h         ; Call BIOS video services

    mov ah, 0Ah     ; Call write character
    mov al, 0x00    ; Replace last character with 0x00
    int 10h         ; Call BIOS video services

    jmp main        ; Jump to main

new_line_backspace:
    mov ah, 03h     ; Call get cursor position
    int 10h         ; Call BIOS video services

    cmp dh, 0x00    ; Check if cursor is on the first line
    je main         ; Jump to main

    mov ah, 02h     ; Call set cursor position
    sub dh, 0x01    ; Move cursor up one line
    int 10h         ; Call BIOS video services

    jmp main        ; Jump to main

escape_enter:
    mov ah, 02h     ; Call set cursor position
    mov dl, 0x00    ; Move cursor to the beginning of the line
    add dh, 0x01    ; Move cursor down one line
    int 10h         ; Call BIOS video services

    jmp main        ; Jump to main

write:
    mov ah, 0Eh     ; Call write character
    int 10h         ; Call BIOS video services

    jmp main        ; Jump to main

main:
    mov sp, 0x7C00  ; Set stack pointer to 0x7C00

    mov ah, 00h     ; Call read next keystroke
    int 16h         ; Call BIOS keyboard I/O

    cmp ah, 0x0E    ; Check backspace
    je escape_backspace

    cmp ah, 0x1C    ; Check enter
    je escape_enter

    mov ah, 03h     ; Call get cursor position
    int 10h         ; Call BIOS video services

    cmp dl, 0x0F    ; Check if cursor is at the position 0x0F
    je main         ; Jump to main

    jmp write       ; Jump to write
