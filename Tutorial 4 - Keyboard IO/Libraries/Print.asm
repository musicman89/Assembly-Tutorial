;*******************************************************************************
;	Print.asm - x86 Assembly Print Functions
;						
;
;       Copyright (c) Davan Etelamaki
;
;	Purpose:
;       To provide the functions needed to print an output to the screen
;
;*******************************************************************************

%define LightGrayOnBlack 0x07

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
	push bx						;Push the BX register to the stack
	mov bh, 0x0 				;Set the Page
	mov bl, LightGrayOnBlack 	;Set the Text Color
	mov ah, 0x0E				;Instruct the Bios to Write a Character
	int 0x10					;Call the Video Interrupt
	pop bx						;Pop the BX register back from the stack
ret

NewLine db 13,10,0