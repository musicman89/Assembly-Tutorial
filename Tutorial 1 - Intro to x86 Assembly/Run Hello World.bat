nasm -f bin "Hello World.asm" -o "Hello World.com"
qemu-system-i386 -m 256 -hda "Hello World.com"
pause