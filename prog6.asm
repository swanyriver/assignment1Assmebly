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
WriteStrM MACRO str
    push edx
    mov edx, OFFSET str
    call WriteString
    pop edx
ENDM

;#################################################
;MACRO:    show score 
;
;Purpose:   display correct vs attempts
;Recieves:  #correct, #attempts
;Returns:   none
;
;#################################################
ShowScoreM MACRO correct, attempts
    push edx
    push eax

    mov edx, OFFSET correct_num_s
    call WriteString

    mov eax, correct
    call writeDec
    ;//second paramater may be eax, restored and saved again
    pop eax
    push eax

    mov edx, OFFSET outof_s
    call WriteString

    mov eax, attempts
    call writeDec

    mov edx, OFFSET questions_s
    call WriteString

    pop eax
    pop edx
ENDM

;////////////////PROGRAM CONSTANTS//////////////////
MIN   = 3    ;//range of n
MAX   = 12
RANGE = MAX-MIN+1
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
correct_num_s   BYTE    13,10,"You have correctly answered ",0
outof_s         BYTE    " out of ",0
questions_s     BYTE    " questions",13,10,0
again_s         BYTE    13,10,13,10,"Would you like another problem? (y/n): ",0


;//////////////////ERROR MESSAGES////////////////////
invalid_yn_s    BYTE    13,10,"Please limit your response to 'y' or 'n'",0
invalid_alpha_s BYTE    13,10,"Please limit your response numeric characters only",0
invalid_frac_s  BYTE    13,10,"The answer will always be a whole number",0
invalid_of_s    BYTE    13,10,"The number you entered is too large to store"
                BYTE    13,10,"     also too large to be the answer",0


.code
main PROC
    push ebp
    mov ebp,esp ;set up stack frame
    sub esp, 12  ;reserve space for local variables

    ;///store registers
    push eax
    push ecx
    push ebx

    call randomize
    call Introduction

restart:
    mov eax, 0  ;//will store num problems
    mov ecx, 0  ;//will store num correct problems

next_question:
    sub esp, 4
    push esp
    inc eax
    push eax
    call OneProblem

    ;//record and display score
    add ecx, [esp]
    add esp, 4
    ShowScoreM ecx, eax

    ;//check if user wants another question
    sub esp, 4
    push esp
    push OFFSET again_s
    call yesOrNo
    pop ebx
    cmp ebx, YES
    je next_question



    ;///restore registers 
    pop ebx
    pop ecx
    pop eax

    mov esp, ebp ;free local variables
    pop ebp      ;restore callers stack frame
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
;PROCEDURE:      one problem
;
;Purpose:   quiz the user on one problem
;Recieves:  number of problems so far 
;           adress to store student result (correct/incorrect)
;Returns:   y/n correct answer
;
;#################################################
n_local_op EQU DWORD PTR [ebp-4]
r_local_op EQU DWORD PTR [ebp-8]
OneProblem PROC

    push ebp
    mov ebp,esp ;set up stack frame
    sub esp, 8  ;reserve space for local variables

    ;///store registers
    push eax

    push [ebp+8]
    lea eax, n_local_op
    push eax
    lea eax, r_local_op
    push eax
    call ShowProblem

    ;////call GET DATA

    ;// call COMBINATIONS

    ;/// call SHOW ANSWER 


    ;///restore registers 
    pop eax

    mov esp, ebp ;free local variables
    pop ebp      ;restore callers stack frame
    Ret 8
OneProblem ENDP

;#################################################
;PROCEDURE:    show problem  
;
;Purpose:   Generate and display a combinations problem
;Recieves:  number of problem
;           adress of R result
;           adress of N result
;Returns:   places random n and r in appropriate memory
;
;#################################################
ShowProblem PROC
    push ebp
    mov ebp,esp ;set up stack frame

    push eax
    push edi

    WriteStrM problems_s
    mov eax, [ebp+16]
    call writeDec
    
    ;//Generate, display, and save N
    mov eax, RANGE
    call RandomRange
    add eax, MIN
    mov edi, [ebp+12]
    mov DWORD PTR [edi], eax
    WriteStrM choices_s
    call writeDec

    call RandomRange
    add eax, 1
    mov edi, [ebp+8]
    mov DWORD PTR [edi], eax
    WriteStrM elements_s
    call writeDec


    pop edi
    pop eax

    pop ebp     ;restore callers stack frame
    Ret 12
ShowProblem ENDP

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
