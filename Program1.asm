TITLE Programming Assignment #1     (Program1.asm)

; Author:Brandon Swanson
; Course / Project ID:  CS271-400 Fall14 Programming Assignment #1    Date:10/6/14
; Description:This Program Will, Display its title, and then prompt the user to enter two numbers
;				It will perfrom various operations on these numbers and then terminate

INCLUDE Irvine32.inc

;##########################################################################################
;################## VARIABLE DECLARATIONS #################################################
;##########################################################################################
.data

;//////////////////////////////////////////OUTPUT STRINGS////////////////////////
my_name		BYTE "I am Brandon Swanson and this is Program Assignment 1",0
instruction BYTE "This Program will perform a series of opperations on the numbers entered and output the result",13,10
			BYTE "Requirments LHS <= RHS ,  0<LHS , 0<RHS",0
input_Lhs	BYTE "Please enter the left-hand-side value: ",0
input_Rhs	BYTE "Please enter the right-hand-side value: ",0

again		BYTE "Would you like to perorm these operations on different numbers?",0
yesNo		BYTE "press 'y' for yes, any other key will exit",0
rhsMore		BYTE "The number for the right hand side is greater than the left hand side,  would you like to swap them?",0
swapYes		BYTE "press 'y' will swap the values, any other key will give you the oportunity to enter new numbers",0

goodbye		BYTE "Thank you, have a nice day",0

;///////////////////////////INPUT VARIABLES///////////////////////////////
Lhs			DWORD ? ;LEFT HAND SIDE ARGUMENT
Rhs			DWORD ? ;RIGHT HAND SIDE ARGUMENT

;//////////////////////////OPERATION RESULTS/////////////////////////////////
mSum		DWORD ?
mDiff		DWORD ? 
mProduct	DWORD ?
mQuotient	DWORD ?
mRemainder	DWORD ?

;////////////////////////RESULT DISPLAY STRINGS///////////////////////////////
sPlus		BYTE  " + ",0
sMinus		BYTE  " - ",0
sTimes		BYTE  " * ",0
sDiv		BYTE  32,246,32,0
sEqu		BYTE  " = ",0
sRemain		BYTE  "  With a remainder of: ",0

;///////////////////////CONTROL VARIABLE/////////////////////////////////////
affirm		BYTE  'y'

;##########################################################################################
;################ PROCEDURE: MAIN  ########################################################
;##########################################################################################

.code
main PROC

;/////////////////////////////////////////////////////
;//////////////////INTRO PROGRAM//////////////////////

															;########INTRODUCTION##########
	mov	edx,OFFSET	my_name
	call WriteString
	call crlf

	mov	edx,OFFSET	instruction
	call WriteString
	call crlf

;################################################
GET_NUMBERS: ;###################################
;################################################
															;########GET DATA##############
;////////////PROMPT INPUT//// LHS ////////////////////
	mov	edx,OFFSET	input_Lhs
	call WriteString
	call crlf

;///////////RETRIEVE INPUT/// LHS ////////////////////
	call ReadDec
	mov  Lhs, eax	;store input
	

;////////////PROMPT INPUT//// RHS ////////////////////
	mov	edx,OFFSET	input_Rhs
	call WriteString
	call crlf
;///////////RETRIEVE INPUT/// RHS ////////////////////
	call ReadDec
	mov  Rhs, eax	;store input

;///////// ASSERTING RHS <= LHS //////////////////////
	mov eax,rhs
	cmp eax,lhs	  ;Checking rhs>lhs
	ja rhsGreater ;True, swap or re-enter

	jmp Calculate ;not greater, continue to calculations

rhsGreater:
	mov edx, OFFSET rhsMore
	call WriteString		;display error message
	call crlf

	mov edx, OFFSET swapYes
	call Writestring		;display input instructions
	call crlf

	call Readchar			;get single character from keyboard
	cmp al, affirm			;check for char=='y'
	jne	GET_NUMBERS			;FALSE return to number input

							;TRUE swap numbers
	mov eax,lhs
	mov ebx,rhs
	mov lhs,ebx
	mov rhs,eax

	
;################################################
Calculate: ;#####################################
;################################################
															;####CALCULATE VALUES##########
;//////////CALCULATE SUM //// LHS + RHS///////////////
	mov eax,lhs
	add eax,rhs
	mov mSum,eax	; store result

;//////////CALCULATE DIFF// LHS - RHS ////////////////
	mov eax,lhs
	sub eax,rhs
	mov mDiff,eax	; store result

;//////////CALCULATE PROUDUC// LHS * RHS /////////////
	mov eax,lhs
	mul rhs
	mov mProduct,eax	; store result

;//////////CALCULATE QUOTIENT// LHS / RHS ////////////
	mov edx, 0		;this initializes edx 
					;because DIV accesses edx:eax for a 64bit dividend 
	mov eax, lhs
	div rhs

	mov mQuotient, eax	;store result
	mov mRemainder, edx ;store remainder

															;######DISPLAY RESULTS#########

;//////////DISPLAY SUM///////////////////////////////
	mov eax, Lhs
	call WriteDec			;display left hand side argument

	mov	edx,OFFSET	sPlus
	call WriteString		;display opperand

	mov eax, Rhs
	call WriteDec

	mov	edx,OFFSET	sEQU
	call WriteString		;display right hand side argument

	mov eax, mSum
	call WriteDec			;display result of operation
	call crlf
;//////////DISPLAY DIF/////////////////////////////////
	mov eax, Lhs
	call WriteDec			;display left hand side argument

	mov	edx,OFFSET	sMinus
	call WriteString		;display opperand

	mov eax, Rhs
	call WriteDec

	mov	edx,OFFSET	sEQU
	call WriteString		;display right hand side argument

	mov eax, mDiff
	call WriteDec			;display result of operation
	call crlf

;//////////DISPLAY PRODUCT/////////////////////////////
	mov eax, Lhs
	call WriteDec			;display left hand side argument

	mov	edx,OFFSET	sTimes
	call WriteString		;display opperand

	mov eax, Rhs
	call WriteDec

	mov	edx,OFFSET	sEQU
	call WriteString		;display right hand side argument

	mov eax, mProduct
	call WriteDec			;display result of operation
	call crlf

;//////////DISPLAY DIV/////////////////////////////////
	mov eax, Lhs
	call WriteDec			;display left hand side argument

	mov	edx,OFFSET	sDiv
	call WriteString		;display opperand

	mov eax, Rhs
	call WriteDec

	mov	edx,OFFSET	sEQU
	call WriteString		;display right hand side argument

	mov eax, mQuotient
	call WriteDec			;display result of operation
	
	mov edx,OFFSET	sRemain
	call WriteString		;display remainder label

	mov eax, mRemainder
	call WriteDec			;display remainder of operation
	call crlf


;////////// CHECK FOR REPEAT /////////////////////////
	mov edx, OFFSET again
	call WriteString		;display prompt to repeat
	call crlf
	mov edx, OFFSET yesNo
	call Writestring		;display input instructions
	call crlf

	call Readchar			;get single character from keyboard
	cmp al, affirm			;check for char=='y'
	je	GET_NUMBERS			;TRUE return to number input



															;######GOODBYE MESSAGE#########
;//////////DISPLAY GOODBYE MESSAGE////////////////////
	mov	edx,OFFSET	goodbye
	call WriteString
	call crlf


	exit	; exit to operating system
main ENDP

END main
