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
[BITS 16]						;Tell the assembler to compile the code for 16 bit execution
[ORG 0x7c00]					;Tell the assembler that our addresses start at the address 0x7c00

main:							;Declare a label for the start of the program
	mov bx, HelloWorldString	;Set BX to the address of the Hello World String
	call print_string			;Call the print string function
	cli							;Disable Interrupts
	hlt							;Halt the Processor
	
;********************************************************************************
;	print_string
;	Purpose:
;      To print a string to the screen using the print function.
;			Prototype:
;				void print_string(byte string_address);
;			Algorithm:
;				void print_string(byte string_address){
;					while(string_address != 0){
;						print(*string_address);
;						string_address++;
;					}
;				}
;				
;	Entry:
;       Byte String Address in Register BX
;	Exit:
;       None
;	Uses:
;		AX, BX
;	Exceptions:
;		None
;*******************************************************************************
print_string:
	push ax				;Push the AX register to the stack
	push bx				;Push the BX register to the stack
	
	mov al, [bx]		;Move the first byte from the address stored in bx
	or al,al			;Do a binary OR on al to verify it is not zero
	jz .return			;If al is zero then skip the loop and return
	.loop:
		call print		;Print the character in al
		inc bx			;Increase the address in BX by 1
		mov al, [bx]	;Get the next byte from the address stored in bx
		or al,al		;Once again do a binary OR on al to verify it is not zero
		jnz .loop		;If al is not zero go back to the start of the loop
	.return:
	pop bx
	pop ax
ret	

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

HelloWorldString db 'Hello World', 0	;Define the Hello World String
times 510-($-$$) db 0					;Pad the file to make it 512 Bytes or 1 sector
dw 0xAA55								;Declare the word 0xAA55 signifying the end of the boot sector