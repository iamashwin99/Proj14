#make_bin#

; BIN is plain binary format similar to .com format, but not limited to 1 segment;
; All values between # are directives, these values are saved into a separate .binf file.
; Before loading .bin file emulator reads .binf file with the same file name.

; All directives are optional, if you don't need them, delete them.

; set loading address, .bin file will be loaded to this address:
#LOAD_SEGMENT=FFFFh#
#LOAD_OFFSET=0000h#

; set entry point:
#CS=0000h#	; same as loading segment
#IP=0000h#	; same as loading offset

; set segment registers
#DS=0000h#	; same as loading segment
#ES=0000h#	; same as loading segment

; set stack
#SS=0000h#	; same as loading segment
#SP=FFFEh#	; set to top of loading segment

; set general registers (optional)
#AX=0000h#
#BX=0000h#
#CX=0000h#
#DX=0000h#
#SI=0000h#
#DI=0000h#
#BP=0000h#

; add your code here
           JMP st1
db 5 dup(0)

;IVT entry for NMI (INT 02h)
DW Nmi_24hrtimer
DW 0000

DB 500 dup(0)

;IVT entry for 80h
DW Switch_intR
DW 0000
DB 508 dup(0)
st1:	CLI

;Initialising DS,ES,SS to start of RAM
	MOV AX,0100h ;leaving some space empty
	MOV DS,AX
	MOV ES,AX
	MOV SS,AX
	MOV SP,0FFFEh
	
;Initialising 8255
	STI
	;8255_1
	MOV AL,88h		;PORT A,B,CLower give output	PORT CUpper takes Input
	OUT 06h,AL 
	;8255_2
	MOV AL,89h		;PORT A,B,CLower give output	PORT CUpper takes Input
	OUT 0Eh,AL
	
;Initialising Timers
	MOV AL,36h ;Control Word for 8253-1 C0
	OUT 16h,AL
	
	MOV AL,56h ;Control Word for 8253-1 C1
	OUT 16h,AL
	
	MOV AL,94h ;Control Word for 8253-1 C2
	OUT 16h,AL
	
	MOV AL,34h ;Control Word for 8253-2 C0
	OUT 1Eh,AL
	
	MOV AL,5ah ;Control Word for 8253-2 C1
	OUT 1Eh,AL
	
	MOV AL,94h ;Control Word for 8253-2 C2
	OUT 1Eh,AL
	
	
	MOV AL,050h ;Load count lsb for 8253-1 C0
	OUT 10h,AL
	
	MOV AL,0c3h ;Load count msb for 8253-1 C0
	OUT 10h,AL
	
	MOV AL,64h ;Load count lsb for 8253-1 C1
	OUT 12h,AL
	
	MOV AL,1eh ;Load count lsb for 8253-1 C2 (1 Minute Timer)
	OUT 14h,AL
	
	MOV AL,40h ;Load count lsb for 8253-2 C0 (1 Min counter for 24 hr generation)
	OUT 18h,AL
	
	MOV AL,3h ;load count for 8253-2 C1 (1 hr counter for 24 hr generation)
	OUT 1Ah,AL
	
	MOV AL,2h ;Load count lsb for 8253-2 C2
	OUT 1Ch,AL
	
	
	MOV AL,00h ;default low output from 8255-2 upper port C
	OUT 0Ch,AL
	
;Initialising LCD
	CALL DELAY_20ms
	MOV AL,04h ;PB2 bit is 1 to make E on LCD 1
	OUT 0Ah,AL ;;;;;;;;;;;;;
	
	CALL DELAY_20ms
	MOV AL,00h ;Make E on LCD 0
	OUT 0Ah,AL ;;;;;;;;;;;;
	
	MOV AL,38h ;8-bit interface + Two Lines + 5x7 dots
	OUT 08h,AL
	
	MOV AL,04h ;PB2 bit is 1 to make E on LCD 1
	OUT 0Ah,AL ;;;;;;;;;;;;;
	
	CALL DELAY_20ms
	MOV AL,00h ;Make E on LCD 0
	OUT 0Ah,AL ;;;;;;;;;;;;
	
	CALL DELAY_20ms
	MOV AL,0Ch ;Display On
	OUT 08h,AL
	
	MOV AL,04h ;PB2 bit is 1 to make E on LCD 1
	OUT 0Ah,AL ;;;;;;;;;;;;;
	
	CALL DELAY_20ms
	MOV AL,00h ;Make E on LCD 0
	OUT 0Ah,AL ;;;;;;;;;;;;
	
	MOV AL,06h ;Increment
	OUT 08h,AL
	
	CALL DELAY_20ms
	MOV AL,04h ;PB2 bit is 1 to make E on LCD 1
	OUT 0Ah,AL ;;;;;;;;;;;;;
	
	CALL DELAY_20ms
	MOV AL,00h ;Make E on LCD 0
	OUT 0Ah,AL ;;;;;;;;;;;;
	
	MOV AL,4Ch ;Set CG RAM Adress
	OUT 08h,AL
	
	CALL DELAY_20ms
;End of LCD Initialisation

;Setting default master password as 1234567890123456
	mov si,0000h
	mov al,0EEh	;Hex code for 1
	mov [si],al
	mov al,0EDh	;..2
	mov [si+1],al
	mov al,0EBh	;..3
	mov [si+2],al
	mov al,0DEh	;..4
	mov [si+3],al
	mov al,0DDh	;..5
	mov [si+4],al
	mov al,0DBh	;..6
	mov [si+5],al
	mov al,0BEh	;..7
	mov [si+6],al
	mov al,0BDh	;..8
	mov [si+7],al
	mov al,0BBh	;..9
	mov [si+8],al
	mov al,0B7h	;..0
	mov [si+9],al	
	mov al,0EEh	;..1
	mov [si+0ah],al
	mov al,0EDh	;..2
	mov [si+0bh],al
	mov al,0EBh	;..3
	mov [si+0ch],al
	mov al,0DEh	;..4
	mov [si+0dh],al
	mov al,0DDh	;..5
	mov [si+0eh],al
	mov al,0DBh	;..6

;Setting default alarm password as 12345678901234
	mov [si+0fh],al
	add si,000fh
	inc si
	mov al,0EEh	;Hex code for 1
	mov [si],al
	mov al,0EDh	;..2
	mov [si+1],al
	mov al,0EBh	;..3
	mov [si+2],al
	mov al,0DEh	;..4
	mov [si+3],al
	mov al,0DDh	;..5
	mov [si+4],al
	mov al,0DBh	;..6
	mov [si+5],al
	mov al,0BEh	;..7
	mov [si+6],al
	mov al,0BDh	;..8
	mov [si+7],al
	mov al,0BBh	;..9
	mov [si+8],al
	mov al,0B7h	;..0
	mov [si+9],al	
	mov al,0EEh	;..1
	mov [si+0ah],al
	mov al,0EDh	;..2
	mov [si+0bh],al
	mov al,0EBh	;..3
	mov [si+0ch],al
	mov al,0DEh	;..4
	mov [si+0dh],al
	add si,000dh
	inc si

	MOV AL,0FFh ;Initialise Port A of 8255-1
	OUT 00h,AL;;;;;;;;;;;;;
	
start:	CALL clear_displayLCD
		CALL displayLCD_welcome
		MOV BP,00h 	;Initialise
		CALL keypad_input
		CMP AL,7Eh
		JZ master_mode
		JMP start
		
x6:	CALL clear_displayLCD
	CALL displayLCD_welcome
	CALL keypad_input
	CMP AL,7Dh ;O key
	JZ User_mode
	JMP x6
		
master_mode:	CALL entermaster
				MOV BP,0ABCDh
				CMP AX,0ABCDh 
				JNZ x6
				
x8:	CALL keypad_input
	CMP AL,7Bh ;A key
	JZ Alarm_mode
	JNZ x8
	
Alarm_mode:	CALL enteralarm
			CMP DH,6h ;Alarm due to wrong Master password
			JZ start
			
			CMP DH,1h ;Alarm due to wrong User password
			JZ x6
			JMP x70
			
User_mode:	CALL entu
			CMP AX,0ABCDh
			JZ x8
			JNZ x6
			
x70:	stop:	JMP stop


		
	
;________________SUBROUTINES________________;

	DELAY_20ms proc
		MOV CH,5h
		x4: NOP
			NOP
			DEC CH
			JNZ x4
		RET
	DELAY_20ms ENDP
	
	DELAY_max proc
		MOV CX,0FFFFh
		x16:	NOP
			NOP
			DEC CX
			JNZ x16
		RET
	DELAY_max ENDP
	
	clear_displayLCD proc
		MOV AL,00h
		OUT 0Ah,AL ;;;;;;;;;;;
		
		CALL DELAY_20ms
		MOV AL,01h ;Clears Display
		OUT 08h,AL ;;;;;;;;;;;;;;
		
		CALL DELAY_20ms
		MOV AL,04h
		OUT 0Ah,AL ;;;;;;;;;;;
		
		CALL DELAY_20ms
		MOV AL,00h
		OUT 0Ah,AL ;;;;;;;;;;;
		
		RET
	clear_displayLCD endp
		
	displayLCD_welcome proc 
		MOV AL,0A0h 
		OUT 08h,AL ;;;;;;;;;;;;;;;
		CALL DELAY_20ms 
		MOV AL,05h 
		OUT 0Ah,AL ;;;;;;;;;;;;
		CALL DELAY_20ms
		MOV AL,01h 
		OUT 0Ah,AL ;Prints Space ;;;;;;;;;;;;;;
		
		MOV AL,57h
		OUT 08h,AL ;;;;;;;;;;;;;;
		CALL DELAY_20ms
		MOV AL,05h
		OUT 0Ah,AL ;;;;;;;;;;;;
		CALL DELAY_20ms
		MOV AL,01h 
		OUT 0Ah,AL ;Prints W ;;;;;;;;;;;;;;;
		
		MOV AL,45h
		OUT 08h,AL ;;;;;;;;;;;;;;
		CALL DELAY_20ms
		MOV AL,05h
		OUT 0Ah,AL ;;;;;;;;;;;;
		CALL DELAY_20ms
		MOV AL,01h 
		OUT 0Ah,AL ;Prints E ;;;;;;;;;;;;;;;
		
		MOV AL,4Ch
		OUT 08h,AL ;;;;;;;;;;;;;;
		CALL DELAY_20ms
		MOV AL,05h
		OUT 0Ah,AL ;;;;;;;;;;;;
		CALL DELAY_20ms
		MOV AL,01h 
		OUT 0Ah,AL ;Prints L ;;;;;;;;;;;;;;;
		
		MOV AL,43h
		OUT 08h,AL ;;;;;;;;;;;;;;
		CALL DELAY_20ms
		MOV AL,05h
		OUT 0Ah,AL ;;;;;;;;;;;;
		CALL DELAY_20ms
		MOV AL,01h 
		OUT 0Ah,AL ;Prints C ;;;;;;;;;;;;;;;
		
		MOV AL,4Fh
		OUT 08h,AL ;;;;;;;;;;;;;;
		CALL DELAY_20ms
		MOV AL,05h
		OUT 0Ah,AL ;;;;;;;;;;;;
		CALL DELAY_20ms
		MOV AL,01h 
		OUT 0Ah,AL ;Prints O ;;;;;;;;;;;;;;;
		
		MOV AL,4Dh
		OUT 08h,AL ;;;;;;;;;;;;;;
		CALL DELAY_20ms
		MOV AL,05h
		OUT 0Ah,AL ;;;;;;;;;;;;
		CALL DELAY_20ms
		MOV AL,01h 
		OUT 0Ah,AL ;Prints M ;;;;;;;;;;;;;;;
		
		MOV AL,45h
		OUT 08h,AL ;;;;;;;;;;;;;;
		CALL DELAY_20ms
		MOV AL,05h
		OUT 0Ah,AL ;;;;;;;;;;;;
		CALL DELAY_20ms
		MOV AL,01h 
		OUT 0Ah,AL ;Prints E ;;;;;;;;;;;;;;;
		
		RET
	displayLCD_welcome ENDP
	
	displayLCD_update proc
		mov al,55h
		out 08h,al
		call DELAY_20ms
		mov al,05h
		out 0Ah,al
		call DELAY_20ms
		mov al,01h
		out 0Ah,al ;prints U
		
		mov al,50h
		out 08h,al
		call DELAY_20ms
		mov al,05h
		out 0Ah,al
		call DELAY_20ms
		mov al,01h
		out 0Ah,al ;prints P
		
		mov al,44h
		out 08h,al
		call DELAY_20ms
		mov al,05h
		out 0Ah,al
		call DELAY_20ms
		mov al,01h
		out 0Ah,al ;prints D
		
		mov al,41h
		out 08h,al
		call DELAY_20ms
		mov al,05h
		out 0Ah,al
		call DELAY_20ms
		mov al,01h
		out 0Ah,al ;prints A
		
		mov al,54h
		out 08h,al
		call DELAY_20ms
		mov al,05h
		out 0Ah,al
		call DELAY_20ms
		mov al,01h
		out 0Ah,al ;prints T
		
		mov al,45h
		out 08h,al
		call DELAY_20ms
		mov al,05h
		out 0Ah,al
		call DELAY_20ms
		mov al,01h
		out 0Ah,al ;prints E
		
		RET
	displayLCD_update ENDP
	
	Print_* proc
		MOV AL,2Ah
		OUT 08h,AL
		CALL DELAY_20ms
		MOV AL,05h
		OUT 0Ah,AL 
		CALL DELAY_20ms 
		MOV AL,01h 
		OUT 0Ah,AL ;Prints * 
		RET 
	Print_* ENDP 
	
	displayLCD_error proc
		MOV AL,0A0h
		OUT 08h,AL
		CALL DELAY_20ms
		
		MOV AL,05h
		OUT 0Ah,AL
		CALL DELAY_20ms
		
		MOV AL,01h
		OUT 02h,AL ;Print Space
		
		MOV AL,49h
		OUT 08h,AL
		CALL DELAY_20ms
		MOV AL,05h
		OUT 0Ah,AL
		CALL DELAY_20ms
		MOV AL,01h
		OUT 0Ah,AL ;Print I
		
		MOV AL,4Eh
		OUT 08h,AL
		CALL DELAY_20ms
		MOV AL,05h
		OUT 0Ah,AL
		CALL DELAY_20ms
		MOV AL,01h
		OUT 0Ah,AL ;Print N
		
		MOV AL,56h
		OUT 08h,AL
		CALL DELAY_20ms
		MOV AL,05h
		OUT 0Ah,AL
		CALL DELAY_20ms
		MOV AL,01h
		OUT 0Ah,AL ;Print V
		
		MOV AL,41h
		OUT 08h,AL
		CALL DELAY_20ms
		MOV AL,05h
		OUT 0Ah,AL
		CALL DELAY_20ms
		MOV AL,01h
		OUT 0Ah,AL ;Print A
		
		MOV AL,4Ch
		OUT 08h,AL
		CALL DELAY_20ms
		MOV AL,05h
		OUT 0Ah,AL
		CALL DELAY_20ms
		MOV AL,01h
		OUT 0Ah,AL ;Print L
		
		MOV AL,49h
		OUT 08h,AL
		CALL DELAY_20ms
		MOV AL,05h
		OUT 0Ah,AL
		CALL DELAY_20ms
		MOV AL,01h
		OUT 0Ah,AL ;Print I
		
		MOV AL,44h
		OUT 08h,AL
		CALL DELAY_20ms
		MOV AL,05h
		OUT 0Ah,AL
		CALL DELAY_20ms
		MOV AL,01h
		OUT 0Ah,AL ;Print D
		
		RET
	displayLCD_error ENDP
		
	
	clear_1digit_LCD proc ;Shift left -> print Space -> Shift Left
		MOV AL,00h
		OUT 0Ah,AL
		CALL DELAY_20ms
		
		MOV AL,10h
		OUT 08h,AL ;Shift Left by 1
		CALL DELAY_20ms
		MOV AL,04h
		OUT 0Ah,AL ;Enable High
		CALL DELAY_20ms
		MOV AL,00h ;Enable Low
		OUT 0Ah,AL
		
		MOV AL,0A0h
		OUT 08h,AL 
		CALL DELAY_20ms
		MOV AL,05h
		OUT 0Ah,AL
		CALL DELAY_20ms
		MOV AL,01h
		OUT 0Ah,AL ;Prints Space
		
		CALL DELAY_20ms
		MOV AL,10h
		OUT 08h,AL
		CALL DELAY_20ms
		MOV AL,04h
		OUT 0Ah,AL
		CALL DELAY_20ms
		MOV AL,00h
		OUT 0Ah,AL
		
		RET
	clear_1digit_LCD ENDP
	
	keypad_input proc ;AL will contain the key value
	
	x0:	MOV AL,00h ;Check for Key release
		OUT 0Ch,AL
	x1: 	IN AL,0Ch
		AND AL,0F0h
		CMP AL,0F0h
		JNZ x1
		CALL DELAY_20ms ;Debounce
		
		MOV AL,00h ;Check for Key press
		OUT 0Ch,AL
	x2:	IN AL,0Ch
		AND AL,0F0h
		CMP AL,0F0h
		JZ x2
		CALL DELAY_20ms
		
		MOV AL,00h ;Confirm Key press
		OUT 0Ch,AL
		IN AL,0Ch
		AND AL,0F0h
		CMP AL,0F0h
		JZ x2
		
		MOV AL,0Eh ;Checking in Column 1
		MOV BL,AL
		OUT 0Ch,AL
		IN AL,0Ch
		AND AL,0F0h
		CMP AL,0F0h
		JNZ x3
		MOV AL,0Dh ;Checking in Column 2
		MOV BL,AL
		OUT 0Ch,AL
		IN AL,0Ch
		AND AL,0F0h
		CMP AL,0F0h
		JNZ x3
		MOV AL,0Bh ;Checking in Column 3
		MOV BL,AL
		OUT 0Ch,AL
		IN AL,0Ch
		AND AL,0F0h
		CMP AL,0F0h
		JNZ x3
		MOV AL,07h ;Checking in Column 4
		MOV BL,AL
		OUT 0Ch,AL
		IN AL,0Ch
		AND AL,0F0h
		CMP AL,0F0h
		JZ x2
	
	x3:	OR AL,BL
		RET
	keypad_input ENDP
	
	close_door proc
		MOV AL,83h
		OUT 02h,AL
		CALL DELAY_max
		MOV AL,00h
		OUT 02h,AL
		RET
	close_door ENDP
	
	open_door proc
		CALL clear_displayLCD
		MOV AL,8Ah
		OUT 02h,AL
		
		CALL DELAY_20ms
		
	x31:	IN AL,04h ; Input from Timer
		CMP AL,0F0h
		JNZ x31
			
		CALL DELAY_20ms
		CALL close_door
		RET
	open_door ENDP
	
	entermaster proc
		CALL clear_displayLCD
		MOV AL,0FEh
		OUT 00h,AL  ;Turn On Enter Pwd LED
		MOV CX,16
		
	enter_16_bit:	CALL keypad_input
					
					CMP AL,0E7h
					JZ press_c
					
					CMP AL,0D7h
					JZ press_ac
					
					CMP AL,77h
					JZ press_enter
					
					CMP AL,7Eh
					JZ invalid_master	;Invalid key M pressed
					
					CMP AL,7Dh
					JZ invalid_master	;Invalid key O pressed
					
					CMP AL,7Bh
					JZ invalid_master	;Invalid key A pressed
					
					MOV [SI],AL
					CALL Print_*
					
					INC SI
					DEC CX
					JNZ enter_16_bit
					
	disp_enter_master:	CALL keypad_input
						CMP AL,0E7h
						JZ press_c
						
						CMP AL,0D7h
						JZ press_ac
						
						CMP AL,77h
						JZ press_enter
						
						JMP disp_enter_master
				
	invalid_master:	NOP
				JMP enter_16_bit
					
	press_c:	CALL clear_1digit_LCD
				DEC SI
				INC CX
				JMP enter_16_bit
				
	press_ac:	CALL clear_displayLCD
				MOV CX,16
				MOV SI,1Eh 
				JMP enter_16_bit
				
	press_enter:	CALL clear_displayLCD
					MOV AL,0FFh ;Turn Off all LEDs
					OUT 00h,AL
					CMP CX,0
					JZ cmp_pass
					JMP raise_alarm
					
	day_pass:	MOV SI,002Eh
				MOV AL,0FDh
				OUT 00h,AL ;Turn On Retry/Update LED
				
				CALL DELAY_max
				CALL DELAY_max
				CALL DELAY_max
				
				CALL clear_displayLCD
				MOV CX,12
				
	enter_12_bit_m:	CALL keypad_input
					CMP AL,0E7h
					JZ press_cday
					
					CMP AL,0D7h
					JZ press_acday
					
					CMP AL,7Eh
					JZ invalid_day
					
					CMP AL,7Dh
					JZ invalid_day
					
					CMP AL,7Bh
					JZ invalid_day
					
					CMP AL,77h
					JZ press_enter_day
					
					MOV [SI],AL
					CALL Print_*
					INC SI
					DEC CX
					JNZ enter_12_bit_m
					
	disp_enter:	CALL keypad_input
				CMP AL,0E7h
				JZ press_cday
				
				CMP AL,0D7h
				JZ press_acday
				
				CMP AL,77h
				JZ press_enter_day
				
				JMP disp_enter
				
	invalid_day:	NOP
			JMP enter_12_bit_m
					
	press_cday:	CALL clear_1digit_LCD
				DEC SI
				INC CX
				JMP enter_12_bit_m
				
	press_acday:	CALL clear_displayLCD
					MOV CX,12
					MOV SI,002Eh
					JMP enter_12_bit_m
					
	press_enter_day:	CALL clear_displayLCD
						MOV AL,0FFh
						OUT 00h,AL 	;Shut down all LEDs
						
						CMP CX,0
						JNZ err_msg
						
						MOV AL,0Fbh
						OUT 00h,AL 	;Turns On Password Updated LED
						
						CALL DELAY_max
						CALL DELAY_max
						
						MOV AL,0FFh
						OUT 08h,AL
						JZ end_69h
						
	err_msg:	CALL 	displayLCD_error
				JMP day_pass
				
	cmp_pass:	CLD
				MOV SI,0000h
				MOV DI,001Eh
				MOV CX,17
			
			x5:	MOV AL,[SI]
				MOV BL,[DI]
				DEC CX
				JZ day_pass 	;Correct Master Password  Set new day password
				CMP AL,BL
				JNZ raise_alarm
				INC SI
				INC DI
				JMP x5
				
	raise_alarm:	MOV DH,5h
					MOV AL,0Fh ;Turn On Alarm and turn off the 3 LEDs
					OUT 00h,AL
					MOV AX,0ABCDh
				
	end_69h:	RET
	
	entermaster ENDP
				
	enteralarm proc
		MOV AL,0Eh
		OUT 00h,AL ;Glow Enter Pwd LED
		
		MOV CX,14
		MOV SI,3Ah
		
	enter_14_bit:	CALL keypad_input
					CMP AL,0E7h
					JZ press_c_alarm
					
					CMP AL,0D7h
					JZ press_ac_alarm
					
					CMP AL,7Eh
					JZ invalid_alarm
					
					CMP AL,7Dh
					JZ invalid_alarm
					
					CMP AL,7Bh
					JZ invalid_alarm
				
					CMP AL,77h
					JZ press_enter_alarm
					
					MOV [SI],AL
					CALL Print_*
					INC SI
					DEC CX
					JNZ enter_14_bit
		
	disp_enter_alarm:	call keypad_input
						CMP AL,0E7h
						JZ press_c_alarm
						
						CMP AL,0D7h
						JZ press_ac_alarm
						
						CMP AL,77h
						JZ press_enter_alarm
						
	invalid_alarm:	NOP
					JMP enter_14_bit
					
	press_c_alarm:	CALL clear_1digit_LCD
					DEC SI
					INC CX
					JMP enter_14_bit
					
	press_ac_alarm:	CALL clear_displayLCD
					MOV CX,14
					MOV SI,3Ah
					JMP enter_14_bit
					
	press_enter_alarm:	CALL clear_displayLCD
						MOV AL,0Fh
						OUT 00h,AL ;Turn off LEDs
						
						CMP CX,0
						JZ cmp_pass_alarm
						
						JNZ x56
						
	cmp_pass_alarm:	CLD
					MOV SI,10h
					MOV DI,3Ah
					MOV CX,14
					REPE CMPSB
					CMP CX,00h
					JNZ x56
					MOV AL,0FFh
					OUT 00h,AL
					ADD DH,1h
			
	x56:	RET
	
	enteralarm ENDP
	
	entu proc
		CALL clear_displayLCD
		MOV DL,1 ; For checking two inputs
		
		MOV AL,0FEh
		OUT 00h,AL ;Turn on enter pwd LED
		
		MOV CX,12
		MOV SI,48h
		
	enter_12_bit:	CALL keypad_input
					CMP AL,0E7h
					JZ press_c_user
					
					CMP AL,0D7h
					JZ press_ac_user
					
					CMP AL,7Eh
					JZ invalid_user
					
					CMP AL,7Dh
					JZ invalid_user
					
					CMP AL,7Bh
					JZ invalid_user
					
					CMP AL,77h
					JZ press_enter_user
					
					MOV [SI],AL
					CALL Print_*
					INC SI
					DEC CX
					JNZ enter_12_bit
					
	disp_enter_user:	CALL keypad_input
						CMP AL,0E7h
						JZ press_c_user
						
						CMP AL,0D7h
						JZ press_ac_user
						
						CMP AL,77h
						JZ press_enter_user
						
	invalid_user:	NOP
					JMP enter_12_bit
					
	press_c_user:	CALL clear_1digit_LCD
					DEC SI
					INC CX
					JMP enter_12_bit
					
	press_ac_user:	CALL clear_displayLCD
					MOV CX,12
					MOV SI,48h
					JMP enter_12_bit
					
	press_enter_user:	MOV AL,0FFh
						OUT 00h,AL
						CMP CX,0h
						JZ cmp_pass_user
						JNZ wrong_pass
						
	cmp_pass_user:	CLD
					MOV SI,2Eh
					MOV DI,48h
					MOV CX,12
					REPE CMPSB
					CMP CX,00h
					JNZ wrong_pass
					JZ open_door_user
					
	wrong_pass:	CALL clear_displayLCD
				MOV SI,48h
				MOV CX,12
				CMP dl,0
				JZ raise_alarm_user
				MOV AL,0FDh
				OUT 00h,AL
				
				DEC DL
				JMP enter_12_bit
				
	raise_alarm_user:	MOV DH,0h
				MOV AL,0Fh
				OUT 00h,AL
				MOV AX,0ABCDh
				JMP end_70h
				
	open_door_user:	CALL open_door
	
	end_70h:	RET
	
	entu ENDP
		
	Nmi_24hrtimer:	CALL clear_displayLCD
			CALL clear_1digit_LCD
			CALL displayLCD_update
					
	startnmi:	CALL keypad_input
			CMP AL,7Eh
			JZ master_mode
			JMP startnmi
					
	IRET
	
	Switch_intR:	CALL open_door
					STI
					CMP BP,0ABCDh
					JZ x6
					JNZ start


HLT           ; halt!


