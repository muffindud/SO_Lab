menu:
    ; Call "clear_screen" from "screen_routines.asm"
    call clear_screen

    ; Print the main message
    mov ax, 1301h
    mov bx, 0x7
    mov bp, main_message
    mov cx, main_message_size
    mov dl, 0x0
    mov dh, 0x0
    int 10h

    ; Read the option
    mov ah, 00h
    int 16h

    ; Check if option "1"
    cmp al, '1'
    je keyboard_to_floppy

    ; Check if option "2"
    cmp al, '2'
    je floppy_to_ram

    ; Check if option "3"
    cmp al, '3'
    je ram_to_floppy

    ; If the option is not valid display an unexpected option message
    ; Call "clear_screen" from "screen_routines.asm"
    call clear_screen

    ; Print the unexpected option message
    mov ax, 1301h
    mov bx, 0x7
    mov bp, unexpected_option_message
    mov cx, unexpected_option_message_size
    mov dl, 0x0
    mov dh, 0x0
    int 10h

    ; Wait for a key press
    mov ah, 00h
    int 16h

    ; Return to the menu
    jmp menu

section .data
    ; Main message buffer and size
    main_message db "Please select an option: ", 0xA, 0xD, "1. Keyboard to Floppy", 0xA, 0xD, "2. Floppy to RAM", 0xA, 0xD, "3. RAM to Floppy", 0xA, 0xD, 0xA, 0xD, "Your option: "
    main_message_size equ $ - main_message

    ; Unexpected option message buffer and size
    unexpected_option_message db "Unexpected option!", 0xA, 0xD, 0xA, 0xD, "Press any key to continue..."
    unexpected_option_message_size equ $ - unexpected_option_message

