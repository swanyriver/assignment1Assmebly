TITLE assingment 6b     (prog6.asm)

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
;MACRO:    write dec
;
;Purpose:   display a number
;Recieves:  number variable
;Returns:   none
;
;#################################################
WriteDcM MACRO number
    push eax
    mov eax, number
    call writeDec
    pop eax
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

    WriteStrM correct_num_s
    WriteDcM correct
    WriteStrM outof_s
    writeDcM attempts
    WriteStrM questions_s

ENDM

;////////////////PROGRAM CONSTANTS//////////////////
MIN   = 3    ;//range of n
MAX   = 12
RANGE = MAX-MIN+1
YES   = 1
NO    = 0
BUFFER_SIZE = 16

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
answerReveal_s  BYTE    " elements can be chosen from ",0
answerReveal2_s BYTE    " elements in ",0
answerReveal3_s BYTE    " different ways",0
correct_s       BYTE    13,10,"Well Done!, you got the answer correct",0
wrong_s         BYTE    13,10,"It looks like you didn't get it right, better luck on the next one",0
correct_num_s   BYTE    13,10,"You have correctly answered ",0
outof_s         BYTE    " out of ",0
questions_s     BYTE    " questions",13,10,0
again_s         BYTE    13,10,13,10,"Would you like another problem? (y/n): ",0


;//////////////////ERROR MESSAGES////////////////////
invalid_yn_s    BYTE    13,10,"Please limit your response to 'y' or 'n'",0
invalid_alpha_s BYTE    13,10,"Please limit your response numeric characters only",0
invalid_frac_s  BYTE    13,10,"The answer will always be a whole number",0
invalid_neg_s  BYTE     13,10,"The answer will always be a posotive number",0
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
answer_local_op EQU DWORD PTR [ebp-12]
solution_local_op EQU DWORD PTR [ebp-16]
OneProblem PROC

    push ebp
    mov ebp,esp ;set up stack frame
    sub esp, 16  ;reserve space for local variables

    ;///store registers
    push eax

    ;//display problems and recive N and R
    push [ebp+8]
    lea eax, n_local_op
    push eax
    lea eax, r_local_op
    push eax
    call ShowProblem

    ;////get users answer
    lea eax, answer_local_op
    push eax
    call GetData

    ;// calculate number of combinations
    push n_local_op
    push r_local_op
    lea eax, solution_local_op
    push eax
    call Combinations

    ;///display solution and correctness
    push n_local_op
    push r_local_op
    push answer_local_op
    push solution_local_op
    call ShowAnswer

    ;//store users score
    mov eax, answer_local_op
    cmp eax, solution_local_op
    jne User_incorrect
    mov eax, [ebp+12]
    mov DWORD PTR [eax], YES
    jmp return_op
User_incorrect:
    mov eax, [ebp+12]
    mov DWORD PTR [eax], NO

return_op:
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

    ;//Generate, display, and save R
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
;PROCEDURE:    show answer  
;
;Purpose:   display the combination solution and if user is correct
;Recieves:  n,r,answer,solution (by value)
;Returns:   none
;
;#################################################
ShowAnswer PROC
    push ebp
    mov ebp,esp ;set up stack frame

    push eax

    ;//display answer
    writeDcM [ebp+16]
    WriteStrM answerReveal_s
    writeDcM [ebp+20]
    WriteStrM answerReveal2_s
    writeDcM [ebp+8]
    WriteStrM answerReveal3_s

    ;//display if user was correct
    mov eax, [ebp+12]
    cmp eax, [ebp+8]

    jne incorrect_answer
    WriteStrM correct_s
    jmp return_showAnswer

incorrect_answer:    
    WriteStrM wrong_s

return_showAnswer:
    pop eax

    pop ebp     ;restore callers stack frame
    Ret 16
ShowAnswer ENDP

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
;PROCEDURE:     get data 
;
;Purpose:   retrive an answer from the user
;Recieves:  adress to store input
;Returns:   users input converted to a number
;
;#################################################
size_input_local_gd EQU DWORD PTR [ebp-BUFFER_SIZE-4]
GetData PROC
    push ebp
    mov ebp,esp ;set up stack frame

    ;reserve space for input and locals
    sub esp, BUFFER_SIZE 
    sub esp, 4

    push eax
    push ecx
    push edx
    push edi
    push esi
    push ebx


answer_prompt:
    WriteStrM answerPrompts_s

    ;//recieve ascii input from user    
    lea edx, [ebp - BUFFER_SIZE]
    mov ecx, BUFFER_SIZE-1
    call ReadString


    ;//set up character inspection loop
    cld 
    lea esi, [ebp - BUFFER_SIZE]
    mov size_input_local_gd, eax
    mov ecx, eax

check_character:
    lodsb
    cmp al, '0'
    jl non_numeric
    cmp al, '9'
    ja non_numeric

    loop check_character

    ;//no invalid chars found converting to nuemeric
    ;//ebx will store next number, eax stores result
    mov ecx, size_input_local_gd
    lea esi, [ebp - BUFFER_SIZE]
    mov eax, 0
    mov edi, 10 ;//multiplier
next_numeral:
    movzx ebx, BYTE ptr [esi]
    inc esi

    and ebx, 0Fh ;//convert to numeral

    ;//shift current and add next digit
    mul edi
    jc input_overflow
    add eax, ebx
    jc input_overflow

    loop next_numeral

    ;//store result and exit
    mov edi, [ebp+8]
    mov [edi], eax
    jmp return_gd

;////////////////////ERROR CASES///////////
non_numeric:
    cmp al, '.'
    jne negative
    WriteStrM invalid_frac_s
    jmp answer_prompt

negative:
    cmp al,'-'
    jne alpha
    cmp ecx, size_input_local_gd
    jne alpha

    WriteStrM invalid_neg_s
    jmp answer_prompt

alpha:    
    WriteStrM invalid_alpha_s
    jmp answer_prompt

input_overflow:
    WriteStrM invalid_of_s
    jmp answer_prompt

return_gd:
    pop ebx
    pop esi
    pop edi
    pop edx
    pop ecx
    pop eax

    mov esp, ebp ;free local variables
    pop ebp      ;restore callers stack frame
    Ret 4
GetData ENDP

;#################################################
;PROCEDURE:      Combinations
;
;Purpose:   find solution to combination problem
;Recieves:  n, r, and adress for solution
;Returns:   n!/r!(n-r)!
;
;#################################################
nfact_local_cmb EQU DWORD PTR [ebp-4]
rfact_local_cmb EQU DWORD PTR [ebp-8]
nminrfact_local_cmb EQU DWORD PTR [ebp-12]
Combinations  PROC
    push ebp
    mov ebp,esp ;set up stack frame
    sub esp, 12

    push eax
    push edx
    push ebx

    ;//factorialize all variables///
    lea eax, nfact_local_cmb
    push eax
    push [ebp+16]
    call factorial

    lea eax, rfact_local_cmb
    push eax
    push [ebp+12]
    call factorial

    lea eax, nminrfact_local_cmb
    push eax
    mov eax, [ebp+16]
    sub eax, [ebp+12]
    push eax
    call factorial

    ;//calculate divisor r!(n-r)!
    mov eax, rfact_local_cmb
    mul nminrfact_local_cmb
    mov ebx, eax

    ;//peform n!/r!(n-r)!
    mov eax, nfact_local_cmb
    mov edx, 0
    div ebx

    mov edx, [ebp+8]
    mov [edx], eax

    pop ebx
    pop edx
    pop eax

    mov esp, ebp ;free local variables
    pop ebp      ;restore callers stack frame
    Ret 12
Combinations ENDP

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
