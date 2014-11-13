nasm -f bin "Bootloader.asm" -o "Bootloader.com"
nasm -f bin "Hello World.asm" -o "Hello World.com"
copy /b "Bootloader.com" + "Hello World.com" "Hello World.bin"
qemu-system-i386 -m 256 -hda "Hello World.bin"
pause