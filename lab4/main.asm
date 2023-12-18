main:
    mov dx, 0x0000
    mov bp, main_welcome
    mov cx, main_welcome_len
    call main_print

    mov dx, 0x0100
    mov bp, main_author
    mov cx, main_author_len
    call main_print

    main_read_side:
        call main_clear_num_buffer
    
        mov dx, 0x0200
        mov bp, main_side_prompt
        mov cx, main_side_prompt_len
        call main_print

        call main_read_b10

        mov ax, word [main_num_buffer]
        cmp ax, 0x2
        jl main_accept_side

        call main_clear_row
        jmp main_read_side

    main_accept_side:
        mov word [main_side], ax

    main_read_sector:
        call main_clear_num_buffer

        mov dx, 0x0300
        mov bp, main_sector_prompt
        mov cx, main_sector_prompt_len
        call main_print

        call main_read_b10

        mov ax, word [main_num_buffer]
        cmp ax, 0x1
        jl main_sector_fault

        cmp ax, 0x12
        jg main_sector_fault

        mov word [main_sector], ax
        jmp main_read_track

        main_sector_fault:
            call main_clear_row
            jmp main_read_sector

    main_read_track:
        call main_clear_num_buffer

        mov dx, 0x0400
        mov bp, main_track_prompt
        mov cx, main_track_prompt_len
        call main_print

        call main_read_b10

        mov ax, word [main_num_buffer]
        cmp ax, 0x50
        jl main_accept_track

        call main_clear_row
        jmp main_read_track

        main_accept_track:
            mov word [main_track], ax
    
    main_read_sector_ct:
        call main_clear_num_buffer

        mov dx, 0x0500
        mov bp, main_sector_ct_prompt
        mov cx, main_sector_ct_prompt_len
        call main_print

        call main_read_b10

        mov ax, word [main_num_buffer]
        cmp ax, 0x1F

        jl main_accept_sector_ct

        call main_clear_row
        jmp main_read_sector_ct

        main_accept_sector_ct:
            mov word [main_sector_ct], ax

    main_read_address:
        call main_clear_num_buffer

        mov dx, 0x0600
        mov bp, main_address_prompt
        mov cx, main_address_prompt_len
        call main_print

        call main_read_b16

        mov ax, word [main_num_buffer]
        mov word [main_address_1], ax

        mov ah, 0Eh
        mov al, ':'
        int 10h

        call main_clear_num_buffer
        
        call main_read_b16

        mov ax, word [main_num_buffer]
        mov word [main_address_2], ax

    push es
    push bx
    mov bx, word [main_address_1]
    mov es, bx
    mov bx, word [main_address_2]

    mov cl, byte [main_sector]
    mov dh, byte [main_side]
    mov ch, byte [main_track]

    main_read_loop:
        mov ah, 02h
        mov al, 0x1
        mov dl, 0x0
        int 13h

        mov al, byte [main_sector_ct]
        cmp al, 0x0
        je main_read_loop_end

        sub al, 0x1
        mov byte [main_sector_ct], al

        cmp cl, 0x12
        jl main_read_loop_continue
        mov cl, 0x0
        add dh, 0x1

        cmp dh, 0x2
        jl main_read_loop_continue
        mov dh, 0x0
        add ch, 0x1

    main_read_loop_continue:
        add cl, 0x1
        add bx, 0x200
        jmp main_read_loop

    main_read_loop_end:
        pop bx
        pop es

    jc main_floppy_error

    mov bp, main_floppy_code
    mov cx, main_floppy_code_len
    mov dx, 0x0700
    call main_print

    mov ax, 0x0E30
    mov bl, 0x7
    int 10h
    int 10h

    mov bp, main_address_loaded_1
    mov cx, main_address_loaded_1_len
    mov dx, 0x0800
    call main_print

    mov bp, main_address_loaded_2
    mov cx, main_address_loaded_2_len
    mov dx, 0x0900
    call main_print

    mov bx, [main_address_1]
    mov es, bx
    mov bx, [main_address_2]

    mov ah, 00h
    int 16h

    call main_clear_screen

    mov word [program_offset], bx

    jmp bx

    main_floppy_error:
        mov dx, 0x0
        mov al, 0x0
        mov cx, 0x10
        div cx

        mov ah, al
        mov ah, 0Eh
        mov bl, 0x7
        cmp al, 0xA
        jl main_floppy_error_num1

        add al, 0x7

        main_floppy_error_num1:
            add al, 0x30

        int 10h

        mov ah, 0Eh
        mov bl, 0x7
        mov al, dh
        cmp al, 0xA
        jl main_floppy_error_num2

        add al, 0x7

        main_floppy_error_num2:
            add al, 0x30

        int 10h

        clc

        mov ah, 00h
        int 16h

        jmp main

main_print:
    mov ax, 1301h
    mov bx, 0x0007
    int 10h

    ret

main_clear_row:
    mov ah, 03h
    int 10h

    mov bp, clean_row
    mov cx, 0x50
    mov dl, 0x0
    mov ax, 1301h
    mov bx, 0x0007
    int 10h

    ret

main_clear_num_buffer:
    mov ax, 0x0
    mov word [main_num_buffer], ax

    ret

main_read_b10:
    mov ah, 00h
    int 16h

    cmp al, 0x0D
    je main_read_b10_return

    cmp al, 0x08
    je main_read_b10_backspace

    cmp al, 0x30
    jl main_read_b10
    cmp al, 0x39
    jg main_read_b10

    sub al, 0x30
    mov cl, al
    mov ax, word [main_num_buffer]

    cmp ax, 0xCCC
    je main_read_b10_limit
    
    cmp ax, 0xCCC
    jl main_read_b10_accept

    jmp main_read_b10

    main_read_b10_accept:
        mov dx, 0xA
        mul dx
        add ax, cx
        mov word [main_num_buffer], ax

        mov ah, 0Eh
        mov al, cl
        add al, 0x30
        int 10h

        jmp main_read_b10

    main_read_b10_return:
        ret
    
    main_read_b10_backspace:
        mov dx, 0x0
        mov ax, word [main_num_buffer]
        cmp ax, 0x0
        je main_read_b10

        mov cx, 0xA
        div cx
        mov word [main_num_buffer], ax

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

        jmp main_read_b10

    main_read_b10_limit:
        cmp cl, 0x7
        jg main_read_b10

        jmp main_read_b10_accept

main_read_b16:
    mov ah, 00h
    int 16h
    
    cmp al, 0x1B
    je main_read_b16_return

    cmp al, 0x0D
    je main_read_b16_return

    cmp al, 0x08
    je main_read_b16_backspace

    cmp al, 0x30
    jl main_read_b16

    cmp al, 0x3A
    jl main_read_b16_handle_number

    cmp al, 0x41
    jl main_read_b16

    cmp al, 0x47
    jl main_read_b16_handle_uppercase

    cmp al, 0x61
    jl main_read_b16

    cmp al, 0x67
    jl main_read_b16_handle_lowercase

    jmp main_read_b16

    main_read_b16_handle_number:
        sub al, 0x30
        jmp main_read_b16_handle_value

    main_read_b16_handle_uppercase:
        sub al, 0x37
        jmp main_read_b16_handle_value

    main_read_b16_handle_lowercase:
        sub al, 0x57
        jmp main_read_b16_handle_value

    main_read_b16_handle_value:
        mov cl, al
        mov ax, [main_num_buffer]

        cmp ax, 0xFFF
        ja main_read_b16

        mov dx, 0x10
        mul dx

        add ax, cx
        mov [main_num_buffer], ax

        mov ah, 0Eh
        mov al, cl
        cmp cx, 0x9
        jg main_read_b16_print_letter
            add al, 0x30
            int 10h
            jmp main_read_b16

        main_read_b16_print_letter:
            add al, 0x37
            int 10h
            jmp main_read_b16

    main_read_b16_return:
        ret
    
    main_read_b16_backspace:
        mov dx, 0x0
        mov ax, [main_num_buffer]
        cmp ax, 0x0
        je main_read_b16

        mov cx, 0x10
        div cx
        mov [main_num_buffer], ax
        
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

        jmp main_read_b16

main_clear_screen:
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

section .data
    main_welcome db "Welcome to CornOS."
    main_welcome_len equ $ - main_welcome

    main_author db "Made by Corneliu Catlabuga."
    main_author_len equ $ - main_author

    main_sector_ct_prompt db "SEC CT: "
    main_sector_ct_prompt_len equ $ - main_sector_ct_prompt

    main_side_prompt db "SIDE:   "
    main_side_prompt_len equ $ - main_side_prompt

    main_track_prompt db "TRACK:  "
    main_track_prompt_len equ $ - main_track_prompt

    main_sector_prompt db "SECTOR: "
    main_sector_prompt_len equ $ - main_sector_prompt

    main_address_prompt db "ADDRESS: "
    main_address_prompt_len equ $ - main_address_prompt

    main_floppy_code db "Floppy code: "
    main_floppy_code_len equ $ - main_floppy_code

    main_address_loaded_1 db "Sectors loaded."
    main_address_loaded_1_len equ $ - main_address_loaded_1

    main_address_loaded_2 db "Press any key to continue..."
    main_address_loaded_2_len equ $ - main_address_loaded_2

    main_num_buffer dw 0x0

    main_side dw 0x0
    main_track dw 0x0
    main_sector dw 0x0
    main_sector_ct dw 0x0

    main_address_1 dw 0x0
    main_address_2 dw 0x0

    clean_row times 0x50 db 0x0
