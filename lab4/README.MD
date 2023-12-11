# Laboratory Work No. 4

### Author:
Name: __Corneliu Catlabuga__
Group: __FAF-213__

### Theoretical Considerations:

* The allocated sectors are in the limit 2041-2070 

Sector: 56 (0x38) 

Track: 8  (0x08)

Head: 1  (0x01)

__to__

Sector: 57 (0x39)

Track: 1 (0x01)

Head: 1 (0x01)

* The chosen task: Dec-to-Hex and Hex-to-Dec convertor

### Compilation Commands:

```bash
nasm -f bin -o boot.bin boot.asm &&
nasm -f bin -o menu.bin menu.asm &&
truncate boot.bin -s 1044992 && 
cat boot.bin menu.bin > boot.img &&
truncate boot.img -s 1474560 && 
rm boot.bin menu.bin
```
