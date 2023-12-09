ram_to_floppy:
    ; Call "clear_screen" from "screen_routines.asm"
    call clear_screen

    ; Prompt user to enter volume number
    rtf_get_volume:
        ; Clear "num_buffer"
        mov ax, 0x0
        mov [num_buffer], ax
        
        ; Set cursor position
        mov ah, 02h
        mov dl, 0x0
        mov dh, 0x0
        int 10h

        ; Call "clear_row" from "screen_routines.asm"
        call clear_row

        ; Call "print_volume_prompt" from "prompts.asm"
        call print_volume_prompt

        ; Call "read_num" from "string_convertors.asm"
        call read_num

        ; Check if read_num returned escape
        ; (if yes: go to "menu")
        cmp al, 0x1B
        je menu

        ; (if no)
        ; Move "num_buffer" to "volume"
        mov ax, [num_buffer]
        mov [volume], ax

    ; Prompt user to enter side number
    rtf_get_side:
        ; Clear "num_buffer"
        mov ax, 0x0
        mov [num_buffer], ax

        ; Set cursor position
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

        ; Check if read_num returned escape
        ; (if yes: go to "menu")
        cmp al, 0x1B
        je menu

        ; (if no)
        ; Move "num_buffer" to "side"
        mov ax, [num_buffer]
        mov [side], ax
    
        ; Check if "side" is less than 2
        ; (if yes: go to "rtf_get_side")
        mov ax, [side]
        cmp ax, 0x2
        jl rtf_get_track

        ; (if no)
        ; Call "print_side_warning" from "prompts.asm"
        call print_side_warning

        ; Clear the buffers
        mov ax, 0x0
        mov [num_buffer], ax
        mov [side], ax

        ; Go to "rtf_get_side"
        jmp rtf_get_side

    ; Prompt user to enter track number
    rtf_get_track:
        ; Clear "num_buffer"
        mov ax, 0x0
        mov [num_buffer], ax
        
        ; Set cursor position
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

        ; Check if read_num returned escape
        cmp al, 0x1B
        je menu

        ; (if no)
        ; Move "num_buffer" to "track"
        mov ax, [num_buffer]
        mov [track], ax

        ; Check if "track" is greater than 18
        ; (if yes: go to "rtf_track_fault")
        mov ax, [track]
        cmp ax, 0x12
        jg rtf_track_fault

        ; (if no)
        ; Check if "track" is 0
        ; (if yes: go to "rtf_track_fault")
        cmp ax, 0x0
        je rtf_track_fault

        ; (if no)
        ; Go to "rtf_get_sector"
        jmp rtf_get_sector

        ; Print warning message
        rtf_track_fault:
            ; Call "print_track_warning" from "prompts.asm"
            call print_track_warning

            ; Clear the buffers
            mov ax, 0x0
            mov [num_buffer], ax
            mov [track], ax

            ; Go to "rtf_get_track"
            jmp rtf_get_track

    ; Prompt user to enter sector number
    rtf_get_sector:
        mov ax, 0x0
        mov [num_buffer], ax
        
        ; Set cursor position
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

        ; Check if read_num returned escape
        cmp al, 0x1B
        je menu
        
        ; (if no)
        ; Move "num_buffer" to "sector"
        mov ax, [num_buffer]
        mov [sector], ax

        ; Check if "sector" is less than 80
        ; (if yes: go to "rtf_get_address_1")
        mov ax, [sector]
        cmp ax, 0x50
        jl rft_get_address_1

        ; (if no)
        ; Call "print_sector_warning" from "prompts.asm"
        call print_sector_warning

        ; Clear the buffers
        mov ax, 0x0
        mov [num_buffer], ax
        mov [sector], ax

        ; Go to "rtf_get_sector"
        jmp rtf_get_sector
    
    ; Prompt user to enter address
    rft_get_address_1:
        ; Clear "num_buffer"
        mov ax, 0x0
        mov [num_buffer], ax
        
        ; Set cursor position
        mov ah, 02h
        mov dl, 0x0
        mov dh, 0xF
        int 10h

        ; Call "clear_row" from "screen_routines.asm"
        call clear_row

        ; Call "print_address_prompt" from "prompts.asm"
        call print_address_prompt

        ; Call "read_address" from "string_convertors.asm"
        call read_address

        ; Check if read_address returned escape
        ; (if yes: go to "menu")
        cmp al, 0x1B
        je menu
        
        ; (if no)
        ; Move "num_buffer" to "xxxx"
        mov ax, [num_buffer]
        mov [xxxx], ax

    ; Get the second part of the address
    rft_get_address_2:
        ; Clear "num_buffer"
        mov ax, 0x0
        mov [num_buffer], ax

        ; Print ":"
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
        ; Move "num_buffer" to "yyyy"
        mov ax, [num_buffer]
        mov [yyyy], ax

; Read form RAM and write to floppy
rtf_read_ram:
    ; Call "clear_screen" from "screen_routines.asm"
    call clear_screen

    ; Print to screen
    mov ax, 1301h
    mov bl, 0x7
    mov cx, [volume]
    mov bp, [xxxx]
    mov es, bp
    mov bp, [yyyy]
    int 10h

    ; Move the data to the floppy
    mov ah, 03h
    mov cl, [track]
    mov dh, [side]
    mov ch, [sector]
    mov bx, [xxxx]
    mov es, bx
    mov bx, [yyyy]
    int 13h

    ; Wait for key press
    push ax
    mov ah, 00h
    int 16h
    pop ax

    ; Call "clear_screen" from "screen_routines.asm"
    call clear_screen

    ; Check if the read was successful
    ; (if yes: go to "rtf_read_success")
    jnc rtf_write_success

    ; (if no)
    ; Call "print_error" from "screen_routines.asm"
    call print_error

rtf_write_success:
    ; Go to "menu" in "menu.asm"
    jmp menu
