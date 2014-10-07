TITLE Programming Assignment #1     (Program1.asm)

; Author:Brandon Swanson
; Course / Project ID:  Programming Assignment #1    Date:10/6/14
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
symbols		BYTE "+-*/",0
input_Lhs	BYTE "Please enter the left-hand-side value (non-negative integer): ",0
input_Rhs	BYTE "Please enter the right-hand-side value (positive integer): ",0
goodbye		BYTE "Thank you, have a nice day",0

;///////////////////////////INPUT VARIABLES///////////////////////////////
Lhs			DWORD 0 ;LEFT HAND SIDE ARGUMENT
Rhs			DWORD 0 ;RIGHT HAND SIDE ARGUMENT

;//////////////////////////OPERATION RESULTS/////////////////////////////////
mSum		DWORD 0
mDiff		DWORD 0
mProduct	DWORD 0
mQuotient	DWORD 0
mRemainder	DWORD 0


;##########################################################################################
;################ PROCEDURE: MAIN  ########################################################
;##########################################################################################

.code
main PROC

;/////////////////////////////////////////////////////
;//////////////////INTRO PROGRAM//////////////////////
	mov	edx,OFFSET	my_name
	call WriteString
	call crlf

	mov	edx,OFFSET	instruction
	call WriteString
	call crlf

;////////////PROMPT INPUT//// LHS ////////////////////
	mov	edx,OFFSET	input_Lhs
	call WriteString
	call crlf


;///////////RETRIEVE INPUT/// LHS ////////////////////
;////////////PROMPT INPUT//// RHS ////////////////////
	mov	edx,OFFSET	input_Rhs
	call WriteString
	call crlf
;///////////RETRIEVE INPUT/// RHS ////////////////////
;//////////CALCULATE SUM //// LHS + RHS///////////////
;//////////STORE RESULT///////////////////////////////
;//////////CALCULATE DIFF// LHS - RHS ////////////////
;//////////STORE RESULT///////////////////////////////
;//////////CALCULATE PROUDUC// LHS * RHS /////////////
;//////////STORE RESULT///////////////////////////////
;//////////CALCULATE PROUDUC// LHS * RHS /////////////
;//////////STORE RESULT///////////////////////////////
;//////////DISPLAY RESULTS////////////////////////////
	mov eax, lhs
	call WriteInt
	mov al, ' '
	call WriteChar
	mov al, '+'
	call Writechar
	mov al, ' '
	call WriteChar
	mov eax, lhs
	call WriteInt
	mov al, ' '
	call WriteChar
	mov al, '='
	call WriteChar
	mov eax, mSum
	call WriteInt

;//////////DISPLAY GOODBYE MESSAGE////////////////////
	mov	edx,OFFSET	goodbye
	call WriteString
	call crlf


	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
