keyboard_to_floppy:
    ; Call "clear_screen" from "screen_routines.asm"
    call clear_screen

    ; Move si to the beginning of the buffer
    mov si, buffer

    ; Call "print_text_prompt" from "prompts.asm"
    call print_text_prompt

    ktf_input:
        ; Read a character from the keyboard
        mov ah, 00h
        int 16h

        ; Check if enter was pressed and handle it
        ; (if yes: go to "ktf_input_done")
        cmp al, 0x0D
        je ktf_input_done
    
        ; (if no)
        ; Check if backspace was pressed and handle it
        cmp al, 0x08
        je ktf_bakcspace

        ; Check if escape was pressed and handle it
        ; (if yes: go to "escape")
        cmp al, 0x1B
        je escape

        ; (if no)
        ; Check if the buffer is full 
        ; (if yes: loop back to "ktf_input")
        cmp si, buffer + 0x100
        je ktf_input

        ; (if no)
        ; Check if the character is in printable ASCII limit 
        ; (if no: loop back to "ktf_input")
        cmp al, 0x20
        jl ktf_input
        cmp al, 0x7E
        jg ktf_input

        ; (if yes)
        ; Store the character in the buffer
        mov [si], al
        add si, 0x1

        ; Print the character
        mov ah, 0Eh
        int 10h

        ; Loop back to "ktf_input"
        jmp ktf_input

; Handle enter
ktf_input_done:
    ; Check if the buffer is empty
    ; (if yes: go to "menu" from "menu.asm")
    sub si, buffer
    jz menu

    ; (if no)
    ; Get the current cursor position
    mov ah, 03h
    int 10h

    ; call "print_buffer" from "prompts.asm"
    call print_buffer
    
    ; Get side loop
    get_side:
        ; Clear num_buffer
        mov ax, 0x0
        mov [num_buffer], ax

        ; Move cursor to line 12, column 0
        mov ah, 02h
        mov dl, 0x0
        mov dh, 0xC
        int 10h

        ; Call "clear_row" from "screen_routines.asm"
        call clear_row

        ; Call "print_side_prompt" from "prompts.asm"
        call print_side_prompt

        ; Call "read_num" from "string_convertors.asm"
        call read_num

        ; Check if read_num returned 0x1B (escape)
        ; (if yes: go to "escape")
        cmp al, 0x1B
        je escape
        
        ; (if no)
        ; Load num_buffer into ax and store in side buffer
        mov ax, [num_buffer]
        mov [side], ax
    
        ; Check if side is in range [0, 1]
        ; (if yes: go to "get_track")
        mov ax, [side]
        cmp ax, 0x2
        jl get_track

        ; (if no)
        ; Call "print_side_warning" from "prompts.asm"
        call print_side_warning
        
        ; Clear the buffers
        mov ax, 0x0
        mov [num_buffer], ax
        mov [side], ax

        ; Loop back to "get_side"
        jmp get_side

    ; Get track loop
    get_track:
        ; Clear num_buffer
        mov ax, 0x0
        mov [num_buffer], ax
        
        ; Move cursor to line 13, column 0
        mov ah, 02h
        mov dl, 0x0
        mov dh, 0xD
        int 10h

        ; Call "clear_row" from "screen_routines.asm"
        call clear_row

        ; Call "print_track_prompt" from "prompts.asm"
        call print_track_prompt

        ; Call "read_num" from "string_convertors.asm"
        call read_num

        ; Check if read_num returned 0x1B (escape)
        ; (if yes: go to "escape")
        cmp al, 0x1B
        je escape
        
        ; (if no)
        ; Load num_buffer into ax and store in track buffer
        mov ax, [num_buffer]
        mov [track], ax

        ; Check greater than 18
        ; (if yes: go to "track_fault")
        mov ax, [track]
        cmp ax, 0x12
        jg track_fault

        ; (if no)
        ; Check if track is 0
        ; (if yes: go to "track_fault")
        cmp ax, 0x0
        je track_fault

        ; (if no)
        ; Go to "get_sector"
        jmp get_sector

        ; Track fault
        track_fault:
            ; Call "print_track_warning" from "prompts.asm"
            call print_track_warning

            ; Clear the buffers
            mov ax, 0x0
            mov [num_buffer], ax
            mov [track], ax

            ; Loop back to "get_track"
            jmp get_track
    
    ; Get sector loop
    get_sector:
        ; Clear num_buffer
        mov ax, 0x0
        mov [num_buffer], ax
        
        ; Move cursor to line 14, column 0
        mov ah, 02h
        mov dl, 0x0
        mov dh, 0xE
        int 10h

        ; Call "clear_row" from "screen_routines.asm"
        call clear_row

        ; Call "print_sector_prompt" from "prompts.asm"
        call print_sector_prompt

        ; Call "read_num" from "string_convertors.asm"
        call read_num

        ; Check if read_num returned 0x1B (escape)
        ; (if yes: go to "escape")
        cmp al, 0x1B
        je escape
        
        ; (if no)
        ; Load num_buffer into ax and store in sector buffer
        mov ax, [num_buffer]
        mov [sector], ax

        ; Check if sector is less than 80
        ; (if yes: go to "get_times")
        mov ax, [sector]
        cmp ax, 0x50
        jl get_times

        ; (if no)
        ; Call "print_sector_warning" from "prompts.asm"
        call print_sector_warning

        ; Clear the buffers
        mov ax, 0x0
        mov [num_buffer], ax
        mov [sector], ax

        ; Loop back to "get_sector"
        jmp get_sector

    ; Get times loop
    get_times:
        ; Clear num_buffer
        mov ax, 0x0
        mov [num_buffer], ax
        
        ; Move cursor to line 15, column 0
        mov ah, 02h
        mov dl, 0x0
        mov dh, 0xF
        int 10h

        ; Call "clear_row" from "screen_routines.asm"
        call clear_row

        ; Call "print_times_prompt" from "prompts.asm"
        call print_times_prompt

        ; Call "read_num" from "string_convertors.asm"
        call read_num

        ; Place num_buffer in write_times
        mov ax, [num_buffer]
        mov [write_times], ax

        ; Check if write_times is less than 30001
        ; (if yes: go to "write_to_floppy")
        mov ax, [write_times]
        cmp ax, 0x7531
        jl write_to_floppy

        ; (if no)
        ; Call "print_times_warning" from "prompts.asm"
        call print_times_warning

        ; Clear the buffers
        mov ax, 0x0
        mov [num_buffer], ax
        mov [write_times], ax

        ; Loop back to "get_times"
        jmp get_times

; Write to floppy
write_to_floppy:
    ; Place di at the beginning of floppy_buffer
    mov di, floppy_buffer

    ; Reset ax (used to count len of floppy_buffer)
    mov ax, 0x0

    ; Write to floppy_buffer loop
    repeated_write:
        ; Place si at the beginning of buffer
        mov si, buffer

        ; Get the number times to copy
        mov cx, [write_times]
    
        ; Check if write_times is 0
        ; (if yes: go to "to_floppy")
        cmp cx, 0x0
        je to_floppy
        
        ; (if no)
        ; Decrement write_times by 1
        sub cx, 0x1
        mov [write_times], cx
    
        ; Read char from buffer loop
        char_write:
            ; Place the char from si to di
            mov cx, 0x0
            mov cl, byte [si]
            mov byte [di], cl

            ; Advance si, di
            add si, 0x1
            add di, 0x1

            ; Increment ax
            add ax, 0x1

            ; Check reached end of buffer
            ; (if yes: go to "repeated_write")
            cmp byte [si], 0x0
            je repeated_write

            ; (if no)
            ; Read next char from buffer
            jmp char_write

    ; Write floppy_buffer to floppy
    to_floppy:
        ; Get the number of sectors to write by dividing ax by 512
        ; (ax is storing the length of floppy_buffer)
        mov dx, 0x0
        mov cx, 0x200
        div cx

        ; Check if dx is 0 (dx is remainder of division)
        ; (if yes: go to "dx_zero")
        cmp dx, 0x0
        je dx_zero

        ; (if no)
        ; Increment ax by 1 (ax is number of sectors to write)
        add ax, 0x1

        dx_zero:
            ; Place ax in cx
            mov cx, ax
            mov ax, 0x0

            ; Move bx to the beginning of floppy_buffer
            mov bx, floppy_buffer

            ; Write to floppy loop for each sector
            write_loop:
                ; Write to floppy at track, side, sector
                push cx
                mov ah, 03h
                mov al, 0x1
                mov dl, 0x0
                mov cl, [track]
                mov dh, [side]
                mov ch, [sector]
                int 13h

                ; Increment track
                add cl, 0x1

                ; Check if track is less than 19
                ; (if yes: go to "write_continue")
                cmp cl, 0x13
                jl write_continue

                ; (if no)
                ; Reset track, increment side
                mov cl, 0x1
                add dh, 0x1

                ; Check if side is less than 2
                ; (if yes: go to "write_continue")
                cmp dh, 0x2
                jl write_continue

                ; (if no)
                ; Reset side, increment sector
                mov dh, 0x0
                add ch, 0x1

                ; Save track, side, sector
                write_continue:
                    mov [track], cl
                    mov [side], dh
                    mov [sector], ch

                pop cx
                
                ; Decrement cx (number of sectors to write) by 1
                sub cx, 0x1

                ; Advance bx by 512
                add bx, 0x200

                ; Check if cx is 0
                ; (if no: go to "write_loop")
                cmp cx, 0x0
                jne write_loop

    ; (if yes)
    ; Call "print_write_success" from "prompts.asm"
    call clear_screen

    ; Check if cf is set to cy
    ; (if no: go to "ktf_write_success")
    jnc ktf_write_success

    ; (if yes)
    ; Print the error
    call print_error

    ; Go to "ktf_write_success"
    jmp ktf_write_success

ktf_write_success:
    ; Move si to the beginning of buffer
    mov si, buffer

; Clear buffer loop
clear_buffer:
    ; Place 0x0 at si
    mov byte [si], 0x0

    ; Advance si by 1
    add si, 0x1

    ; Check if si is at the end of buffer
    ; (if no: loop to "clear_buffer")
    cmp si, buffer + 0x100
    jne clear_buffer

    ; (if yes)
    ; Move di to the beginning of floppy_buffer
    mov di, floppy_buffer

; Clear floppy_buffer loop
clear_floppy_buffer:
    ; Place 0x0 at di
    mov byte [di], 0x0
    
    ; Advance di by 1
    add di, 0x1

    ; Check if di is pointing to a null
    ; (if no: loop to "clear_floppy_buffer")
    cmp byte [di], 0x0
    jne clear_floppy_buffer

    ; (if yes)
    ; Go to "menu" from "menu.asm"
    jmp menu

; Handle backspace
ktf_bakcspace:
    ; Get the current cursor position
    mov ah, 03h
    int 10h

    ; Check if the cursor is at the start of buffer
    ; (if yes: loop back to "ktf_input")
    cmp si, buffer
    je ktf_input

    ; (if no)
    ; Decrement si by 1
    sub si, 0x1

    ; Replace the last char with a null
    mov byte [si], 0x0

    ; Check if the cursor is at the start of line
    ; (if yes: go to "ktf_bakcspace_no_newline")
    cmp dl, 0x0
    jz ktf_bakcspace_no_newline

    ; (if no)
    ; Call "remove_last_char" from "screen_routines.asm"
    call remove_last_char

    ; Loop back to "ktf_input"
    jmp ktf_input

; Handle backspace with to previous line
ktf_bakcspace_no_newline:
    ; Call "remove_last_char_line" from "screen_routines.asm"
    call remove_last_char_line

    ; Loop back to "ktf_input"
    jmp ktf_input

; Handle escape key
escape:
    ; Move si to the beginning of buffer
    mov si, buffer

    ; Go to "clear_buffer"
    jmp clear_buffer
