TITLE assingment 6     (prog6.asm)

; Author:Brandon Swanson  swansonb@onid.orst.edu
; Course / Project ID   CS271-400 Fall14 Programming Assignment #6  Date: 12/07/14

; Description: This program will 


INCLUDE Irvine32.inc
INCLUDE Macros.inc

; (insert constant definitions here)

.data

result DWORD ?
colon_s byte "! = ",0     

.code
main PROC

    mov ecx, 12
top:
    push OFFSET result
    push ecx

    call factorial

    mov eax, ecx
    call writedec

    mwritestring OFFSET colon_s

    mov eax, result
    call writedec
    call crlf

    loop top



	exit	; exit to operating system
main ENDP

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
    jmp return

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
return:
    pop edi
    pop edx
    pop eax
    
    pop ebp      ;restore callers stack frame
    Ret 8
factorial ENDP

END main
