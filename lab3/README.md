# Laboratory Work No. 3 

### Authors (FAF-213)
* Corneliu Catlabuga
* Beatricia Golban
* Gabriel Gitlan

### Compilation Commands
```bash
nasm -f bin -o boot.img boot.asm && 
truncate -s 1474560 boot.img
```

### Project Structure

`boot.asm` - the bootloader
`main.asm` - the initial instructions with all the includes
`src/write_names.asm` - the instructions wirte the strings to the floppy disk drive
`src/screen_routines.asm` - the instructions to process the the characters on screen
`src/menu.asm` - the instructions to print and handle the menu
`src/string_convertors.asm` - the routines to convert int and hex ASCII input to to binary
`src/prompts.asm` - the instructions to print the prompts on screen
`src/keyboard_to_floppy.asm` - the instructions to handle the keyboard input and write it to the floppy
`src/floppy_to_ram.asm` - the instructions to read the floppy and write it to the RAM
`src/ram_to_floppy.asm` - the instructions to read the RAM and write it to the floppy
`src/floppy_params.asm` - reserver the memory for the floppy, RAM parameters as buffers
