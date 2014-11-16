TITLE assingment 5     (prog5.asm)

; Author:Brandon Swanson  swansonb@onid.orst.edu
; Course / Project ID   CS271-400 Fall14 Programming Assignment #5  Date: 11/23/14

; Description: This program will request a number of elements to randomly generate.
;              It will display these randomly generated elements and then sort these
;              these elements and display them again, along with their median value. 

INCLUDE Irvine32.inc


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

    push request
    push OFFSET array
    call FillArray

	push OFFSET unsorted_s
	push request
    push OFFSET array
    call DisplayList

    push request
    push OFFSET array
    call Merge_Sort

    push request
    push OFFSET array
    call DisplayMedian

    push OFFSET sorted_s
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
;           number of values in array
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
    mov ecx, [ebp+12]   ;num values requested
    mov esi, [ebp+8]    ;array adress

    ;//display title
    call crlf
    call WriteString

    mov ebx, PER_LINE

display_next_number:

    ;//display number
    movzx eax, WORD PTR [esi]
    call WriteDec

    ;//add spaces
    push ecx
    mov ecx, SPACING
    mov al, ' '
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

;#################################################
;PROCEDURE:      Display Median
;
;Purpose:   find or calculate and display median 
;Recieves:  Adress of Array
;           number of values in array
;Returns:   none
;
;#################################################
DisplayMedian PROC
    push ebp
    mov ebp,esp ;set up stack frame

    ;//save callers registers
    push eax
    push ecx
    push edx
    push esi

    ;//retrive paramaters
    mov ecx, [ebp+12]   ;num values requested
    mov esi, [ebp+8]    ;array adress

    call crlf
    mov edx, OFFSET median_s
    call WriteString


    ;////////////MEDIAN ALGORITHM////////////////////////////
    ;// as the array is made up of 2 byte WORDs the 
    ;// array adress + request (num elements in the array)
    ;// will be pointing to
    ;// ODD NUM ELEMENTS:   median adress + 1 BYTE
    ;// EVEN NUM ELEMENTS:  first element of second half
    ;// BTR is used to test and clear least signifigant bit
    ;////////////////////////////////////////////////////////

    ;///find median/////
    btr ecx, 0
    jc odd_num_elements

    ;//average two middle elements
    movzx eax, WORD PTR [esi + ecx ]
    add ax, WORD PTR [esi + ecx - TYPE WORD]
    shr eax, 1  ;div by 2 to find average
    jc round_up ;carry bit indicates result of xx.5
    jmp display_result

round_up:
    inc eax
    jmp display_result

odd_num_elements:
    movzx eax, WORD PTR [esi + ecx ]

display_result:
    call WriteDec
    call crlf

    ;//restore callers registers
    pop esi
    pop edx
    pop ecx
    pop eax

    pop ebp     ;restore callers stack frame
    Ret
DisplayMedian ENDP

;//////////////////////////////////////////////////////////////////////
;/////////////MERGE SORT FUNCTIONS/////////////////////////////////////
;//////////////////////////////////////////////////////////////////////
;#################################################
;PROCEDURE:      Merge Sort
;
;Purpose:   Recursivly sort an array of unsigned WORD integers
;Recieves:  adress of array
;           num elements in array
;Returns:   none
;
;#################################################
Merge_Sort PROC
    push ebp
    mov ebp,esp ;set up stack frame
    
    ;//save callers registers
    push edi
    push esi
    push edx
    push ecx
    push eax
    push ebx

    ;//////base cases////////////////
    mov dx, [ebp+12]
    ;//if only one element return
    cmp dx, 1
    je base_case_return

    ;//if onlt 2 elements exchange and return
    cmp dx, 2
    jne recursive_case

    mov esi, DWORD PTR [ebp+8]
    push esi
    add esi, TYPE WORD
	push esi
    call exchange

    jmp base_case_return

recursive_case:
    ;create and fill temporary array
	sub esp, DWORD PTR [ebp+12]
    sub esp, DWORD PTR [ebp+12]
    mov esi, DWORD PTR [ebp+8]
    mov edi, esp

    mov ecx, DWORD PTR [ebp+12]
    rep movsw


    ;//LEFT Sort
    mov esi, esp
    mov edx, DWORD PTR [ebp+12]
    shr edx, 1
    push edx
    push esi
    call Merge_Sort


    ;//RIGHT Sort
    mov ecx, DWORD PTR [ebp+12]
    and ecx, 0FFFFFFFEh              ;//clear LSB
    add ecx, esp

    mov edx, DWORD PTR [ebp+12]
    shr edx, 1
    jc odd_num
    jmp even_num
odd_num:    
    inc edx
even_num:
    push edx
    push ecx
    call Merge_Sort


    ;///merge sorted lists
    ;//ecx points to mid list and will serve as sentinal for left
    ;//edx will serve as alternate source pointer from right list
    ;//eax will serve as sentinal for right list
    mov eax, edi ;//currently pointing at just after list end
    mov edx, ecx
    mov esi, esp 
    mov edi, DWORD PTR [ebp+8]

merge_next:
    cmp esi, ecx
    je finish_right_list

    cmp edx, eax
    je finish_left_list

    mov bx, word ptr [esi]
    cmp bx, [edx]

    ja add_from_left

add_from_right:
    mov bx, WORD PTR [edx]
	mov WORD PTR [edi], bx
    add edx, TYPE WORD
    jmp increment_destination

add_from_left:
    mov bx, WORD PTR [esi]
	mov WORD PTR [edi], bx
    add esi, TYPE WORD

increment_destination:
    add edi, TYPE WORD
    jmp merge_next

finish_right_list:
    cmp edx, eax
    je return
    mov bx, WORD PTR [edx]
    mov WORD PTR [edi], bx
    add edx, TYPE WORD
    add edi, TYPE WORD
    jmp finish_right_list

finish_left_list:    
    cmp esi, ecx
    je return
    movsw
    jmp finish_left_list

return:    
	
    add esp, DWORD PTR [ebp+12]	   ;free temporary array
    add esp, DWORD PTR [ebp+12]


base_case_return:
    ;//restore callers registers
    pop ebx
    pop eax
    pop ecx
    pop edx
    pop esi
    pop edi

    pop ebp      ;restore callers stack frame
    
    ret 8
Merge_Sort ENDP

;#################################################
;PROCEDURE:      exchange
;
;Purpose:   to exchange two array items
;Recieves:  the adress of two WORD values
;Returns:   swaps these valus
;
;#################################################
exchange PROC
    push ebp
    mov ebp,esp ;set up stack frame

    push eax
    push ebx
    push esi
    push edi

    mov esi, DWORD PTR [ebp + 8]
    mov edi, DWORD PTR [ebp + 12]

    movzx eax, WORD PTR [esi]
    movzx ebx, WORD PTR [edi]

    cmp ax,bx
    jb return_without_exchange

    mov [esi], bx
    mov [edi], ax

return_without_exchange:

    pop edi
    pop esi
    pop ebx
    pop eax

    pop ebp     ;restore callers stack frame
    Ret 8
exchange ENDP

END main
