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
[ORG 0x9000]							;Tell the assembler that our addresses start at the address 0x7c00



%macro Print 1 							;Define a Print Function Macro 
	mov bx, %1 							;Set BX to the address of the first parameter
	call print_string 					;Call the print string function
%endmacro

%macro Input 1 							;Define a Input Function Macro 
	Print %1  							;Display a message to the user
	call get_user_input 				;Accept the user Input
%endmacro

main:									;Declare a label for the start of the program
	Input InputString					;Ask the user for Input
	call print_string 					;Print the user Input
	Print NewLine 						;Go to a new line
	jmp main 							;Repeat
	cli									;Disable Interrupts
	hlt									;Halt the Processor
	
%include "Libraries/Print.asm"
%include "Libraries/KeyboardIO.asm"

InputString db 'Please Input a String and Press Enter: ', 0	;Define the Hello World String
times 4608-($-$$) db 0