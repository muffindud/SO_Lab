[bits 16]
org 0x7C00

mov bx, 0x0
mov es, bx
mov bx, 0x7E00

mov cl, 0x2
mov dh, 0x0
mov ch, 0x0

boot_read_loop:
    mov ah, 0x2
    mov al, 0x1
    int 0x13

    mov al, [boot_sectors_to_read]
    mov ah, [boot_sectors_read]
    cmp al, ah
    je boot_finish_read

    cmp cl, 0x12
    jl boot_read_continue
    mov cl, 0x0
    add dh, 0x1

    cmp dh, 0x2
    jl boot_read_continue
    mov dh, 0x0
    add ch, 0x1

    boot_read_continue:
        add cl, 0x1
        mov ax, 0x0
        mov ah, [boot_sectors_read]
        add ah, 0x1
        mov [boot_sectors_read], ah
        add bx, 0x200

    jmp boot_read_loop

boot_finish_read:
    jmp 0x7E00

; TODO: add disk read error handling

boot_sectors_to_read db 0x20
boot_sectors_read db 0x0

times 510-($-$$) db 0
dw 0xaa55

%include "main.asm"
