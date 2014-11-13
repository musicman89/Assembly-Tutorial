;*******************************************************************************
;	KeyboardIO.asm - x86 Assembly Keyboard IO Functions
;						
;
;       Copyright (c) Davan Etelamaki
;
;	Purpose:
;       To provide the functions needed for keyboard input
;
;*******************************************************************************


;********************************************************************************
;	get_key
;	Purpose:
;      To get a single key press event
;			Prototype:
;				word get_key();
;				
;	Entry:
;       None
;	Exit:
;       byte character in AL and byte key in AH
;	Uses:
;		AX
;	Exceptions:
;		Disk Read Error
;*******************************************************************************
get_key:
    mov ax, 0x01
    int 0x16 
ret

;********************************************************************************
;	get_user_input
;	Purpose:
;      To get a string input from the user
;			Prototype:
;				word get_user_input();
;			Algorithm: 
;				word get_user_input(){
;					byte buffer = InputStringBuffer;
;					byte key;
;					while(true){
;						key = get_key();
;						if(key == 0x1c){
;							print_string(newline);
;							return buffer;
;						}
;						*buffer = key;
;						print(key);
;						buffer++
;					}
;				}
;
;	Entry:
;       None
;	Exit:
;       byte character in AL and byte key in AH
;	Uses:
;		AX
;	Exceptions:
;		Disk Read Error
;*******************************************************************************
get_user_input:
    mov bx, InputStringBuffer 			;Point BX to the string buffer
    and byte [InputStringBuffer], 0x0000 ;Clear the string buffer
    .loop:
        call get_key 					;Get input from the user
        cmp ah, 0x1c 					;Check if key is the enter key
        je .return  					;If it is return

        mov [bx],al						;Set the current location in the sting buffer to the character in al
        call print						;Print the character

        inc bx 							;Increment the position in the string buffer
        jmp .loop
    .return:
    mov byte [bx], 0 					;Null terminate the string	
    mov bx, NewLine						;Put the newline string in bx
	call print_string 					;Print the newline
    mov bx, InputStringBuffer 			;Point BX back to the start of the string buffer

ret

invalid_input:
    mov bx, InvalidInputString
    call print_string
    call get_key
ret

InputStringBuffer times 255 db 0
InvalidInputString db 'The selection you have entered is invalid press any key to continue',13,10,0