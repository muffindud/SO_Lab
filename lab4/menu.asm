; TODO: Set the origin

menu:
    call menu_clear_screen

    mov dx, 0x0000
    mov bp, menu_message_1
    mov cx, menu_message_1_len
    call menu_print

    mov dx, 0x0100
    mov bp, menu_message_2
    mov cx, menu_message_2_len
    call menu_print

    mov dx, 0x0200
    mov bp, menu_message_3
    mov cx, menu_message_3_len
    call menu_print

    mov dx, 0x0300
    mov bp, menu_mesage_prompt
    mov cx, menu_mesage_prompt_len
    call menu_print

    call menu_read_key

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

menu_print:
    mov ax, 1301h
    mov bx, 0x0007
    add bp, word [0x7C00]
    int 10h

    ret

menu_read_key:
    mov ah, 0x00
    int 16h

    ret

menu_hex_to_dec:
    call menu_clear_screen    
    call menu_clear_buffers

    mov dx, 0x0000
    mov bp, menu_message_hex_prompt
    mov cx, menu_message_hex_prompt_len
    call menu_print

    call menu_read_b16

    mov dx, 0x0100
    mov bp, menu_message_dec_prompt
    mov cx, menu_message_dec_prompt_len
    call menu_print

    mov dx, 0x0400
    mov bp, menu_message_continue
    mov cx, menu_message_continue_len
    call menu_print

    call menu_read_key

    jmp word [0x7C00]

menu_dec_to_hex:
    call menu_clear_screen
    call menu_clear_buffers

    mov dx, 0x0000
    mov bp, menu_message_dec_prompt
    mov cx, menu_message_dec_prompt_len
    call menu_print

    call menu_read_b10

    mov dx, 0x0100
    mov bp, menu_message_hex_prompt
    mov cx, menu_message_hex_prompt_len
    call menu_print

    mov dx, 0x0400
    mov bp, menu_message_continue
    mov cx, menu_message_continue_len
    call menu_print

    call menu_read_key

    jmp word [0x7C00]

menu_clear_buffers:
    mov si, menu_num_buffer
    add si, word [0x7C00]
    mov word [si], 0x0

    mov si, menu_num_ascii_buffer
    add si, word [0x7C00]
    mov word [si], 0x0

    ret

menu_read_b10:
    call menu_read_key

    cmp al, 0x0D
    je menu_read_b10_return

    cmp al, 0x08
    je menu_read_b10_backspace

    cmp al, 0x30
    jl menu_read_b10
    cmp al, 0x39
    jg menu_read_b10

    sub al, 0x30
    mov cl, al
    mov si, menu_num_buffer
    add si, word [0x7C00]
    mov ax, word [si]

    cmp ax, 0x1999
    je menu_read_b10_limit

    cmp ax, 0x1999
    jb menu_read_b10_accept

    jmp menu_read_b10

    menu_read_b10_accept:
        mov dx, 0xA
        mul dx
        add ax, cx
        mov word [si], ax

        mov ah, 0Eh
        mov al, cl
        add al, 0x30
        int 10h

        jmp menu_read_b10

    menu_read_b10_return:
        ret

    menu_read_b10_backspace:
        mov dx, 0x0
        mov si, menu_num_buffer
        add si, word [0x7C00]
        mov ax, word [si]
        cmp ax, 0x0
        je menu_read_b10

        mov cx, 0xA
        div cx
        mov word [si], ax

        pusha
        mov ah, 03h
        mov bh, 0x0
        int 10h
        mov ah, 02h
        sub dl, 0x1
        int 10h
        mov ah, 0Ah
        mov al, 0x0
        int 10h
        popa

        jmp menu_read_b10

    menu_read_b10_limit:
        cmp cl, 0x5
        jg menu_read_b10

        jmp menu_read_b10_accept

menu_read_b16:
    call menu_read_key

    cmp al, 0x1B
    je menu_read_b16_return

    cmp al, 0x0D
    je menu_read_b16_return

    cmp al, 0x08
    je menu_read_b16_backspace

    cmp al, 0x30
    jl menu_read_b16

    cmp al, 0x3A
    jl menu_read_b16_handle_number

    cmp al, 0x41
    jl menu_read_b16

    cmp al, 0x47
    jl menu_read_b16_handle_uppercase

    cmp al, 0x61
    jl menu_read_b16

    cmp al, 0x67
    jl menu_read_b16_handle_lowercase

    jmp menu_read_b16

    menu_read_b16_handle_number:
        sub al, 0x30
        jmp menu_read_b16_handle_value

    menu_read_b16_handle_uppercase:
        sub al, 0x37
        jmp menu_read_b16_handle_value

    menu_read_b16_handle_lowercase:
        sub al, 0x57
        jmp menu_read_b16_handle_value

    menu_read_b16_handle_value:
        mov cl, al
        mov si, menu_num_buffer
        add si, word [0x7C00]
        mov ax, word [si]

        cmp ax, 0xFFF
        ja menu_read_b16

        mov dx, 0x10
        mul dx

        add ax, cx
        mov word [si], ax

        mov ah, 0Eh
        mov al, cl
        cmp cx, 0x9
        jg menu_read_b16_print_letter
        
        add al, 0x30
        int 10h
        
        jmp menu_read_b16

        menu_read_b16_print_letter:
            add al, 0x37
            int 10h
            jmp menu_read_b16

    menu_read_b16_return:
        ret
    
    menu_read_b16_backspace:
        mov dx, 0x0
        mov si, menu_num_buffer
        add si, word [0x7C00]
        mov ax, word [si]
        cmp ax, 0x0
        je menu_read_b16

        mov cx, 0x10
        div cx
        mov [si], ax
        
        pusha
        mov ah, 03h
        mov bh, 0x0
        int 10h
        mov ah, 02h
        sub dl, 0x1
        int 10h
        mov ah, 0Ah
        mov al, 0x0
        int 10h
        popa

        jmp menu_read_b16

section .data
    menu_message_1 db "1. Hex to Decimal convertor."
    menu_message_1_len equ $ - menu_message_1

    menu_message_2 db "2. Decimal to Hex convertor."
    menu_message_2_len equ $ - menu_message_2

    menu_message_3 db "3. Go to bootloader."
    menu_message_3_len equ $ - menu_message_3

    menu_mesage_prompt db "Enter your choice: "
    menu_mesage_prompt_len equ $ - menu_mesage_prompt

    menu_message_hex_prompt db "Hex: "
    menu_message_hex_prompt_len equ $ - menu_message_hex_prompt

    menu_message_dec_prompt db "Dec: "
    menu_message_dec_prompt_len equ $ - menu_message_dec_prompt

    menu_message_continue db "Press any key to continue..."
    menu_message_continue_len equ $ - menu_message_continue

    menu_num_buffer dw 0x0000

    menu_num_ascii_buffer dw 0x0000
