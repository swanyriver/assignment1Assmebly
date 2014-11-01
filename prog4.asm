TITLE assingment 4     (prog4.asm)

; Author:Brandon Swanson  swansonb@onid.orst.edu
; Course / Project ID   CS271-400 Fall14 Programming Assignment #4  Date: 11/09/14

; Description: This program will request the desired number of primes to be displayed,
;              within the defined UPPER_BOUND constant (200)
;              It will calculate N primes by dividing each number in squence K
;              by previously discovered primes, a remainder of 0 indicates a composite number.

; extra credit: Using prime divisors stored in an array
;               allighned output collumns
;               display more primes on sepearate pages

INCLUDE Irvine32.inc

;////////////////PROGRAM CONSTANTS//////////////////
UPPER_BOUND = 200    ;input must be less than or equal this
SPACING     = 3     ;minimum spaces between numbers
PER_LINE    = 10     ;number of terms to display per line

.data

;//////////////STRINGS///////////////////////////////
intro_s         BYTE    "Prime Number Finder",13,10
                BYTE    "Programed by Brandon Swanson",13,10,0
instruction_s   BYTE    13,10,"Please enter the number of primes you would like to see displayed"
                BYTE    13,10,"greater than 0 and less than or equal to ",0
mumPrompt_s     BYTE    13,10,"Number of primes desired: ",0
farewell_s      BYTE    13,10,"Thank you for using my Prime Finder",13,10,13,10,0


;/////////////ERROR STRINGS//////////////////////////
outOfRange_s    BYTE    "please keep your input greater than 0 and less than or equal to ",0 ;constant appended

;/////////////USER INPUT VARIABLES//////////////////
num_primes      DWORD    ?

;/////////////PROGRAM DATA/////////////////////////
primes_a        DWORD   2,3, UPPER_BOUND-2 dup (?)

;///////////////////USED FOR ALIGNMENT////////////
spaces_needed   BYTE    ? ;calculated each time as longest numbers digits + SPACING


.code
main PROC

    call introduction   ;identify program

    call getUserData    ;how many primes?
    mov num_primes, eax ;store input

    call findPrimes

    ;mDumpMem OFFSET primes_a, LENGTHOF primes_a, TYPE primes_a 


    call farewell

	exit	; exit to operating system
main ENDP

;#################################################
;PROCEDURE:     Intro
;
;Purpose:   print introduction 
;Recieves:  none
;Returns:   none
;
;#################################################
introduction PROC
    push edx

    ;//print user welcome//
    mov edx, OFFSET intro_s
    call WriteString
    call crlf
    
    pop edx
    ret
introduction ENDP

;#################################################
;PROCEDURE:     get user data
;
;Purpose:   call input procedure to get num primes 
;           to be displayed
;Recieves:  none
;Returns:   value in eax
;
;#################################################
getUserData  PROC

    push edx

    ;// display instructions
    mov edx, OFFSET instruction_s
    call WriteString

    ;//display UPPER_BOUND
    mov eax, UPPER_BOUND
    call WriteDec
    call crlf


input: 
    ;display input prompt with number
    mov edx, OFFSET mumPrompt_s
    call WriteString

    call ReadInt

    jo input            ;overflow indicated invalid input

    call validate       ;validate input

    jc input            ;out of bounds indicated by validate

    pop edx

    ret                 ;input is valid and less than UPPER_BOUND retruning
getUserData  ENDP

;#################################################
;PROCEDURE:     validate    
;
;Purpose:   check that input is in range [1-UPPER BOUND]
;Recieves:  value in eax
;Returns:   carry flag set if input out-of-bounds
;
;#################################################
validate PROC
    
    cmp eax, UPPER_BOUND
    jg outofBounds      ;input>UPPER_BOUND

    cmp eax,1
    jl outofBounds    ;input<1

    ;//clear cary flag and return normal
    clc
    ret


outofBounds:
    push edx
    push eax

    ;//load error message and UPPER_BOUND value
    mov edx, OFFSET outOfRange_s
    mov eax, UPPER_BOUND
    ;/display message and UPPER_BOUND
    call WriteString
    call WriteDec
    call crlf
    
    pop eax
    pop edx

    ;//set carry flag indicating out of bounds
    stc
    Ret
validate ENDP

;#################################################
;PROCEDURE:     find prime numbers   
;
;Purpose:   
;Recieves:  none
;Returns:   none
;
;#################################################
findPrimes PROC
    push ebp
    mov ebp,esp ;set up stack frame

    mov ecx,num_primes      ;TODO pass as stack
    mov eax, 1
    mov ebx, OFFSET primes_a    ;TODO pass as stack

    loop_top:

    mov [ebx], eax
    inc eax

    loop loop_top



    pop ebp     ;restore callers stack frame
    Ret
findPrimes ENDP

;#################################################
;PROCEDURE:     display prime numbers
;
;Purpose:   display N Fibonacci numbers
;Recieves:  N number in ecx
;           beging address of DWORD array in edx containing n terms
;Returns:   none
;
; ebx conts output per line
;#################################################
showPrimes PROC USES eax ebx ecx edx

    call set_alignment

    mov ebx, PER_LINE    ;count terms per line

show_one_number:
    mov eax, [edx]      ;retrive next element in arry    
    call print_prime    ;output number with spacing

    dec ebx
    jz return_line      ;numbers per line reached
    jmp no_return_line  ;else

return_line:
    call crlf
    mov ebx, PER_LINE    ;reset numbers line count
no_return_line:
            
    add edx, TYPE DWORD ;increment array position
    LOOP show_one_number

    call crlf
    ret
showPrimes ENDP

;#################################################
;PROCEDURE:     print fib
;               used by displayFibs
;
;Purpose:   display single alligneed Fibonacci number
;Recieves:  number in eax
;Returns:   none
;
;#################################################
print_prime PROC USES eax ebx

    call WriteDec       ;display number passed to EAX

    call count_digits   ;retrive number of digits in bl
    
    mov al,' '          ;mov space to register used by WriteChar
print_space:
    call WriteChar
    inc bl
    cmp bl,spaces_needed
    jne print_space     ;print spaces until ready for next number


    ret
print_prime ENDP

;#################################################
;PROCEDURE:    set alignment
;              used by display_fibs
;Purpose:   adjust number of spaces in spaces_s
;Recieves:  N number in ecx
;           beging address of DWORD array in edx containing n terms
;Returns:   none
;
;#################################################
set_alignment PROC USES eax ebx ecx edx

    ;//get last term in array
    mov eax, TYPE DWORD
    dec ecx
    push edx
    mul ecx
    pop edx
    add edx, eax 
    mov eax,[edx]           ;eax now contains edx[n] last element

    ;//find its length
    call count_digits       ;length of longest number in ebx

    ;//add 5 spaces
    add bl,SPACING
    
    ;//save as spaces needed
    mov spaces_needed,bl                

    ret
set_alignment ENDP


;#################################################
;PROCEDURE:     count digits
;               used by print_fib
;               used by set_alignment
;
;Purpose:   determine number of digits in a number
;Recieves:  number in eax
;Returns:   number of digits in bl
;
;#################################################
count_digits PROC USES ecx eax edx

    mov bl, 1
    mov ecx,10  ;divisor
reduce_number:              ;divides by 10 until number is single digit
    cmp eax,9
    jna all_digits_counted

    mov edx,0
    div ecx

    inc bl ;one more digit

    jmp reduce_number

all_digits_counted:

    ret
count_digits ENDP   

;#################################################
;PROCEDURE:    farewell
;
;Purpose:   print a farewell message
;Recieves:  none
;Returns:   none
;
;#################################################
farewell PROC USES edx
    
    mov edx,OFFSET farewell_s
    call WriteString

    ret
farewell ENDP

END main