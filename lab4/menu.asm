; TODO: Set the origin

menu:
    call menu_clear_screen

    mov dx, 0x0000
    mov bp, menu_message_1
    add bp, word [0x7C00]
    mov cx, menu_message_1_len
    call main_print

    mov dx, 0x0100
    mov bp, menu_message_2
    add bp, word [0x7C00]
    mov cx, menu_message_2_len
    call main_print

    mov dx, 0x0200
    mov bp, menu_message_3
    add bp, word [0x7C00]
    mov cx, menu_message_3_len
    call main_print

    mov dx, 0x0300
    mov bp, menu_mesage_prompt
    add bp, word [0x7C00]
    mov cx, menu_mesage_prompt_len
    call main_print

    call main_read_key

    cmp al, '1'
    je menu_hex_to_dec

    cmp al, '2'
    je menu_dec_to_hex

    cmp al, '3'
    je menu_bootloader

    jmp menu

menu_bootloader:
    call menu_clear_screen
    jmp 0x0:0x7E00

menu_clear_screen:
    pusha
    mov ah, 07h
    mov al, 0x0
    mov bh, 0x7
    mov cx, 0x0
    mov dx, 0x184F
    int 10h

    mov ah, 02h
    mov bh, 0x0
    mov dx, 0x0
    int 10h
    popa
    
    ret

main_print:
    mov ax, 1301h
    mov bx, 0x0007
    int 10h

    ret

main_read_key:
    mov ah, 0x00
    int 16h

    ret

menu_hex_to_dec:
    call menu_clear_screen    

    ; Code here

    mov ah, 00h
    int 16h

    jmp word [0x7C00]

menu_dec_to_hex:
    call menu_clear_screen

    ; Code here

    mov ah, 00h
    int 16h

    jmp word [0x7C00]

section .data
    menu_message_1 db "1. Hex to Decimal convertor."
    menu_message_1_len equ $ - menu_message_1

    menu_message_2 db "2. Decimal to Hex convertor."
    menu_message_2_len equ $ - menu_message_2

    menu_message_3 db "3. Go to bootloader."
    menu_message_3_len equ $ - menu_message_3

    menu_mesage_prompt db "Enter your choice: "
    menu_mesage_prompt_len equ $ - menu_mesage_prompt
