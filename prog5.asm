TITLE assingment 5     (prog5.asm)

; Author:Brandon Swanson  swansonb@onid.orst.edu
; Course / Project ID   CS271-400 Fall14 Programming Assignment #5  Date: 11/23/14

; Description: This program will request a number of elements to randomly generate.
;              It will display these randomly generated elements and then sort these
;              these elements and display them again, along with their median value. 

INCLUDE Irvine32.inc
INCLUDE Macros.inc


;////////////////PROGRAM CONSTANTS//////////////////
MIN = 10    ;//range of user input
MAX = 200
HI  = 100   ;//range of random numbers 
LO  = 999
SPACING     = 3     ;minimum spaces between numbers
PER_LINE    = 10     ;number of terms to display per line


.data
;//////////////STRINGS///////////////////////////////
intro_s         BYTE    "Sorting Random Integers",13,10
                BYTE    "Programmed by Brandon Swanson",13,10,0
about_s         BYTE    13,10,"This program generates random numbers in the range ",0
about_s_line2   BYTE    13,10, "displays the original list, sorts the list, and calculates the"
                BYTE    13,10, "median value. Finally, it displays the list sorted in descending order."
                BYTE    13,10,13,10,0         
range_to_s      BYTE    " to ",0
mumPrompt_s     BYTE    "How many numbers should be generated? ",0


;/////////////ERROR STRINGS//////////////////////////
outOfRange_s    BYTE    "input out of range",13,10,0

;/////////////PROGRAM DATA/////////////////////////
array           WORD    MAX dup (?)
request         DWORD   ?



.code
main PROC
	
	call Introduction

    push OFFSET request
    call getUserData

    mDumpMem OFFSET request, 1, TYPE request 
    ;mDumpMem OFFSET primes_a, LENGTHOF primes_a, TYPE primes_a 
    
	exit	; exit to operating system
main ENDP

;#################################################
;PROCEDURE:      Introduction
;
;Purpose:   Display an introduction the the program
;Recieves:  none
;Returns:   none
;
;#################################################
 Introduction PROC
    ;///save callers registers
    push edx
    push eax

    ;////////////display programmer name
    mov edx, OFFSET intro_s
    call WriteString

    ;///display information about program
    mov edx, OFFSET about_s
    call WriteString

    ;///display range of random numbers
    mov eax, LO
    call WriteDec

    mov edx, OFFSET range_to_s
    call WriteString

    mov eax, HI
    call WriteDec

    mov edx, OFFSET about_s_line2
    call WriteString

    ;//restore callers registers
    pop eax
    pop edx

	ret

Introduction ENDP

;#################################################
;PROCEDURE:     get user data
;
;Purpose:   call input procedure to get num primes 
;           to be displayed
;Recieves:  refrence to request variable
;Returns:   value in refrenced variable
;
;#################################################
getUserData  PROC

    push ebp
    mov ebp,esp ;set up stack frame

    ;///save callers registers
    push edx
    push eax

input: 
    ;display input prompt with number
    mov edx, OFFSET mumPrompt_s
    call WriteString

    ;display range of input
    mov eax, MIN
    call WriteDec
    mov edx, OFFSET range_to_s
    call WriteString
    mov eax, MAX
    call WriteDec

    mov al, ':'
    call WriteChar
    mov al, " "
    call WriteChar


    ;///retrieve and validate input
    call ReadInt

    jo input            ;overflow indicated invalid input

    ;/////check input for range if(input>MAX || input<MIN)
    cmp eax, MAX
    jg outofBounds      ;input MAX

    cmp eax,MIN
    jl outofBounds    ;input<MIN

    ;//ELSE valid input
    jmp store_and_return

outofBounds:
    ;//display error message and input again
    mov edx, OFFSET outOfRange_s
    call WriteString

    jmp input

store_and_return:
    mov edx, [ebp+8]
    mov [edx], eax   

    ;//restore callers registers
    pop eax
    pop edx

	pop ebp
    ret 4
getUserData  ENDP



END main
