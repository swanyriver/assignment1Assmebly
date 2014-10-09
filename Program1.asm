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
instruction BYTE "This Program will perform a series of opperations on the numbers entered and output the result",0
input_Lhs	BYTE "Please enter the left-hand-side value (non-negative integer): ",0
input_Rhs	BYTE "Please enter the right-hand-side value (positive integer): ",0
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
sDiv		BYTE  " / ",0
sEqu		BYTE  " = ",0
sRemain		BYTE "  With a remainder of: ",0

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



															;######GOODBYE MESSAGE#########
;//////////DISPLAY GOODBYE MESSAGE////////////////////
	mov	edx,OFFSET	goodbye
	call WriteString
	call crlf


	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
