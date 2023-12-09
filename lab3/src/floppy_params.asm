section .data
    ; Buffer for read_num and read_address
    num_buffer dw 0x0

    ; Buffers for floppy parameters
    sectors dw 0x0
    write_times dw 0x0
    volume dw 0x0
    side dw 0x0
    track dw 0x0
    sector dw 0x0

    ; Buffers for address
    xxxx dw 0x0
    yyyy dw 0x0

    ; Empty clean row
    clean_row times 0x50 db 0x0

    ; Buffer for text input
    buffer times 0x100 db 0x0

    ; Buffer for floppy write
    floppy_buffer db 0x0
