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
	push bx
	mov ah, LightGrayOnBlack			;set the text color 
	.loop:
		mov al, [bx]					;load the current byte of the string
		cmp al, 0 						;compare the current byte to 0
		je .return

		cmp al, 10
		je .line_feed

		cmp al, 13
		je .carriage_return

		call print

		add bx, 1 						;advance to the next character
		jmp .loop
	.line_feed:
		add byte [ypos], 1 				;Move down a row on the screen
		add bx, 1 						;advance to the next character
		jmp .loop
	.carriage_return:
		mov byte [xpos], 0     			;Restart at the left
		add bx, 1 						;advance to the next character
		jmp .loop
	.return:
	pop bx
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
	call push_character
	add byte [xpos], 1      		;Move the cursor 1 to the right
	cmp byte [xpos], 80   			;check if the cursor has hit the right 

	jle .return
	mov byte [xpos], 0 				;Move the cursor back to the left
	add byte [ypos], 1 				;Progress the cursor down a line
	cmp byte [ypos], 26 			;Check if the cursor has hit the bottom
	jle .return
	call clear_screen
	.return:
ret

push_character:						;Character Print
	push bx
	mov bx, [VideoMemory]  			;text video memory
	mov es, bx 						;move es to the video memory
									;setting the cursor position
	push ax   						;store the character in ax

									;get the row
	mov ax, word [ypos] 			;get the current yposition
									;we want to multiply the position by 160 
									;(2 bytes per character 80 characters per row)
									;a bitshift is faster than multiplication 
									;(ax * 128 + bx * 32 = ax * 160)
	mov dx, ax 						;we copy ax to dx
	mov cl, 7
	shl ax, cl 						;then shift ax by 7 (ax * 128) 
	mov cl, 5
	shl dx, cl 						;we shift bx by 5 (dx * 32)
	add ax, dx 						;then add ax and dx 

									;get the column
	mov bx, word [xpos]				;get the current xposition
	shl bx, 1

	add bx, ax						;Set the offset location to bx



	pop ax							;restore the character in ax
	mov [es:bx], ax					;push our character to memory
	pop bx
ret

clear_screen:						;Clear Screen
	cld
	mov ah, 0x00 					;set the color to black on black
	mov al, ' '  					;set the character to print to be a space
	mov byte [xpos], 0  			;set the cursor to the left
	mov byte [ypos], 0 				;set the cursor to the top
	.loop:
		call print
		cmp byte [ypos], 25 		;Check if the cursor has hit the bottom
		jle .loop
		mov byte [xpos], 0 			;reset the cursor to the left
		mov byte [ypos], 0 			;reset the cursor to the top
ret

new_line:
	mov byte [xpos], 0 				;Move the cursor back to the left
	add byte [ypos], 1 				;Progress the cursor down a line
	cmp byte [ypos], 26 			;Check if the cursor has hit the bottom
	jle .return
	call clear_screen
	.return:
ret

ypos        dw 0
xpos        dw 0
hexStr      db '0123456789ABCDEF'
hexOutput   db '0000 ', 0  			;register value string
VideoMemory dw 0xb800