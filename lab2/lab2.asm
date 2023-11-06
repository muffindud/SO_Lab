; lab2.asm
; ECHO keyboard input
; Support for enter and backspace
org 0x7C00          ; BIOS loads boot sector to 0x7C00

jmp start            ; Jump to main

; section .bss
; Buffer for keyboard input

escape_backspace:
    mov ah, 03h     ; Call get cursor position
    int 10h         ; Call BIOS video services

    cmp si, buffer  ; Check if buffer is empty
    je main         ; Jump to main
    
    dec si          ; Decrement source index
    mov byte [si], 0x00 ; Replace last character with 0x00

    cmp dl, 0x00    ; Check if cursor is on the first column
    jz new_line_backspace

    mov ah, 02h     ; Call set cursor position
    dec dl          ; Move cursor left one column
    int 10h         ; Call BIOS video services

    mov ah, 0Ah     ; Call write character
    mov al, 0x00    ; Replace last character on screen with 0x00
    int 10h         ; Call BIOS video services

    jmp main        ; Jump to main

new_line_backspace:
    mov ah, 03h     ; Call get cursor position
    int 10h         ; Call BIOS video services

    cmp dh, 0x00    ; Check if cursor is on the first line
    je main         ; Jump to main

    ; dec si          ; Decrement source index
    ; mov byte [si], 0x00 ; Replace last character with 0x00

    mov ah, 02h     ; Call set cursor position
    mov dl, 0x4F    ; Move cursor to the end of the line
    dec dh          ; Move cursor up one line
    int 10h         ; Call BIOS video services

    mov ah, 0Ah     ; Call write character
    mov al, 0x00    ; Replace last character on screen with 0x00
    int 10h         ; Call BIOS video services

    jmp main        ; Jump to main

escape_enter:
    mov ah, 03h     ; Call get cursor position
    int 10h         ; Call BIOS video services

    sub si, buffer  ; Get length of buffer
    jz empty_enter

    ; mov ax, 0
    ; mov es, ax

    mov ax, 1301h   ; Call write string
    mov bl, 07h     ; Set text attribute
    mov bp, buffer  ; Set buffer pointer
    mov cx, si      ; Set length of buffer
    mov dl, 0x00    ; Move cursor to the beginning of the line
    inc dh          ; Move cursor down one line
    int 10h

    mov ah, 03h     ; Call get cursor position
    int 10h         ; Call BIOS video services

    mov ah, 02h     ; Call set cursor position
    mov dl, 0x00    ; Move cursor to the beginning of the line
    inc dh          ; Move cursor down one line
    int 10h         ; Call BIOS video services

    add si, buffer  ; Reset source index
    
    jmp clear_buffer

clear_buffer:
    mov byte [si], 0x00 ; Reset buffer
    inc si
    cmp si, 0x00
    jne clear_buffer

    mov si, buffer  ; Reset source index

    jmp main

empty_enter:
    mov ah, 02h     ; Call set cursor position
    mov dl, 0x00    ; Move cursor to the beginning of the line
    inc dh          ; Move cursor down one line
    int 10h         ; Call BIOS video services

    jmp main        ; Jump to main

main:
    mov ah, 00h     ; Call read next keystroke
    int 16h         ; Call BIOS keyboard I/O

    cmp ah, 0x0E    ; Check backspace
    je escape_backspace

    cmp ah, 0x1C    ; Check enter
    je escape_enter

    cmp si, buffer + 256    ; Check if buffer is full
    je main        ; Jump to write

    mov [si], al    ; Store character in buffer
    inc si          ; Increment source index

    ; mov ah, 03h     ; Call get cursor position
    ; int 10h         ; Call BIOS video services

    mov ah, 0Eh     ; Call write character
    int 10h         ; Call BIOS video services

    jmp main        ; Jump to main

start:
    mov sp, 0x7C00  ; Set stack pointer to 0x7C00
    mov si, buffer  ; Set source index to buffer

    jmp main

buffer: times 256 db 0x00

