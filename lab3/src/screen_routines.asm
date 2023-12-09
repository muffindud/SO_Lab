; Clear the screen
clear_screen:
    pusha
    ; Clear the screen with INT 10h 07h
    mov ah, 07h
    mov al, 0x0
    mov bh, 0x7
    mov cx, 0x0
    mov dx, 0x184F
    int 10h

    ; Move the cursor to the top left corner
    mov ah, 02h
    mov dx, 0x0
    int 10h
    popa
    
    ret

; Remove the last character from the screen
remove_last_char:
    ; Move the cursor back
    mov ah, 02h
    sub dl, 0x1
    int 10h

    ; Remove the character from the screen
    mov ah, 0Ah
    mov al, 0x0
    int 10h

    ret

; Remove the last char on previous line
remove_last_char_line:
    ; Move the cursor to the end of the previous line
    mov ah, 02h
    mov dl, 0x4F
    sub dh, 0x1
    int 10h

    ; Remove the character from the screen
    mov ah, 0Ah
    mov al, 0x0
    int 10h

    ret

; Clear the current line
clear_row:
    mov ah, 03h
    int 10h 

    mov ax, 1301h
    mov bx, 0x7
    mov dl, 0x0
    mov bp, clean_row
    mov cx, 0x50
    int 10h

    ret

; Print the floppy error
print_error:
    cmp ah, 00h
    je floppy_error_00

    cmp ah, 01h
    je floppy_error_01

    cmp ah, 02h
    je floppy_error_02

    cmp ah, 03h
    je floppy_error_03

    cmp ah, 04h
    je floppy_error_04

    cmp ah, 06h
    je floppy_error_06

    cmp ah, 08h
    je floppy_error_08

    cmp ah, 09h
    je floppy_error_09

    cmp ah, 0Ch
    je floppy_error_0C

    cmp ah, 10h
    je floppy_error_10

    cmp ah, 20h
    je floppy_error_20

    cmp ah, 40h
    je floppy_error_40

    cmp ah, 80h
    je floppy_error_80

    floppy_error_00:
        mov bp, flp_err_00
        mov cx, flp_err_00_len
        jmp floppy_error_return
    
    floppy_error_01:
        mov bp, flp_err_01
        mov cx, flp_err_01_len
        jmp floppy_error_return

    floppy_error_02:
        mov bp, flp_err_02
        mov cx, flp_err_02_len
        jmp floppy_error_return
    
    floppy_error_03:
        mov bp, flp_err_03
        mov cx, flp_err_03_len
        jmp floppy_error_return
    
    floppy_error_04:
        mov bp, flp_err_04
        mov cx, flp_err_04_len
        jmp floppy_error_return
    
    floppy_error_06:
        mov bp, flp_err_06
        mov cx, flp_err_06_len
        jmp floppy_error_return
    
    floppy_error_08:
        mov bp, flp_err_08
        mov cx, flp_err_08_len
        jmp floppy_error_return
    
    floppy_error_09:
        mov bp, flp_err_09
        mov cx, flp_err_09_len
        jmp floppy_error_return
    
    floppy_error_0C:
        mov bp, flp_err_0C
        mov cx, flp_err_0C_len
        jmp floppy_error_return
    
    floppy_error_10:
        mov bp, flp_err_10
        mov cx, flp_err_10_len
        jmp floppy_error_return
    
    floppy_error_20:
        mov bp, flp_err_20
        mov cx, flp_err_20_len
        jmp floppy_error_return
    
    floppy_error_40:
        mov bp, flp_err_40
        mov cx, flp_err_40_len
        jmp floppy_error_return
    
    floppy_error_80:
        mov bp, flp_err_80
        mov cx, flp_err_80_len
        jmp floppy_error_return
    
    floppy_error_return:
        mov ax, 1301h
        mov bx, 0x7
        mov dh, 0x0
        mov dl, 0x0
        int 10h

        clc

        mov ah, 00h
        int 16h
        
        ret

section .data
    flp_err_00 db "No error"
    flp_err_00_len equ $ - flp_err_00

    flp_err_01 db "Bad command"
    flp_err_01_len equ $ - flp_err_01
    
    flp_err_02 db "Bad address mark"
    flp_err_02_len equ $ - flp_err_02
    
    flp_err_03 db "Write protected"
    flp_err_03_len equ $ - flp_err_03
    
    flp_err_04 db "Bad sector ID"
    flp_err_04_len equ $ - flp_err_04
    
    flp_err_06 db "Disk change line active"
    flp_err_06_len equ $ - flp_err_06
    
    flp_err_08 db "DMA failure"
    flp_err_08_len equ $ - flp_err_08
    
    flp_err_09 db "DMA overrun"
    flp_err_09_len equ $ - flp_err_09
    
    flp_err_0C db "Media type not available"
    flp_err_0C_len equ $ - flp_err_0C
    
    flp_err_10 db "Bad CRC"
    flp_err_10_len equ $ - flp_err_10
    
    flp_err_20 db "Diskete controller failure"
    flp_err_20_len equ $ - flp_err_20
    
    flp_err_40 db "Bad seek"
    flp_err_40_len equ $ - flp_err_40
    
    flp_err_80 db "Time-out"
    flp_err_80_len equ $ - flp_err_80
