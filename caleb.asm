.MODEL COMPACT
.STACK
.DATA

	PROMPT_LOGIN DB "Login: $"
	PASS_INPUT DB 10 DUP ('$')
	PASS_PRESET DB 'caleb'
	PASS_SIZE EQU ($-PASS_PRESET)
	PASS_ERROR DB "Invalid Password. Please Try Again. $"
	
	PROMPT_WELCOME DB "Welcome to SaPark Hotel Management System!$"
	PROMPT_LINE DB "---------------------------------------------$"
	
	PROMPT_NAME DB "Enter customer's name : $"
	PROMPT_ICNO DB "Enter customer's IC/Passport number : $"
	PROMPT_HPNO DB "Enter customer's contact number		: $"
	
	CUST_NAME_ARR LABEL BYTE
	MAX_NAME DB 50
	CUST_NAME_SIZE DB ?
	CUST_NAME DB 50 DUP ('$')
	
	CUST_ICNO_ARR LABEL BYTE
	MAX_ICNO DB 13
	CUST_ICNO_SIZE DB ?
	CUST_ICNO DB 13 DUP ('$')
	
	CUST_HPNO_ARR LABEL BYTE
	MAX_HPNO DB 12
	CUST_HPNO_SIZE DB ?
	CUST_HPNO DB 12 DUP ('$')
	
	NAME_ERROR1 DB "Name cannot be empty. $"
	NAME_ERROR2 DB "Name can only consist of alphabets. $"
	ICNO_ERROR1 DB "IC number cannot be empty and MUST be 12 digits(111111223333). $"
	ICNO_ERROR2 DB "IC number must only contain digits (0-9). $"
	HPNO_ERROR1 DB "Contact number should ONLY consists of 10-11 digits (eg: 0123456789). $"
	HPNO_ERROR2 DB "Contact number must start with 01xxxxxxxx."
	
	detail1 db "Room Type Details $"
	detail2 db "******************************************************************** $"
	detail3 db "  Room Type					Room Rate $"
	detail4 db "  ---------					--------- $"
	detail5 db "(1)Studio	(2 person)	        	RM 400 $"
	detail6 db "(2)Tioga  	(1 Bedroom 3 person)	        RM 500 $"
	detail7 db "(3)Fresno	(2 Bedroom 4 person)	        RM 600 $"
	detail8 db "(4)Shasta	(3 Bedroom 6 person)	        RM 700 $"
	
	PROMPT_CHOICE DB 	"Your Choice(1-4) : $"
	PROMPT_CHECKIN DB 	"Check in date(DD/MM/YYYY)	: $"
	PROMPT_CHECKOUT DB	"Check out date(DD/MM/YYYY)	: $"
	
	CUST_CHOICE DB ?
	
	CUST_CHECKIN_ARR LABEL BYTE
	MAX_CHECKIN DB 11
	CUST_CHECKIN_SIZE DB ?
	CUST_CHECKIN DB 11 DUP ('&')
	
	CUST_CHECKOUT_ARR LABEL BYTE
	MAX_CHECKOUT DB 11
	CUST_CHECKOUT_SIZE DB ?
	CUST_CHECKOUT DB 11 DUP ('&')
	
	CHOICE_ERROR1 DB "Choice cannot be empty. $"
	CHOICE_ERROR2 DB "Choice should only consist of digits 1-4. $"
	
	
	
	
	CHECK_MEMBER DB ?
	stay_days DB ?
	ROOM_PRICE DB 0D
	
	membership db "Membership (y/n): $"
	errorY_N db "Only can enter y or n! $"
	ninety_percent DW 9
	temporary dW ?
	TOTAL_PAYMENT DW ?
	DISCOUNT DW ?
	SUBTOTAL DW ?
	ZERO DB "0$"
	
	afterDiscount db ?,?,?,30H
	
	STARS DB 40 DUP("*"),"$"
	EQUALS DB 40 DUP("="),"$"
	PRINT_PAYMENT DB "PAYMENT: $"
	PRINT_SUBTOTAL DB "Subtotal            : RM $"
	PRINT_DISCOUNT DB "Discount for member(discount 10 %): RM  $"
	PRINT_TOTAL_PAYMENT DB "Total Payment       : RM $"
	
	
	
.CODE

	MAIN PROC FAR
		MOV AX, @DATA
		MOV DS, AX
	
	DISPLAYLOGIN:
		MOV AH, 02H
		MOV DL, 0AH
		INT 21H
		MOV DL, 0DH
		INT 21H
		
		;PROMPT LOGIN SCREEN
		MOV AH, 09H
		LEA DX, PROMPT_LOGIN
		INT 21H
		
		MOV SI, 0
		
		REPLACE:
			MOV AH, 08H
			INT 21H
			
			CMP AL, 0DH
			JE CHECKPASS
			
			MOV [PASS_INPUT+SI], AL
			MOV DL, '*'
			MOV AH, 02H
			INT 21H
			
			INC SI
			JMP REPLACE
		
		CHECKPASS:
			MOV BX, 0
			MOV CX, PASS_SIZE
			
			CHECKPASSLOOP:
				MOV AL, [PASS_INPUT+BX]
				MOV DL, [PASS_PRESET+BX]
				CMP AL, DL
				JNE DISPLAYERROR
				INC BX
				LOOP CHECKPASSLOOP
				
			;IF NO ERROR, DISPLAY WELCOME SCREEN
			JMP DISPLAYWELCOME
	
		DISPLAYERROR:	
			;IF GOT ERROR, DISPLAY ERROR MESSAGE
			MOV AH, 02H
			MOV DL, 0AH
			INT 21H
			MOV DL, 0DH
			INT 21H
		
			MOV AH, 09H
			LEA DX, PASS_ERROR
			INT 21H
		
			MOV AH, 02H
			MOV DL, 0AH
			INT 21H
			MOV DL, 0DH
			INT 21H
		
			JMP DISPLAYLOGIN
	
	DISPLAYWELCOME:
		MOV AH, 02H
		MOV DL, 0AH
		INT 21H
		MOV DL, 0DH
		INT 21H
		
		MOV AH, 09H
		LEA DX, PROMPT_WELCOME
		INT 21H
		
		MOV AH, 02H
		MOV DL, 0AH
		INT 21H
		MOV DL, 0DH
		INT 21H
		
		MOV AH, 09H
		LEA DX, PROMPT_LINE
		INT 21H
		
		MOV AH, 02H
		MOV DL, 0AH
		INT 21H
		MOV DL, 0DH
		INT 21H
		
		JMP PERSONALDETAILS
				
	PERSONALDETAILS:
		NAMEDETAILS:
			MOV AH, 02H
			MOV DL, 0AH
			INT 21H
			MOV DL, 0DH
			INT 21H
			
			MOV AH, 09H
			LEA DX, PROMPT_NAME
			INT 21H
		
			MOV AH, 0AH
			LEA DX, CUST_NAME_ARR
			INT 21H
		
			MOV AL, CUST_NAME_SIZE
			CBW
			MOV CX, AX
			MOV SI, 0
		
		CHECKNAME:
			;CHECK IF NAME IS EMPTY
			CMP CUST_NAME_SIZE, 0
			JE DISPLAYNAMEERROR1
		
			CHECKNAMELOOP:
				;VALIDATING NAME (ALPHABETS AND SPACE)
				CMP [CUST_NAME + SI], 20H
				JE NAMECOUNT
				
				UPPERCASE:
					CMP [CUST_NAME + SI], 41H ;CAPITAL A
					JL DISPLAYNAMEERROR2
					CMP [CUST_NAME + SI], 5AH ;CAPITAL Z
					JG LOWERCASE
					JLE NAMECOUNT
				
				LOWERCASE:
					CMP [CUST_NAME + SI], 61H ;SMALL a
					JL DISPLAYNAMEERROR2
					CMP [CUST_NAME + SI], 7AH ; SMALL z
					JG DISPLAYNAMEERROR2
					JLE NAMECOUNT
				
			NAMECOUNT:
				INC SI
				LOOP CHECKNAMELOOP
			
			JMP ICNODETAILS	
		
		DISPLAYNAMEERROR1:
			MOV AH, 02H
			MOV DL, 0AH
			INT 21H
			MOV DL, 0DH
			INT 21H
		
			MOV AH, 09H
			LEA DX, NAME_ERROR1
			INT 21H
			
			JMP NAMEDETAILS
		
		DISPLAYNAMEERROR2:
			MOV AH, 02H
			MOV DL, 0AH
			INT 21H
			MOV DL, 0DH
			INT 21H
		
			MOV AH, 09H
			LEA DX, NAME_ERROR2
			INT 21H
			
			JMP NAMEDETAILS
	
		ICNODETAILS:
			MOV AH, 02H
			MOV DL, 0AH
			INT 21H
			MOV DL, 0DH
			INT 21H
			
			MOV AH, 09H
			LEA DX, PROMPT_ICNO
			INT 21H
			
			MOV AH, 0AH
			LEA DX, CUST_ICNO_ARR
			INT 21H
			
			MOV AL, CUST_ICNO_SIZE
			CBW
			MOV CX, AX
			MOV SI, 0
			
		CHECKICNO:
			CMP CUST_ICNO_SIZE, 0
			JE DISPLAYICNOERROR1
			CMP CUST_ICNO_SIZE, 12
			JNE DISPLAYICNOERROR1
			
			CHECKICNOLOOP:
				CMP [CUST_ICNO + SI], 30H ;DIGIT 0
				JL DISPLAYICNOERROR2
				CMP [CUST_ICNO + SI], 39H ;DIGIT 9
				JG DISPLAYICNOERROR2
			
				INC SI
				LOOP CHECKICNOLOOP
				
			JMP HPNODETAILS
		
		DISPLAYICNOERROR1:
			MOV AH, 02H
			MOV DL, 0AH
			INT 21H
			MOV DL, 0DH
			INT 21H
		
			MOV AH, 09H
			LEA DX, ICNO_ERROR1
			INT 21H
			
			JMP ICNODETAILS

		DISPLAYICNOERROR2:
			MOV AH, 02H
			MOV DL, 0AH
			INT 21H
			MOV DL, 0DH
			INT 21H
		
			MOV AH, 09H
			LEA DX, ICNO_ERROR2
			INT 21H
			
			JMP ICNODETAILS

		HPNODETAILS:
			MOV AH, 02H
			MOV DL, 0AH
			INT 21H
			MOV DL, 0DH
			INT 21H
		
			MOV AH, 09H
			LEA DX, PROMPT_HPNO
			INT 21H
			
			MOV AH, 0AH
			LEA DX, CUST_HPNO_ARR
			INT 21H
			
			MOV AL, CUST_HPNO_SIZE
			CBW
			MOV CX, AX
			MOV SI, 0
		
		CHECKHPNO:
			CMP CUST_HPNO_SIZE, 0
			JE DISPLAYHPNOERROR1
			CMP CUST_HPNO_SIZE, 10
			JL DISPLAYHPNOERROR1
			CMP CUST_HPNO_SIZE, 11
			JG DISPLAYHPNOERROR1
			CMP [CUST_HPNO + 0], 30H
			JNE DISPLAYHPNOERROR2
			CMP [CUST_HPNO + 1], 31H
			JNE DISPLAYHPNOERROR2
			
			CHECKHPNOLOOP:
				CMP [CUST_HPNO + SI], 30H
				JL DISPLAYHPNOERROR1
				CMP [CUST_HPNO + SI], 39H
				JG DISPLAYHPNOERROR1
				
				INC SI
				LOOP CHECKHPNOLOOP
			
			JMP DISPLAYROOMS
		
		DISPLAYHPNOERROR1:
			MOV AH, 02H
			MOV DL, 0AH
			INT 21H
			MOV DL, 0DH
			INT 21H
		
			MOV AH, 09H
			LEA DX, HPNO_ERROR1
			INT 21H
			
			JMP HPNODETAILS
			
		DISPLAYHPNOERROR2:
			MOV AH, 02H
			MOV DL, 0AH
			INT 21H
			MOV DL, 0DH
			INT 21H
		
			MOV AH, 09H
			LEA DX, HPNO_ERROR2
			INT 21H
			
			JMP HPNODETAILS
	
	DISPLAYROOMS:
		MOV AH, 02H
		MOV DL, 0AH
		INT 21H
		MOV DL, 0DH
		INT 21H
		
		MOV AH, 02H
		MOV DL, 0AH
		INT 21H
		MOV DL, 0DH
		INT 21H
		
	;output of detail
		mov ah,09h
		lea dx,detail1
		int 21h
	;print new line
		mov ah,02h
		mov dl,0ah
		int 21h
		mov dl,0dh
		int 21h
	;output of detail
		mov ah,09h
		lea dx,detail2
		int 21h
	;print new line
		mov ah,02h
		mov dl,0ah
		int 21h
		mov dl,0dh
		int 21h
	;output of detail
		mov ah,09h
		lea dx,detail3
		int 21h
	;print new line	
		mov ah,02h
		mov dl,0ah
		int 21h
		mov dl,0dh
		int 21h
	;output of detail
		mov ah,09h
		lea dx,detail4
		int 21h
	;print new line
		mov ah,02h
		mov dl,0ah
		int 21h
		mov dl,0dh
		int 21h
	;output of detail
		mov ah,09h
		lea dx,detail5
		int 21h
	;print new line
		mov ah,02h
		mov dl,0ah
		int 21h
		mov dl,0dh
		int 21h
	;output of detail	
		mov ah,09h
		lea dx,detail6
		int 21h
	;print new line
		mov ah,02h
		mov dl,0ah
		int 21h
		mov dl,0dh
		int 21h
	;output of detail
		mov ah,09h
		lea dx,detail7
		int 21h
	;print new line
		mov ah,02h
		mov dl,0ah
		int 21h
		mov dl,0dh
		int 21h
	;output of detail
		mov ah,09h
		lea dx,detail8
		int 21h
	;print new line
		mov ah,02h
		mov dl,0ah
		int 21h
		mov dl,0dh
		int 21h	
	;print new line
		mov ah,02h
		mov dl,0ah
		int 21h
		mov dl,0dh
		int 21h

	DISPLAYQUERIES:
		MOV AH, 02H
		MOV DL, 0AH
		INT 21H
		MOV DL, 0DH
		INT 21H
		
	DISPLAYCHOICE:
		MOV AH, 02H
		MOV DL, 0AH
		INT 21H
		MOV DL, 0DH
		INT 21H
		
		MOV AH, 09H
		LEA DX, PROMPT_CHOICE
		INT 21H
		
		MOV AH, 01H
		INT 21H
		MOV CUST_CHOICE, AL
		
		

	CHECKCHOICE:
		CMP CUST_CHOICE, 0
		JE DISPLAYCHOICEERROR1
		CMP CUST_CHOICE, 31H
		JE CHOICE_1
		JL DISPLAYCHOICEERROR2
		CMP CUST_CHOICE, 32H
		JE CHOICE_2
		CMP CUST_CHOICE, 33H
		JE CHOICE_3
		CMP CUST_CHOICE, 34H 
		JE CHOICE_4
		JG DISPLAYCHOICEERROR2
		
		JMP PAYMENT_OF_MEMBER
		
		 
		
		CHOICE_1:
			MOV SUBTOTAL, "4$"
			MOV ROOM_PRICE, 4D
			JMP CHECKIN
		CHOICE_2:
			MOV SUBTOTAL, "5$"
			MOV ROOM_PRICE, 5D
			JMP CHECKIN
		CHOICE_3:
			MOV SUBTOTAL, "6$"
			MOV ROOM_PRICE, 6D
			JMP CHECKIN
		CHOICE_4:
			MOV SUBTOTAL, "7$"
			MOV ROOM_PRICE, 7D
			JMP CHECKIN
			
	DISPLAYCHOICEERROR1:
		MOV AH, 02H
		MOV DL, 0AH
		INT 21H
		MOV DL, 0DH
		INT 21H
		
		MOV AH, 09H
		LEA DX, CHOICE_ERROR1
		INT 21H
		
		JMP DISPLAYCHOICE
			
	DISPLAYCHOICEERROR2:
		MOV AH, 02H
		MOV DL, 0AH
		INT 21H
		MOV DL, 0DH
		INT 21H
		
		MOV AH, 09H
		LEA DX, CHOICE_ERROR2
		INT 21H
		
		JMP DISPLAYCHOICE	

		
	CHECKIN:;ADD CHECK IN HERE	
		JMP PAYMENT_OF_MEMBER
		
		
	PAYMENT_OF_MEMBER:
			;PRINT NEW lINE 
			MOV AH,02H
			MOV DL,0AH
			INT 21H
			MOV DL ,0DH
			INT 21H	
			
			ASK_MEMBERSHIP:
				mov ah,09H
				lea dx,membership
				int 21h
				
				
				mov ah,01h
				int 21h
			
				;check yes
				cmp al,79h  
				JE SET_MEMBER

				cmp al, 6eh
				JE SET_NOTMEMBER
				jne ERROROF_Y_N

				ERROROF_Y_N:
					;print new line
					mov ah,02h
					mov dl, 0ah
					int 21h
					mov ah,0dh
					int 21h

					;prompt error
					mov ah,09H
					lea dx,errorY_N
					int 21h

					;print new line
					mov ah,02h
					mov dl, 0ah
					int 21h
					mov ah,0dh
					int 21h
					jmp ASK_MEMBERSHIP
				
				SET_MEMBER:
					MOV CHECK_MEMBER, 79H
					JMP SHOWPAYMENT
					
				SET_NOTMEMBER:
					MOV CHECK_MEMBER, 6EH
					JMP SHOWPAYMENT
				
			
			SHOWPAYMENT:
				;PRINT NEW lINE
				MOV AH,02H
				MOV DL,0AH
				INT 21H
				MOV DL ,0DH
				INT 21H	
			
				MOV AH, 09H
				LEA DX, PRINT_PAYMENT
				INT 21H 
				
				;PRINT NEW lINE  
				MOV AH,02H
				MOV DL,0AH
				INT 21H
				MOV DL ,0DH
				INT 21H	
		
				MOV AH,09H 
				LEA DX, STARS
				INT 21H
				
				;PRINT NEW lINE 
				MOV AH,02H
				MOV DL,0AH
				INT 21H
				MOV DL ,0DH
				INT 21H		
										
				MOV AL, ROOM_PRICE
						
				MOV CL, stay_days
				SUB CL, 30H 
				MUL CL
						
				AAM 
				XCHG AL, AH 
				ADD AX, 3030H 
				MOV SUBTOTAL, AX
						
				CMP CHECK_MEMBER, 79H
				JE HAVE_DISCOUNT
				
				CMP CHECK_MEMBER, 6EH
				JE NOT_HAVE_DISCOUNT_1
				
				NOT_HAVE_DISCOUNT_1:
					JMP NOT_HAVE_DISCOUNT	

						MOV AL, ROOM_PRICE
						
						MOV CL, stay_days ;(need add how many day customer stay_days)
						SUB CL, 30H 
						MUL CL
						
						AAM 
						XCHG AL, AH 
						ADD AX, 3030H 
						MOV SUBTOTAL, AX

			HAVE_DISCOUNT:
						MOV DX,SUBTOTAL
						MOV temporary,DX
	
						 MOV AX, [temporary+1]
						 SUB AL,30H
						 MOV DX, ninety_percent
						 MUL DX
						 AAM
						 MOV [afterDiscount+2],AL
						 MOV [afterDiscount+1],AH
						 
						
						MOV AX, [temporary+0]
						 SUB AL,30H
						 MOV DX, ninety_percent
						 MUL DX
						 AAM
						 MOV [afterDiscount+0],AH
						 ADC [afterDiscount+1],AL
						 
						 MOV AL,[afterDiscount+1]
						 CMP AL,0AH
						 JGE NORMAL
						 JMP WITHCARRY
						 
						 NORMAL:
						 MOV AL,[afterDiscount+1]
						 CBW
						 AAM
						 MOV [afterDiscount+1],AL
						 ADD [afterDiscount+0],AH
						 JMP WITHCARRY
						 
						 WITHCARRY:
						 ADD [afterDiscount+0],30H
						 ADD [afterDiscount+1],30H
						 ADD [afterDiscount+2],30H
						 
						 
						
						
						;PRINT SUBTOTAL
						MOV AH, 09H
						LEA DX, PRINT_SUBTOTAL
						INT 21H 
						
						MOV AH, 09H
						LEA DX, SUBTOTAL
						INT 21H 
						
						MOV AH, 09H
						LEA DX, ZERO
						INT 21H 
						
						
						;PRINT NEW lINE  
						MOV AH,02H
						MOV DL,0AH
						INT 21H
						MOV DL ,0DH
						INT 21H	
					
						;PRINT DISCOUNT
						MOV AH, 09H
						LEA DX, PRINT_DISCOUNT
						INT 21H 	
					
						MOV AH, 09H
						LEA DX, SUBTOTAL
						INT 21H 
						
						MOV AH, 09H
						LEA DX, ZERO
						INT 21H
 
						
						;PRINT NEW lINE
						MOV AH,02H
						MOV DL,0AH
						INT 21H
						MOV DL ,0DH
						INT 21H	
					
						;PRINT Total
						MOV AH, 09H
						LEA DX, PRINT_TOTAL_PAYMENT
						INT 21H
						
						MOV AH, 09H
						LEA DX, afterDiscount
						INT 21H
							
						;PRINT NEW lINE 
						MOV AH,02H
						MOV DL,0AH
						INT 21H
						MOV DL ,0DH
						INT 21H	
						
						;PRINT "===================="	
						MOV AH, 09H
						LEA DX, EQUALS
						INT 21H 
					JMP CONTINUE	
						
				NOT_HAVE_DISCOUNT:
						;PRINT SUBTOTAL
							MOV AH, 09H
							LEA DX, PRINT_SUBTOTAL
							INT 21H 
							
							MOV AH, 09H
							LEA DX, SUBTOTAL
							INT 21H 
							
							MOV AH, 09H
							LEA DX, ZERO
							INT 21H
							
							MOV AH, 09H
							LEA DX, ZERO
							INT 21H 
							
							;PRINT NEW lINE  
							MOV AH,02H
							MOV DL,0AH
							INT 21H
							MOV DL ,0DH
							INT 21H	
						
							;PRINT DISCOUNT
							MOV AH, 09H
							LEA DX, PRINT_DISCOUNT
							INT 21H 	
							
							MOV AH, 09H
							LEA DX, ZERO
							INT 21H  
						
							;PRINT NEW lINE 
							MOV AH,02H
							MOV DL,0AH
							INT 21H
							MOV DL ,0DH
							INT 21H	
						
							;PRINT Total
							MOV AH, 09H
							LEA DX, PRINT_TOTAL_PAYMENT
							INT 21H
							
							MOV AH, 09H
							LEA DX, SUBTOTAL
							INT 21H 
							
							MOV AH, 09H
							LEA DX, ZERO
							INT 21H
							
							MOV AH, 09H
							LEA DX, ZERO
							INT 21H 
						
							;PRINT NEW lINE 
							MOV AH,02H
							MOV DL,0AH
							INT 21H
							MOV DL ,0DH
							INT 21H	
							
							;PRINT "==="	
							MOV AH, 09H
							LEA DX, EQUALS
							INT 21H 
							
						
							;PRINT NEW lINE
							MOV AH,02H
							MOV DL,0AH
							INT 21H	
							MOV DL ,0DH
							INT 21H		
					

		CONTINUE:;Put continue loop here	
			
	ENDPROGRAM:
		MOV AX, 4C00H
		INT 21H
	MAIN ENDP
	END MAIN
		
	
	