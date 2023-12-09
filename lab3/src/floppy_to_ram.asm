floppy_to_ram:
    ; Call "clear_screen" from "screen_routines.asm"
    call clear_screen

    ; Get the number of sectors to read
    ftr_get_sectors:
        ; Clear the buffer
        mov ax, 0x0
        mov [num_buffer], ax

        ; Move the cursor to the top left corner
        mov ah, 02h
        mov dl, 0x0
        mov dh, 0xB
        int 10h

        ; Call "clear_row" from "screen_routines.asm"
        call clear_row

        ; Call "print_sectors_prompt" from "promts.asm"
        call print_sectors_prompt

        ; Call "read_num" from "string_convertors.asm"
        call read_num

        ; Check if escape was pressed
        ; (if yes: go to "menu")
        cmp al, 0x1B
        je menu
        
        ; (if no)
        ; Move the number from the buffer to "sectors"
        mov ax, [num_buffer]
        mov [sectors], ax

        mov ax, [sectors]
        cmp ax, 0x0
        je sectors_fault

        ; Check if sectors is less than 2881
        ; (if yes: go to "ftr_get_side")
        cmp ax, 0xB40
        jg sectors_fault

        ; (if no)
        ; Go to "ftr_get_side"
        jmp ftr_get_side

        ; Print a warning message
        sectors_fault:
            ; Call "print_sectors_warning" from "propts.asm"
            call print_sectors_warning

            ; Reset the buffers
            mov ax, 0x0
            mov [num_buffer], ax
            mov [sectors], ax

            ; Go to "ftr_get_sectors"
            jmp ftr_get_sectors

    ; Prompt the user for side
    ftr_get_side:
        ; Clear the buffer
        mov ax, 0x0
        mov [num_buffer], ax

        ; Move the cursor to row 12, column 0
        mov ah, 02h
        mov dl, 0x0
        mov dh, 0xC
        int 10h

        ; Call "clear_row" from "screen_routines.asm"
        call clear_row

        ; Call "print_side_prompt" from "promts.asm"
        call print_side_prompt

        ; Call "read_num" from "string_convertors.asm"
        call read_num

        ; Check if read_num returned escape
        ; (if yes: go to "menu")
        cmp al, 0x1B
        je menu
        
        ; (if no)
        ; Move the number from the buffer to "side"
        mov ax, [num_buffer]
        mov [side], ax
    
        ; Check if side is less than 2
        ; (if yes: go to "ftr_get_track")
        mov ax, [side]
        cmp ax, 0x2
        jl ftr_get_track

        ; (if no)
        ; Call "print_side_warning" from "screen_routines.asm"
        call print_side_warning

        ; Reset the buffers
        mov ax, 0x0
        mov [num_buffer], ax
        mov [side], ax

        ; Go to "ftr_get_side"
        jmp ftr_get_side

    ; Prompt the user for track
    ftr_get_track:
        ; Clear the buffer
        mov ax, 0x0
        mov [num_buffer], ax
        
        ; Move the cursor to row 13, column 0
        mov ah, 02h
        mov dl, 0x0
        mov dh, 0xD
        int 10h

        ; Call "clear_row" from "screen_routines.asm"
        call clear_row

        ; Call "print_track_prompt" from "promts.asm"
        call print_track_prompt

        ; Call "read_num" from "string_convertors.asm"
        call read_num

        ; Check if read_num returned escape
        ; (if yes: go to "menu")
        cmp al, 0x1B
        je menu
        
        ; (if no)
        ; Move the number from the buffer to "track"
        mov ax, [num_buffer]
        mov [track], ax

        ; Check if track is greater than 19
        ; (if yes: go to "ftr_track_fault")
        mov ax, [track]
        cmp ax, 0x12
        jg ftr_track_fault

        ; (if no)
        ; Check if track is 0
        ; (if yes: go to "ftr_track_fault")
        cmp ax, 0x0
        je ftr_track_fault

        ; (if no)
        ; Go to "ftr_get_sector"
        jmp ftr_get_sector

        ; Print a warning message
        ftr_track_fault:
            ; Call "print_track_warning" from "screen_routines.asm"
            call print_track_warning

            ; Reset the buffers
            mov ax, 0x0
            mov [num_buffer], ax
            mov [track], ax

            ; Go to "ftr_get_track"
            jmp ftr_get_track
    
    ; Prompt the user for sector
    ftr_get_sector:
        ; Clear the buffer
        mov ax, 0x0
        mov [num_buffer], ax
        
        ; Move the cursor to row 14, column 0
        mov ah, 02h
        mov dl, 0x0
        mov dh, 0xE
        int 10h

        ; Call "clear_row" from "screen_routines.asm"
        call clear_row

        ; Call "print_sector_prompt" from "promts.asm"
        call print_sector_prompt

        ; Call "read_num" from "string_convertors.asm"
        call read_num

        ; Check if read_num returned escape
        ; (if yes: go to "menu")
        cmp al, 0x1B
        je menu
        
        ; (if no)
        ; Move the number from the buffer to "sector"
        mov ax, [num_buffer]
        mov [sector], ax

        ; Check if sector is less than 80
        ; (if yes: go to "ftr_get_address_1")
        mov ax, [sector]
        cmp ax, 0x50
        jl ftr_get_address_1

        ; (if no)
        ; Call "print_sector_warning" from "screen_routines.asm"
        call print_sector_warning

        ; Reset the buffers
        mov ax, 0x0
        mov [num_buffer], ax
        mov [sector], ax

        ; Go to "ftr_get_sector"
        jmp ftr_get_sector

    ; Read the address
    ftr_get_address_1:
        ; Clear the buffer
        mov ax, 0x0
        mov [num_buffer], ax
        
        ; Move the cursor to row 15, column 0
        mov ah, 02h
        mov dl, 0x0
        mov dh, 0xF
        int 10h

        ; Call "clear_row" from "screen_routines.asm"
        call clear_row

        ; Call "print_address_prompt" from "promts.asm"
        call print_address_prompt

        ; Call "read_address" from "string_convertors.asm"
        call read_address

        ; Check if read_address returned escape
        ; (if yes: go to "menu")
        cmp al, 0x1B
        je menu
        
        ; (if no)
        ; Move the number from the buffer to "xxxx"
        mov ax, [num_buffer]
        mov [xxxx], ax
    
    ; Read the second part of the address
    ftr_get_address_2:
        ; Clear the buffer
        mov ax, 0x0
        mov [num_buffer], ax

        ; Print to screen ":"
        mov ah, 0Eh
        mov al, ':'
        int 10h

        ; Call "read_address" from "string_convertors.asm"
        call read_address

        ; Check if read_address returned escape
        ; (if yes: go to "menu")
        cmp al, 0x1B
        je menu
        
        ; (if no)
        ; Move the number from the buffer to "yyyy"
        mov ax, [num_buffer]
        mov [yyyy], ax

; Read the floppy
ftr_read_floppy:
    ; Read the floppy at the specified address
    mov ah, 02h
    mov dl, 0x0
    mov al, [sectors]
    mov cl, [track]
    mov dh, [side]
    mov ch, [sector]

    mov bx, [xxxx]
    mov es, bx
    mov bx, [yyyy]

    int 13h

    ; Call "clear_screen" from "screen_routines.asm"
    call clear_screen

    ; Check if the read was successful
    ; (if yes: go to "ftr_read_success")
    jnc ftr_read_success

    ; (if no)
    ; Call "print_error" from "screen_routines.asm"
    call print_error

; Print the floppy to the screen
ftr_read_success:
    mov dx, [sectors]
    
    ; Move pointer to the start of the buffer
    mov bp, [xxxx]
    mov es, bp
    mov bp, [yyyy]

    ; Print the floppy to the screen
    ftr_print_loop:
        push dx
        call clear_screen
        mov ax, 1301h
        mov bx, 0x7
        mov cx, 0x200
        mov dh, 0x0
        mov dl, 0x0
        int 10h
        pop dx

        sub dx, 0x1
        add bp, 0x200

        ; Wait for a key to be pressed
        mov ah, 00h
        int 16h

        ; Check if all sectors have been printed
        ; (if no: go to "ftr_print_loop")
        cmp dx, 0x0
        jne ftr_print_loop

    ; (if yes)
    ; Go to "menu" in "menu.asm"
    jmp menu
