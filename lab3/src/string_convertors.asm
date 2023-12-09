; Convert ASCII string to integer
read_num:
    ; Read a character
    mov ah, 00h
    int 16h

    ; Check if the key is escape
    ; (if yes: go to "read_num_return")
    cmp al, 0x1B
    je read_num_return

    ; (if no)
    ; Check if the key is enter
    ; (if yes: go to "read_num_return")
    cmp al, 0x0D
    je read_num_return

    ; (if no)
    ; Check if the key is backspace
    ; (if yes: go to "read_num_backspace")
    cmp al, 0x08
    je read_num_backspace

    ; Check if the key is in range 0-9
    ; (if no: loop back to "read_num")
    cmp al, 0x30
    jl read_num
    cmp al, 0x39
    jg read_num

    ; (if yes)
    ; Subtract 0x30 from the ASCII value
    sub al, 0x30

    ; Place number in CX
    mov cl, al

    ; Move the number in AX
    mov ax, [num_buffer]

    ; Check if the number is 3276
    ; (if yes go to "limit_num")
    cmp ax, 0xCCC
    je limit_num ; (accept between 0 and 7)
    
    ; (if no)
    ; Check if the number is less than 3276
    ; (if yes: go to "accept_num")
    cmp ax, 0xCCC
    jl accept_num

    ; (if no)
    ; Loop back to "read_num"
    jmp read_num

    accept_num:
        ; Place the number in AX
        ; Multiply the number by 10
        mov ax, [num_buffer]
        mov dx, 0xA
        mul dx

        ; Add to ax the number in CX
        add ax, cx

        ; Store to num_buffer the number in AX
        mov [num_buffer], ax

        ; Print the number
        mov ah, 0Eh
        mov al, cl
        add al, 0x30
        int 10h

        ; Loop back to "read_num"
        jmp read_num

    ; Return from the function
    read_num_return:
        ret
    
    ; Handle backspace
    read_num_backspace:
        ; Check if the buffer is empty
        ; (if yes: loop back to "read_num")
        mov dx, 0x0
        mov ax, [num_buffer]
        cmp ax, 0x0
        je read_num

        ; (if no)
        ; Divide the number by 10
        mov cx, 0xA
        div cx

        ; Store the number in AX to num_buffer
        mov [num_buffer], ax
        
        ; Remove the last character from the screen
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

        ; Loop back to "read_num"
        jmp read_num

    ; Limit the number to 3276
    limit_num:
        ; Check if the number is greater than 7
        ; (if yes: loop back to "read_num")
        cmp cl, 0x7
        jg read_num

        ; (if no)
        ; Go to "accept_num"
        jmp accept_num

; Convert ASCII string to hexadecimal
read_address:
    ; Read a character
    mov ah, 00h
    int 16h
    
    ; Check if the key is escape
    ; (if yes: go to "read_address_return")
    cmp al, 0x1B
    je read_address_return

    ; (if no)
    ; Check if the key is enter
    ; (if yes: go to "read_address_return")
    cmp al, 0x0D
    je read_address_return

    ; (if no)
    ; Check if the key is backspace
    ; (if yes: go to "read_address_backspace")
    cmp al, 0x08
    je read_address_backspace

    ; (if no)
    ; Check if the key lower than 0x30
    ; (if yes: loop back to "read_address")
    cmp al, 0x30
    jl read_address

    ; (if no)
    ; Check if the less than 0x3A
    ; (if yes: go to "handle_number")
    cmp al, 0x3A
    jl handle_number

    ; (if no)
    ; Check if the key is less than 0x41
    ; (if yes: loop back to "read_address")
    cmp al, 0x41
    jl read_address

    ; (if no)
    ; Check if the key is less than 0x47
    ; (if yes: go to "handle_uppercase")
    cmp al, 0x47
    jl handle_uppercase

    ; (if no)
    ; Check if the key is less than 0x61
    ; (if yes: loop back to "read_address")
    cmp al, 0x61
    jl read_address

    ; (if no)
    ; Check if the key is less than 0x67
    ; (if yes: go to "handle_lowercase")
    cmp al, 0x67
    jl handle_lowercase

    ; (if no)
    ; Loop back to "read_address"
    jmp read_address

    ; Handle the character as a number
    handle_number:
        ; Subtract 0x30 from the ASCII value
        sub al, 0x30

        ; Got to "handle_value"
        jmp handle_value

    ; Handle the character as an uppercase letter
    handle_uppercase:
        ; Subtract 0x37 from the ASCII value
        sub al, 0x37

        ; Got to "handle_value"
        jmp handle_value

    ; Handle the character as a lowercase letter
    handle_lowercase:
        ; Subtract 0x57 from the ASCII value
        sub al, 0x57

        ; Got to "handle_value"
        jmp handle_value

    ; Handle the character as a value
    handle_value:
        ; Place the value in CL
        mov cl, al

        ; Move the buffer in AX
        mov ax, [num_buffer]

        ; Check if the buffer is above 0xFFF
        ; (if yes: loop back to "read_address")
        cmp ax, 0xFFF
        ja read_address

        ; (if no)
        ; Multiply the buffer by 0x10
        mov dx, 0x10
        mul dx

        ; Add the value to the buffer
        add ax, cx
        mov [num_buffer], ax

        ; Print the value
        mov ah, 0Eh
        mov al, cl
        cmp cx, 0x9
        jg print_letter
            ; Print as number
            add al, 0x30
            int 10h

            ; Loop back to "read_address"
            jmp read_address

        print_letter:
            ; Print as letter
            add al, 0x37
            int 10h

            ; Loop back to "read_address"
            jmp read_address

    ; Return from the function
    read_address_return:
        ret
    
    ; Handle backspace
    read_address_backspace:
        ; Check if the buffer is empty
        ; (if yes: loop back to "read_address")
        mov dx, 0x0
        mov ax, [num_buffer]
        cmp ax, 0x0
        je read_address

        ; (if no)
        ; Divide the num_buffer by 0x10
        mov cx, 0x10
        div cx
        mov [num_buffer], ax
        
        ; Remove the last character from the screen
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

        ; Loop back to "read_address"
        jmp read_address
