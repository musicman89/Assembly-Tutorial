;*******************************************************************************
;	DiskIO.asm - x86 Assembly Disk IO Functions
;						
;
;       Copyright (c) Davan Etelamaki
;
;	Purpose:
;       To provide the functions needed for disk access
;
;*******************************************************************************


;********************************************************************************
;	disk_load
;	Purpose:
;      To load sectors from a disk
;			Prototype:
;				void disk_load(byte address, byte sectors, byte drive);
;			Algorithm:
;				void print_string(byte string_address){
;					while(string_address != 0){
;						print(*string_address);
;						string_address++;
;					}
;				}
;				
;	Entry:
;       Byte address in register BX, Byte sectors in register DH, Byte drive in register DL
;	Exit:
;       None
;	Uses:
;		BX, DX
;	Exceptions:
;		Disk Read Error
;*******************************************************************************
disk_load:
	push ax
	push dx
	mov ah, 0x02 				;BIOS read sector function
	mov al, dh					;Read DH Sectors
	mov ch, 0x00 				;Cylinder 0
	mov dh, 0x00 				;Head 0
	mov cl, 0x02			    ;Sector 2
	
	int 0x13					;BIOS interrupt
	jc disk_error				;If there was an error flagged by the BIOS display an error message

	pop dx 						;Pop DX from the stack
	cmp dh, al 					;Compare the number of sectors loaded to the number requested
	jne disk_error 				;If they do not match there was a disk read error
	pop ax
ret

disk_error:
	mov bx, DISK_ERROR_MSG
	call print_string
	cli
	hlt

DISK_ERROR_MSG db " Disk read error !", 13, 10, 0
