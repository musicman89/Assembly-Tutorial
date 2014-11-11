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
[BITS 16]						;Tell the assembler to compile the code for 16 bit execution
[ORG 0x7c00]					;Tell the assembler that our addresses start at the address 0x7c00



%macro Print 1 			;Define a Print Function Macro 
	mov bx, %1 			;Set BX to the address of the first parameter
	call print_string 	;Call the print string function
%endmacro

main:							;Declare a label for the start of the program
	Print HelloWorldString 		;Print the HellO using our Macro
	cli							;Disable Interrupts
	hlt							;Halt the Processor
	
%include "Libraries/Print.asm"

HelloWorldString db 'Hello World', 0	;Define the Hello World String
times 510-($-$$) db 0					;Pad the file to make it 512 Bytes or 1 sector
dw 0xAA55								;Declare the word 0xAA55 signifying the end of the boot sector