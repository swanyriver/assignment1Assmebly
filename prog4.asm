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

    push num_primes      ;//passing argument N
    push OFFSET primes_a ;//passing adress of array
    call findPrimes      

    push num_primes      ;//passing argument N
    push OFFSET primes_a ;//passing adress of array
    call showPrimes

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
    push edx        ;///save callers register

    ;//print user welcome//
    mov edx, OFFSET intro_s
    call WriteString
    call crlf
    
    pop edx         ;//restore callers register
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
;Purpose:   search for user requested number of primes
;Recieves:  number of primes to find, adress of array
;Returns:   modifies array pointed to in second paramater
;#################################################
primes_array_p  EQU DWORD PTR [ebp+8]
num_primes_p    EQU DWORD PTR [ebp+12]
findPrimes PROC
    push ebp
    mov ebp,esp ;set up stack frame

    ;//first two primes defined check for less than 2 requested
    cmp num_primes_p, 2
    jng exit_without_calculations

    ;///save callers registers
    push edi
    push ecx
    push eax

    ;//////recieve passed paramaters and set up registers
    mov ecx, num_primes_p
    mov edi, primes_array_p

    ;///////set up eax, next_candidate
    mov eax, 3
    ;///////move array pointer to second index
    add edi, 4
    ;///////account for two primes already defined
    sub ecx, 2

    ;//outer loop, runs num_primes_p times
    n_primes:
    
        ;//innner loop, while next_candidate is not prime
        inc_candidate:
        add eax, 2   ;increment odd numbers only

        ;//pass paramaters
        push eax            ;next possible prime
        push edi            ;current location in array
        push primes_array_p ;begining of array
        call isPrime

        jnc inc_candidate   ;not prime

    ;///store found prime in array
    add edi, TYPE DWORD
    mov [edi], eax
    

    loop n_primes
    

    ;//restore callers registers
    pop eax
    pop ecx
    pop edi

exit_without_calculations:
    pop ebp     ;restore callers stack frame
    Ret 8
findPrimes ENDP

;#################################################
;PROCEDURE:      is prime
;
;Purpose:   determine if number (first paramater) is prime
;Recieves:  number to investigate
;           adress of last prime discovered in array
;           begingin address of discovered primes array
;Returns:   carry flag set if prime_candidate is prime
;
;#################################################
primes_array_p  EQU DWORD PTR [ebp+8]
last_prime_p    EQU DWORD PTR [ebp+12]
prime_candidate EQU DWORD PTR [ebp+16]

isPrime PROC
    push ebp
    mov ebp,esp ;set up stack frame

    ;///save callers registers
    push edi
    push edx
    push eax

    mov edi, primes_array_p ;array pointer

    check_for_factor:

    mov eax, prime_candidate
    mov edx, 0
    div DWORD PTR [edi]

    ;//if(remainder == 0) return false
    cmp edx, 0
    je return_false

    ;//if(edi == last_prime_p)   ;// like itterator.end()
    ;//return true, divided by all lower primes no factor found
    cmp edi, last_prime_p
    je return_true

    ;//else, current divisor not a factor, more prime factors remaining
    add edi, TYPE DWORD
    jmp check_for_factor


return_true:    
    stc
    jmp return

return_false:
    clc

return:
    ;//restore callers registers
    pop eax
    pop edx
    pop edi

    pop ebp     ;restore callers stack frame
    Ret  12
isPrime ENDP

;#################################################
;PROCEDURE:     display prime numbers
;
;Purpose:   display N Fibonacci numbers
;Recieves:  number of primes in array
;           beging address of DWORD array
;Returns:   none
;
; ebx conts output per line
;#################################################
primes_array_p  EQU DWORD PTR [ebp+8]
num_primes_p    EQU DWORD PTR [ebp+12]
showPrimes PROC

    push ebp
    mov ebp,esp ;set up stack frame

    ;///save callers registers
    push eax 
    push ebx 
    push ecx 
    push edi

    ;//pass paramaters
    push num_primes_p
    push primes_array_p
    call set_alignment

    ;//prime registers for use
    mov ecx, num_primes_p
    mov edi, primes_array_p

    mov ebx, PER_LINE    ;count terms per line

show_one_number:
    mov eax, [edi]      ;retrive next element in arry    
    call print_prime    ;output number with spacing

    dec ebx
    jz return_line      ;numbers per line reached
    jmp no_return_line  ;else

return_line:
    call crlf
    mov ebx, PER_LINE    ;reset numbers line count
no_return_line:
            
    add edi, TYPE DWORD ;increment array position
    LOOP show_one_number

    call crlf

    ;//restore callers registers
    pop edi
    pop ecx
    pop ebx
    pop eax


    pop ebp     ;restore callers stack frame
    ret 8
showPrimes ENDP

;#################################################
;PROCEDURE:     print prime
;               used by showPrimes
;
;Purpose:   display single alligneed Fibonacci number
;Recieves:  number in eax
;Returns:   none
;
;#################################################
print_prime PROC USES eax ebx ecx


    call count_digits   ;retrive number of digits in bl
    
    push eax
    mov al,' '          ;mov space to register used by WriteChar

    ;//pre-test loop, print bl - spaces needed
    jmp test_spaces
print_space:
    call WriteChar
    inc bl
test_spaces:
    cmp bl,spaces_needed
    jne print_space     ;print spaces until ready for next number

    pop eax
    call WriteDec       ;display number passed to EAX

    ;//put n number of spaces between displayed number
    mov al, ' '
    mov ecx, SPACING
    tabbing:
    call WriteChar
    LOOP tabbing


    ret
print_prime ENDP

;#################################################
;PROCEDURE:    set alignment
;              used by showPrimes
;Purpose:   adjust spaces_needed
;Recieves:  N number
;           beging address of DWORD array containing n terms
;Returns:   none
;
;#################################################
primes_array_p  EQU DWORD PTR [ebp+8]
num_primes_p    EQU DWORD PTR [ebp+12]
set_alignment PROC

    push ebp
    mov ebp,esp ;set up stack frame

    ;///save callers registers
    push eax 
    push ebx
    push edx 
    push edi

    ;//get last term in array
    mov eax, TYPE DWORD
    mov edi, primes_array_p
    dec num_primes_p
    mul num_primes_p
    add edi, eax 
    mov eax,[edi]           ;eax now contains primes_array[n] last element

    ;//find its length
    call count_digits       ;length of longest number in primes array
    
    ;//save as spaces needed    ;TODO make a return value
    mov spaces_needed,bl             

    ;//restore callers registers
    pop edi
    pop edx
    pop ebx
    pop eax


    pop ebp     ;restore callers stack frame
    ret 8
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
