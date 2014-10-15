TITLE Program Template     (template.asm)

; Author:Brandon Swanson
; Course / Project ID                 Date:
; Description:

INCLUDE Irvine32.inc

;////////////////PROGRAM CONSTANTS//////////////////
LOWER_BOUND = 0		;input must be greater than this
UPPER_BOUND = 47	;input must be less than this
STRING_MAX	= 40	;maximum length of user input strings

.data

;//////////////STRINGS///////////////////////////////
intro_s			BYTE	"Fibonacci Numbers",13,10
				BYTE	"Programed by Brandon Swanson",13,10,0
namePrompt_s	BYTE	"What is your name",0
welcome_s		BYTE	"Welcome to Fibonacci Numbers ",13,10,0
instruction_s	BYTE	"You will enter the number of Fibonacci terms you would like displayed",13,10
				BYTE	"Enter a whole number between 1 and 46 inclusive",13,10,13,10,0
mumPrompt_s		BYTE	"How many terms would you like to see: ",0
farewell_s		BYTE	"Thank you for using my program" ,13,10
				BYTE	"Brandon",13,10,0

;/////////////USER INPUT VARIABLES//////////////////
user_name		BYTE	STRING_MAX dup(?)
n_terms			BYTE	?

;////////////PROGRAM INFORMATION///////////////////

;todo VARIABLES for Fibonacci number

.code
main PROC
	mov edx, OFFSET intro_s
	call WriteString

	exit	; exit to operating system
main ENDP



;PROC Intro
	
	
;	ret
;Intro ENDP


END main
