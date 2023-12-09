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

    main_read_track:
        call main_clear_num_buffer

        mov dx, 0x0300
        mov bp, main_track_prompt
        mov cx, main_track_prompt_len
        call main_print

        call main_read_b10

        mov ax, word [main_num_buffer]
        cmp ax, 0x1
        jl main_track_fault

        cmp ax, 0x12
        jg main_track_fault

        mov word [main_track], ax
        jmp main_read_sector

        main_track_fault:
            call main_clear_row
            jmp main_read_track

    main_read_sector:
        call main_clear_num_buffer

        mov dx, 0x0400
        mov bp, main_sector_prompt
        mov cx, main_sector_prompt_len
        call main_print

        call main_read_b10

        mov ax, word [main_num_buffer]
        cmp ax, 0x50
        jl main_accept_sector

        call main_clear_row
        jmp main_read_sector

        main_accept_sector:
            mov word [main_sector], ax
            jmp main_read_address

    main_read_address:
    ; TODO: continue here
    
    jmp $

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


section .data
    main_welcome db "Welcome to CornOS."
    main_welcome_len equ $ - main_welcome

    main_author db "Made by Corneliu Catlabuga."
    main_author_len equ $ - main_author

    main_side_prompt db "SIDE:   "
    main_side_prompt_len equ $ - main_side_prompt

    main_track_prompt db "TRACK:  "
    main_track_prompt_len equ $ - main_track_prompt

    main_sector_prompt db "SECTOR: "
    main_sector_prompt_len equ $ - main_sector_prompt

    main_num_buffer dw 0x0

    main_side dw 0x0
    main_track dw 0x0
    main_sector dw 0x0

    clean_row times 0x50 db 0x0