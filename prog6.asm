TITLE assingment 6     (prog6.asm)

; Author:Brandon Swanson  swansonb@onid.orst.edu
; Course / Project ID   CS271-400 Fall14 Programming Assignment #6  Date: 12/07/14

; Description: This program will test the useres ability to calculate the possible
;               Combinations of a given size from a given set, C(n,r), that is generated
;               Randomly.  It will check if their answer is correct and inform them of
;               the correct answer.


INCLUDE Irvine32.inc
INCLUDE Macros.inc

;////////////////MACROS//////////////////
;#################################################
;MACRO:    write string  
;
;Purpose:   display a string
;Recieves:  string variable
;Returns:   none
;
;#################################################
WriteStrM MACRO buffer
    push edx
    mov edx, OFFSET buffer
    call WriteString
    pop edx
ENDM

;////////////////PROGRAM CONSTANTS//////////////////
MIN   = 3    ;//range of n
MAX   = 12
YES   = 1
NO    = 0

.data
;//////////////STRINGS///////////////////////////////
intro_s         BYTE    "Welcome to Combinations Calculator",13,10
                BYTE    "Programmed by Brandon Swanson",13,10,0
about_s         BYTE    13,10,"This program will quiz you on combination problems"
                BYTE    13,10,"you will enter the number of possible choices and it"
                BYTE    13,10,"will let you know if you were correct",0
problems_s      BYTE    13,10,"Problem #",0
elements_s      BYTE    13,10,"Number of elements in the combinations: ",0
choices_s       BYTE    13,10,"Number of elements from wich to choose: ",0
answerPrompts_s BYTE    13,10,"How many ways can you choose: ",0
answerReveal_s  BYTE    13,10," elements can be chosen from "
answerReveal2_s BYTE    " elements in "
answerReveal3_s BYTE    " different ways",0
correct_s       BYTE    13,10,"Well Done!, you got the answer correct",0
wrong_s         BYTE    13,10,"It looks like you didn't get, better luck on the next one",0
again_s         BYTE    13,10,13,10,"Would you like another problem? (y/n): ",0


;//////////////////ERROR MESSAGES////////////////////
invalid_yn_s    BYTE    13,10,"Please limit your response to 'y' or 'n'",0
invalid_alpha_s BYTE    13,10,"Please limit your response numeric characters only",0
invalid_frac_s  BYTE    13,10,"The answer will always be a whole number",0
invalid_of_s    BYTE    13,10,"The number you entered is too large to store"
                BYTE    13,10,"     also too large to be the answer",0


.code
main PROC

    call Introduction
    
    
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
    
    WriteStrM intro_s
    WriteStrM about_s

    ret
Introduction ENDP

;#################################################
;PROCEDURE:    yes or no  
;
;Purpose:   recieve an afirmative or negative answer from user
;Recieves:   address in wich to store result
;            OFFSET of input prompt
;Returns:   places YES/NO constant in specified location
;
;#################################################
yesOrNo PROC
    push ebp
    mov ebp,esp ;set up stack frame

    push edx
    push eax
    push edi

    ;//output destination
    mov edi, [ebp+12]

prompt:
    mov edx, [ebp+8]
    call WriteString

    ;//get character and convert response to lower case
    call ReadChar
    or al, 20h 

    ;//check for answer (y/n)
    cmp al, 'y'
    je answer_y
    cmp al, 'n'
    je answer_n

    ;//invalid input
    WriteStrM invalid_yn_s
    jmp prompt

answer_y:
    mov DWORD PTR [edi], YES
    jmp return_yn

answer_n:
    mov DWORD PTR [edi], NO 

return_yn:
    pop edi
    pop eax
    pop edx

    pop ebp     ;restore callers stack frame
    Ret 8
yesOrNo ENDP

;#################################################
;PROCEDURE:    Factorial  
;
;Purpose:   calculate the factorial of a number
;Recieves:  the nuber to factorialize
;           address in wich to store result
;Returns:   places calculated value in recieved adress
;
;#################################################
factorial  PROC
    push ebp
    mov ebp,esp ;set up stack frame
    
    push eax
    push edx
    push edi

    ;//check for base case
    mov eax, [ebp+8]
    cmp eax, 1
    ja recursive

    ;///BASE CASE
    mov edi, [ebp+12]
	mov DWORD PTR [edi], 1
    jmp return_fact

recursive:
    ;reserve space for result and pass adress
    sub esp, 4
    push esp

    ;//pass recieved number -1
    push eax
    dec DWORD PTR [esp]

    call factorial

    ;//calculate and storeresult
    mul DWORD PTR [esp]
    mov edi, [ebp+12]
	mov DWORD PTR [edi], eax

    ;//free local variable
    add esp, 4
return_fact:
    pop edi
    pop edx
    pop eax
    
    pop ebp      ;restore callers stack frame
    Ret 8
factorial ENDP

END main
