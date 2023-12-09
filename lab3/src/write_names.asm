write_names:
    ; Write sector 1
    ; to 2041
    mov ah, 03h
    mov dl, 0x0         ; Drive 0
    mov al, 0x1         ; Sector count 1
    mov ch, 0x38        ; Track 56
    mov dh, 0x1         ; Head 1
    mov cl, 0x8         ; Sector 8
    mov bx, sector_1    ; Buffer
    int 13h

    ; to 2070
    mov ah, 03h
    mov dl, 0x0         ; Drive 0
    mov al, 0x1         ; Sector count 1
    mov ch, 0x39        ; Track 57
    mov dh, 0x1         ; Head 1
    mov cl, 0x1         ; Sector 1
    mov bx, sector_1    ; Buffer
    int 13h

    ; Write sector 2
    ; to 2281
    mov ah, 03h
    mov dl, 0x0         ; Drive 0
    mov al, 0x1         ; Sector count 1
    mov ch, 0x3F        ; Track 63
    mov dh, 0x0         ; Head 0
    mov cl, 0xE         ; Sector 14
    mov bx, sector_2    ; Buffer
    int 13h

    ; to 2310
    mov ah, 03h
    mov dl, 0x0         ; Drive 0
    mov al, 0x1         ; Sector count 1
    mov ch, 0x40        ; Track 64
    mov dh, 0x0         ; Head 0
    mov cl, 0x7         ; Sector 7
    mov bx, sector_2    ; Buffer
    int 13h

    ; Write sector 3
    ; to 2311
    mov ah, 03h
    mov dl, 0x0         ; Drive 0
    mov al, 0x1         ; Sector count 1
    mov ch, 0x40        ; Track 64
    mov dh, 0x0         ; Head 0
    mov cl, 0x8         ; Sector 8
    mov bx, sector_3    ; Buffer
    int 13h

    ; to 2340
    mov ah, 03h
    mov dl, 0x0         ; Drive 0
    mov al, 0x1         ; Sector count 1
    mov ch, 0x41        ; Track 65
    mov dh, 0x0         ; Head 0
    mov cl, 0x1         ; Sector 1
    mov bx, sector_3    ; Buffer
    int 13h

    ret

section .data
    sector_1 db "@@@FAF-213 Corneliu Catlabuga###@@@FAF-213 Corneliu Catlabuga###@@@FAF-213 Corneliu Catlabuga###@@@FAF-213 Corneliu Catlabuga###@@@FAF-213 Corneliu Catlabuga###@@@FAF-213 Corneliu Catlabuga###@@@FAF-213 Corneliu Catlabuga###@@@FAF-213 Corneliu Catlabuga###@@@FAF-213 Corneliu Catlabuga###@@@FAF-213 Corneliu Catlabuga###"
    times 0x200 - ($ - sector_1) db 0x0

    sector_2 db "@@@FAF-213 Beatricia Golban###@@@FAF-213 Beatricia Golban###@@@FAF-213 Beatricia Golban###@@@FAF-213 Beatricia Golban###@@@FAF-213 Beatricia Golban###@@@FAF-213 Beatricia Golban###@@@FAF-213 Beatricia Golban###@@@FAF-213 Beatricia Golban###@@@FAF-213 Beatricia Golban###@@@FAF-213 Beatricia Golban###"
    times 0x200 - ($ - sector_2) db 0x0

    sector_3 db "@@@FAF-213 Gabriel Gitlan###@@@FAF-213 Gabriel Gitlan###@@@FAF-213 Gabriel Gitlan###@@@FAF-213 Gabriel Gitlan###@@@FAF-213 Gabriel Gitlan###@@@FAF-213 Gabriel Gitlan###@@@FAF-213 Gabriel Gitlan###@@@FAF-213 Gabriel Gitlan###@@@FAF-213 Gabriel Gitlan###@@@FAF-213 Gabriel Gitlan###"
    times 0x200 - ($ - sector_3) db 0x0
