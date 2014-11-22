;*******************************************************************************
;	Hello World.asm - The classic hello world program written in x86 assembly
;						
;
;       Copyright (c) Davan Etelamaki
;
;	Purpose:
;       To provide an example of using the 0x10 interrupt to write a string
;       	to the screen
;
;*******************************************************************************
[BITS 16]								;Tell the assembler to compile the code for 16 bit execution
[ORG 0x7c00]							;Tell the assembler that our addresses start at the address 0x7c00

main:									;Declare a label for the start of the program
	mov [BOOT_DRIVE], dl
	xor ax, ax							;clear ax
	mov ds, ax							;clear ds
	mov ss, ax							;start the stack at 0
	mov bp, 0x8000						;move the stack pointer to 0x2000 past the start yet 0x1000 before where we will load the remainder of our program
	mov sp, bp 							;since we cannot directly set the address of the stack pointer we push it using the base pointer

	mov bx, 0x9000 						;Set the address we will load the code into
	mov dh, 9 							;Set the number of sectors to load
	mov dl, [BOOT_DRIVE] 				;Set the drive to load the sectors from
	call disk_load 						;Load the sectors
	
	jmp 0x9000 							;Jump to the code we just loaded
	cli									;Disable Interrupts
	hlt									;Halt the Processor
	
%include "Libraries/Print.asm"
%include "Libraries/DiskIO.asm"
BOOT_DRIVE db 0
times 510-($-$$) db 0					;Pad the file to make it 512 Bytes or 1 sector
dw 0xAA55								;Declare the word 0xAA55 signifying the end of the boot sector