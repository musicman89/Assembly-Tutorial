;*******************************************************************************
;	StringFunctions.asm - x86 Assembly String Functions
;						
;
;       Copyright (c) Davan Etelamaki
;
;	Purpose:
;       To provide the functions needed for string comparison and manipulation
;
;*******************************************************************************

;********************************************************************************
;	char_to_lower
;	Purpose:
;      To make sure a character is lower case
;			Prototype:
;				byte char_to_lower(byte character);
;			Algorithm: 
;				byte char_to_lower(byte character){
;					if(character >= 'a'){
;						return character;
;					}
;					else{
;						return character + ('a' - 'A');	
;					}
;				}
;
;	Entry:
;       character in register AL
;	Exit:
;       character in register AL
;	Uses:
;		AL
;	Exceptions:
;		input not a character
;*******************************************************************************
char_to_lower:
    cmp al, 'a'
    jge .IsLower
    add al, 'a'-'A'
    .IsLower:
ret

;********************************************************************************
;	char_to_upper
;	Purpose:
;      To make sure a character is lower case
;			Prototype:
;				byte char_to_upper(byte character);
;			Algorithm: 
;				byte char_to_upper(byte character){
;					if(character <= 'Z'){
;						return character;
;					}
;					else{
;						return character - ('a' - 'A');	
;					}
;				}
;
;	Entry:
;       character in register AL
;	Exit:
;       character in register AL
;	Uses:
;		AL
;	Exceptions:
;		input not a character
;*******************************************************************************
char_to_upper:
    cmp al, 'Z'
    jle .IsUpper
    sub al, 'a'-'A'
    .IsUpper:
ret

;********************************************************************************
;	substr
;	Purpose:
;      To get a substring
;			Prototype:
;				word substr(byte string_address, int length);
;			Algorithm: 
;				word substr(byte string_address, int length){
;					byte buffer_address = StringBuffer;
;					while(length > 0){
;						if(*string_address == 0){
;							break;
;						}
;						*buffer_address = *string_address;
;						string_address++;
;						buffer_address++
;					}
;					return StringBuffer;
;				}
;
;	Entry:
;       string_address in register BX, length in register CX
;	Exit:
;       The address of the substring in register BX
;	Uses:
;		AX, BX, CX, DX
;	Exceptions:
;		None
;*******************************************************************************
substr:
		mov dx, StringBuffer
		and word [bx], 0x0000
        test cx, cx
        jz .done
        .loop:
			mov ax, [bx]
			test al, al 
			jz .done
			
			push bx
			mov bx, dx
			mov byte[bx], al
			
			test ah, ah
			jz .done
			
			mov byte [bx+1], ah
			pop bx
			
			add dx, 2
			add bx, 2
			dec cx
			jnz .loop
        .done:
		inc dx
		mov bx, dx
		mov byte[bx], 0
		mov bx, StringBuffer
        align   4
ret

;********************************************************************************
;	string_compare
;	Purpose:
;      To compare two strings
;			Prototype:
;				word string_compare(byte string_addressA, byte string_addressB);
;			Algorithm: 
;				word string_compare(byte string_addressA, byte string_addressB){
;					while(true){
;						key = get_key();
;						if(*string_addressA > *string_addressB){
;							return 1;
;						}
;						else if(*string_addressA < *string_addressB){
;							return -1;
;						}
;						if(*string_addressA == 0){
;							return 0;
;						}
;						string_addressA++;
;						string_addressB++
;					}
;				}
;
;	Entry:
;       string_addressA in register CX, string_addressB in register DX
;	Exit:
;       AX == 0 if stringA == stringB, AX == -1 if stringA < stringB, AX == 1 if stringA > stringB
;	Uses:
;		AX, BX, CX, DX
;	Exceptions:
;		None
;*******************************************************************************
string_compare:
        .compareword:
            mov     bx, dx
            mov     ax,[bx]

            mov     bx, cx

            cmp     al,[bx]
            jne     .donene
            test    al,al
            jz      .doneeq

            cmp     ah,[bx + 1]
            jne     .donene
            test    ah,ah
            jz      .doneeq

            add     dx, 2
            add     cx, 2
            jmp     .compareword
        align   8

        .doneeq:
            xor     ax,ax	;clear ax
            ret

        align   8
        .donene:
            sbb     ax,ax	;clear all but the sign bit
            or      ax,1	;set the value to 1, ax will equal -1 if stringA < stringB and 1 if stringA > stringB
            ret

        align   16
ret

;********************************************************************************
;	to_lower
;	Purpose:
;      Make a string lower case
;			Prototype:
;				word to_lower(byte string_address);
;			Algorithm: 
;				word to_lower(byte string_address){
;					byte buffer = string_address;
;					while(true){
;						if(*buffer == 0){
;							return string_address;
;						}
;						char_to_lower(*buffer);
;						buffer++
;					}
;				}
;
;	Entry:
;       string_address in register BX
;	Exit:
;       string_address in register BX
;	Uses:
;		AX, BX
;	Exceptions:
;		None
;*******************************************************************************
to_lower:
	push bx
    .loop:
        mov ax, [bx]				;load the current byte of the string
        test al, al 				;check for the end of the string
        jz .return
                 
	    call char_to_lower
        mov [bx], al
        
		mov al, ah					;shift the byte from AH to AL
		test al, al 				;check for the end of the string
        jz .return
        
		call char_to_lower al
        mov [bx + 1], al
		
        add bx, 2 					;advance to the next characters
        jmp .loop
        .return:
		pop bx
ret

;********************************************************************************
;	to_upper
;	Purpose:
;      Make a string upper case
;			Prototype:
;				word to_upper(byte string_address);
;			Algorithm: 
;				word to_upper(byte string_address){
;					byte buffer = string_address;
;					while(true){
;						if(*buffer == 0){
;							return string_address;
;						}
;						char_to_upper(*buffer);
;						buffer++
;					}
;				}
;
;	Entry:
;       string_address in register BX
;	Exit:
;       string_address in register BX
;	Uses:
;		AX, BX
;	Exceptions:
;		None
;*******************************************************************************
to_upper:
	push bx
    .loop:
        mov ax, [bx]				;load the current byte of the string
        test al, al 				;check for the end of the string
        jz .return
                 
	    call char_to_upper
        mov [bx], al
        
		mov al, ah					;shift the byte from AH to AL
		test al, al 				;check for the end of the string
        jz .return
        
		call char_to_upper
        mov [bx + 1], al

        add bx, 2 					;advance to the next characters
        jmp .loop
        .return:
		pop bx
ret

StringBuffer times 255 db 0