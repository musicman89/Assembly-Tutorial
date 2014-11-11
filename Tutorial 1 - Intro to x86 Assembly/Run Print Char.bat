nasm -f bin "Print Char.asm" -o "Print Char.com"
qemu-system-i386 -m 256 -hda "Print Char.com"
pause