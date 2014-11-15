TITLE assingment 5     (prog5.asm)

; Author:Brandon Swanson  swansonb@onid.orst.edu
; Course / Project ID   CS271-400 Fall14 Programming Assignment #5  Date: 11/23/14

; Description: This program will request a number of elements to randomly generate.
;              It will display these randomly generated elements and then sort these
;              these elements and display them again, along with their median value. 

INCLUDE Irvine32.inc
INCLUDE Macros.inc


;////////////////PROGRAM CONSTANTS//////////////////
MIN   = 10    ;//range of user input
MAX   = 200
LO    = 100   ;//range of random numbers 
HI    = 999
RANGE = HI-LO+1
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
unsorted_s      BYTE    "Unsorted Random Numbers:",13,10,0
sorted_s        BYTE    "Sorted Numbers:",13,10,0
median_s        BYTE    "The median is: ", 0


;/////////////ERROR STRINGS//////////////////////////
outOfRange_s    BYTE    "input out of range",13,10,0

;/////////////PROGRAM DATA/////////////////////////
array           WORD    MAX dup (?)
request         DWORD   ?



.code
main PROC

    call Randomize ;seed random generator

	call Introduction

    push OFFSET request
    call getUserData

    mDumpMem OFFSET request, 1, TYPE request 

    push request
    push OFFSET array
    call FillArray

    mDumpMem OFFSET array, LENGTHOF array, TYPE array 

	push OFFSET unsorted_s
	push request
    push OFFSET array
    call DisplayList
   
    
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


;#################################################
;PROCEDURE:      Fill Array   
;
;Purpose:   Fill array with request number of random values
;Recieves:  Adress of Array
;           number of values to genearate
;Returns:   modifies Array
;
;#################################################
;X_param EQU DWORD PTR [ebp+8]
;Y_param EQU DWORD PTR [ebp+12]

FillArray PROC
    push ebp
    mov ebp,esp ;set up stack frame

    ;//save callers registers
    push eax
    push ecx
    push edi


    ;//retrive paramaters
    mov ecx, [ebp+12]   ;num to generate
    mov edi, [ebp+8]    ;array adress

next_random:

    ;///generate random in range and adjust
    mov eax, RANGE
    call RandomRange
    add eax, LO
    
    ;//store result
    mov WORD PTR [edi], ax
    add edi, 2

    loop next_random


    ;//restore callers registers
    pop edi
    pop ecx
    pop eax

    pop ebp     ;restore callers stack frame
    Ret 8
FillArray ENDP


;#################################################
;PROCEDURE:  Display List    
;
;Purpose:   Output the contents of Array
;Recieves:  Adress of Array
;           number of values to genearate
;           Adress of string to display
;Returns:   none
;
;#################################################
DisplayList PROC
    push ebp
    mov ebp,esp ;set up stack frame

    ;//save callers registers
    push eax
    push ecx
    push esi
    push edx
    push ebx

    ;//retrive paramaters
    mov edx, [ebp+16]   ;adress of string
    mov ecx, [ebp+12]   ;num to generate
    mov esi, [ebp+8]    ;array adress

    ;//display title
    call WriteString

    mov ebx, PER_LINE

display_next_number:

    ;//display number
    movzx eax, WORD PTR [esi]
    call WriteDec

    ;//add spaces
    push ecx
    mov ecx, SPACING
    mov al, '-'
    space: call WriteChar
    loop space
    pop ecx

    dec ebx
    jz return_line      ;numbers per line reached
    jmp no_return_line  ;else

return_line:
    call crlf
    mov ebx, PER_LINE    ;reset numbers line count
no_return_line:

    add esi, 2

    loop display_next_number


    ;//restore callers registers
    pop ebx
    pop edx
    pop esi
    pop ecx
    pop eax

    pop ebp     ;restore callers stack frame
    Ret 12
DisplayList ENDP


END main
