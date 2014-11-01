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

UPPER_BOUND = 200    ;input must be less than or equal this

.data

;//////////////STRINGS///////////////////////////////
intro_s         BYTE    "Prime Number Finder",13,10
                BYTE    "Programed by Brandon Swanson",13,10,0
instruction_s   BYTE    13,10,"Please enter the number of primes you would like to see displayed"
                BYTE    13,10,"greater than 0 and less than or equal to ",0
mumPrompt_s     BYTE    13,10,"Number of primes desired: ",0
farewell_s      BYTE    13,10,"Thank you for using my Prime Finder",0


;/////////////ERROR STRINGS//////////////////////////
outOfRange_s    BYTE    "please keep your input greater than 0 and less than or equal to ",0 ;constant appended

;/////////////USER INPUT VARIABLES//////////////////
num_primes      DWORD    ?

;/////////////PROGRAM DATA/////////////////////////
primes_a        DWORD   UPPER_BOUND dup (?)


.code
main PROC

    call introduction   ;identify program

    call getUserData    ;how many primes?
    mov num_primes, eax ;store input



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

END main