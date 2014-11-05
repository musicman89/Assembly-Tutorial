;*******************************************************************************
;	Print Char.asm - a demonstration of writing a single character to the screen
;						in x86 assembly
;
;       Copyright (c) Davan Etelamaki
;
;	Purpose:
;       To provide an example of using the 0x10 interrupt to write a single
;       	character to the screen
;
;*******************************************************************************
[BITS 16]				;Tell the assembler to compile the code for 16 bit execution
[ORG 0x7c00]			;Tell the assembler that our addresses start at the address 0x7c00

main:					;Declare a label for the start of the program
	mov al, 'H'			;Store the value of the character H in the register AL
	call print			;Call the Print Function
	cli					;Disable Interrupts
	hlt					;Halt the Processor
	
;********************************************************************************
;	print
;	Purpose:
;      To print a character to the screen using the processor interrupt 0x10
;			Prototype:
;				void print(byte character);
;	Entry:
;       Constant Character in Register AL 
;	Exit:
;       None
;	Uses:
;		AX, BX
;	Exceptions:
;		None
;*******************************************************************************
print:
	push bx			;Push the BX register to the stack
	mov bh, 0x0 	;Set the Page
	mov bl, 0x07 	;Set the Text Color
	mov ah, 0x0E	;Instruct the Bios to Write a Character
	int 0x10		;Call the Video Interrupt
	pop bx			;Pop the BX register back from the stack
ret
times 510-($-$$) db 0	;Pad the file to make it 512 Bytes or 1 sector
dw 0xAA55				;Declare the word 0xAA55 signifying the end of the boot sector