; Print the sectors prompt
print_sectors_prompt:
    mov ax, 1301h
    mov bx, 0x7
    mov dl, 0x0
    mov dh, 0xB
    mov bp, sectors_prompt
    mov cx, sectors_prompt_size
    int 10h
    
    ret

; Print the volume prompt
print_volume_prompt:
    mov ax, 1301h
    mov bx, 0x7
    mov dl, 0x0
    mov dh, 0xB
    mov bp, volume_prompt
    mov cx, volume_prompt_size
    int 10h

    ret

; Print the text prompt
print_text_prompt:
    mov ax, 1301h
    mov bx, 0x7
    mov dl, 0x0
    mov dh, 0x2
    mov bp, text_prompt
    mov cx, text_prompt_size
    int 10h
    
    ret

; Print the buffer
print_buffer:
    mov ax, 1301h
    mov bx, 0x7
    mov dl, 0x0
    mov dh, 0x6
    mov bp, buffer
    mov cx, si
    int 10h
    
    ret

; Print the side prompt
print_side_prompt:
    mov ax, 1301h
    mov bx, 0x7
    mov dl, 0x0
    mov dh, 0xC
    mov bp, side_prompt
    mov cx, side_prompt_size
    int 10h
    
    ret

; Print the track prompt
print_track_prompt:
    mov ax, 1301h
    mov bx, 0x7
    mov dl, 0x0
    mov dh, 0xD
    mov bp, track_prompt
    mov cx, track_prompt_size
    int 10h

    ret

; Print the sector prompt
print_sector_prompt:
    mov ax, 1301h
    mov bx, 0x7
    mov dl, 0x0
    mov dh, 0xE
    mov bp, sector_prompt
    mov cx, sector_prompt_size
    int 10h

    ret

; Print sectors amount warning
print_sectors_warning:
    mov ah, 03h
    int 10h

    mov ax, 1301h
    mov bx, 0x7
    mov dl, 0x0
    add dh, 0x1
    mov bp, sectors_warning
    mov cx, sectors_warning_size
    int 10h

    mov ah, 02h
    sub dh, 0x1
    int 10h

    ret

; Print the times prompt
print_times_prompt:
    mov ax, 1301h
    mov bx, 0x7
    mov dl, 0x0
    mov dh, 0xF
    mov bp, times_prompt
    mov cx, times_prompt_size
    int 10h

    ret

; Print the times amount warning
print_times_warning:
    mov ah, 03h
    int 10h

    mov ax, 1301h
    mov bx, 0x7
    mov dl, 0x0
    add dh, 0x1
    mov bp, times_warning
    mov cx, times_warning_size
    int 10h

    mov ah, 02h
    sub dh, 0x1
    int 10h

    ret

; Print the side warning
print_side_warning:
    mov ah, 03h
    int 10h

    mov ax, 1301h
    mov bx, 0x7
    mov dl, 0x0
    add dh, 0x1
    mov bp, side_warning
    mov cx, side_warning_size
    int 10h

    mov ah, 02h
    sub dh, 0x1
    int 10h

    ret

; Print the track warning
print_track_warning:
    mov ah, 03h
    int 10h

    mov ax, 1301h
    mov bx, 0x7
    mov dl, 0x0
    add dh, 0x1
    mov bp, track_warning
    mov cx, track_warning_size
    int 10h

    mov ah, 02h
    sub dh, 0x1
    int 10h

    ret

; Print the sector warning
print_sector_warning:
    mov ah, 03h
    int 10h

    mov ax, 1301h
    mov bx, 0x7
    mov dl, 0x0
    add dh, 0x1
    mov bp, sector_warning
    mov cx, sector_warning_size
    int 10h

    mov ah, 02h
    sub dh, 0x1
    int 10h

    ret

; Print the address prompt
print_address_prompt:
    mov ax, 1301h
    mov bx, 0x7
    mov dl, 0x0
    mov dh, 0xF
    mov bp, address_prompt
    mov cx, address_prompt_size
    int 10h

    ret

section .data
    override_disk_prompt db "Found diskette end. Aborting."
    override_disk_prompt_size equ $ - override_disk_prompt

    text_prompt db "Text: "
    text_prompt_size equ $ - text_prompt
    
    sectors_prompt db "Sectors: "
    sectors_prompt_size equ $ - sectors_prompt

    sectors_warning db "Sectors must be in range 1-2880"
    sectors_warning_size equ $ - sectors_warning

    volume_prompt db "Volume(bytes): "
    volume_prompt_size equ $ - volume_prompt

    side_prompt db "Side(0-1): "
    side_prompt_size equ $ - side_prompt

    side_warning db "Side must be 0 or 1"
    side_warning_size equ $ - side_warning

    track_prompt db "Track(1-18): "
    track_prompt_size equ $ - track_prompt

    track_warning db "Track must be in range 1-18"
    track_warning_size equ $ - track_warning

    sector_prompt db "Sector(0-79): "
    sector_prompt_size equ $ - sector_prompt

    sector_warning db "Sector must be in range 0-79"
    sector_warning_size equ $ - sector_warning

    times_prompt db "Times(1-30000): "
    times_prompt_size equ $ - times_prompt

    times_warning db "Times must be in range 1-30000"
    times_warning_size equ $ - times_warning

    address_prompt db "Address(0-FFFF:0-FFFF): "
    address_prompt_size equ $ - address_prompt


