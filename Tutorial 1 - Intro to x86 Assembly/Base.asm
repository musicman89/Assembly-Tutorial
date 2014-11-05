;*******************************************************************************
;	base.asm - the base boot sector
;
;       Copyright (c) Davan Etelamaki
;
;	Purpose:
;       To demonstrate a basic bootloader file
;       
;
;*******************************************************************************
[BITS 16]				;Tell the assembler to compile the code for 16 bit execution
[ORG 0x7c00]			;Tell the assembler that our addresses start at the address 0x7c00

main:					;Declare a label for the start of the program
	
	cli					;Disable Interrupts
	hlt					;Halt the Processor
times 510-($-$$) db 0	;Pad the file to make it 512 Bytes or 1 sector
dw 0xAA55				;Declare the word 0xAA55 signifying the end of the boot sector