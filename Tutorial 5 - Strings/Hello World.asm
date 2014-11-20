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

%macro PrintNewLine 0 					;Define a Macro to move us to a new line
	push bx 							;Push the current value of the BX register to the stack
	Print NewLine 						;Go to a new line
	pop bx 								;Pop the value of the BX register back from the stack
%endmacro

%macro PreservePrint 1  				;Define a Macro that allows us to print to the screen preserving the BX register
	push bx 							;Push the current value of the BX register to the stack
	Print %1 							;Print the address in the first parameter 
	pop bx 								;Pop the value of the BX register back from the stack
%endmacro

main:									;Declare a label for the start of the program
	Input InputString					;Ask the user for Input
	PreservePrint OriginalString 		;Inform the user that this output is the original string
	call print_string 					;Print the user Input
	PrintNewLine
	
	call to_upper 						;Convert the string to upper case
	PreservePrint ToUpperString 		;Inform the user that this output is upper cased
	call print_string 					;Print the user Input
	PrintNewLine
	
	call to_lower 						;Convert the string to lower case
	PreservePrint ToLowerString 		;Inform the user that this output is lower cased
	call print_string 					;Print the user Input
	PrintNewLine
	
	mov cx, 0x05 						;Set the length of the substring to 5
	call substr 						;Take a substring
	PreservePrint SubStringString 		;Inform the user that this output is a substring
	call print_string 					;Print the user Input
	PrintNewLine
	
	mov cx, bx 							;Set stringA to the value of register BX
	mov dx, HelloString 				;Set stringB to our HelloString
	call string_compare 				;Compare stringA and stringB
	test ax, ax 						;Test if they were equal
	jnz main 							;If they were not equal repeat

	Print IsHello 						;If they were equal let us know
	PrintNewLine

	jmp main 							;Repeat
	cli									;Disable Interrupts
	hlt									;Halt the Processor
	
%include "Libraries/Print.asm"
%include "Libraries/KeyboardIO.asm"
%include "Libraries/StringFunctions.asm"

HelloString db 'hello', 0
IsHello db 'You entered a string starting with Hello', 0
OriginalString db 'Original: ', 0
ToUpperString db 'To Upper: ', 0
ToLowerString db 'To Lower: ', 0
SubStringString db 'Substring: ', 0
InputString db 'Please Input a String and Press Enter: ', 0	;Define the Hello World String
times 10240-($-$$) db 0