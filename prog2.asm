TITLE Program Template     (template.asm)

; Author:Brandon Swanson
; Course / Project ID                 Date:
; Description:

INCLUDE Irvine32.inc

;////////////////PROGRAM CONSTANTS//////////////////
LOWER_BOUND = 1     ;input must be greater than or equal to this
UPPER_BOUND = 46    ;input must be less than or equal this
STRING_MAX  = 40    ;maximum length of user input strings

.data

;//////////////STRINGS///////////////////////////////
intro_s         BYTE    "Fibonacci Numbers",13,10
                BYTE    "Programed by Brandon Swanson",13,10,0
namePrompt_s    BYTE    "What is your name: ",0
instruction_s   BYTE    13,10,"You will enter the number of Fibonacci terms you would like displayed",13,10
                BYTE    "Enter a whole number between 1 and 46 inclusive",13,10,13,10,0
mumPrompt_s     BYTE    13,10,"How many terms would you like to see: ",0
farewell_s      BYTE    13,10,"Thank you for using my program" ,13,10
                BYTE    "-Brandon",13,10,0

;/////////////ERROR STRINGS//////////////////////////
noNameEntered   BYTE    "nothing was entered, please try again",13,10,0
outOfRange_s    BYTE    "please keep your input greater than 0 and less than 47",13,10,0


;/////////////USER INPUT VARIABLES//////////////////
welcome_s       BYTE    13,10,"Welcome to Fibonacci Numbers "     
                ;user name will become concatenated with welcome string
userName        BYTE    STRING_MAX+1 dup (?)
nTerms          BYTE    ?

;////////////PROGRAM INFORMATION///////////////////

fibTemrs        DWORD   1,1, 44 dup (?)


.code
main PROC

    call Intro

    call userInstructions

    call getUserData
    mov nTerms, al     ;save result


    ;#############displayFibs#######    ;divided into two procedures
    movzx ecx, nTerms
    mov edx, OFFSET fibTemrs
    call calculate_fibs


    exit    ; exit to operating system
main ENDP



;#################################################
;PROCEDURE:     Intro
;
;Purpose:   print introduction and get user's name
;Recieves:  none
;Returns:   Users name stored in userName buffer
;
;#################################################
Intro PROC USES edx eax ecx
    
    ;//print intro string//
    mov edx, OFFSET intro_s
    call WriteString

    ;//print name input prompt//
    mov edx, OFFSET namePrompt_s
    call WriteString

getName:
    ;//get user name//
    mov edx, OFFSET userName
    mov ecx, STRING_MAX
    call ReadString

    ;//verify input//
    test eax,eax
    je noInput      ;if(eax==0) no string entered
    jmp Welcome     ;else continue program

noInput:
    ;//print error msg//
    mov edx, OFFSET noNameEntered
    call WriteString

    jmp getName

welcome:
    ;//print user welcome//
    mov edx, OFFSET welcome_s
    call WriteString
    call crlf
    
    
    ret
Intro ENDP



;#################################################
;PROCEDURE:     Instructions 
;
;Purpose:   print instructions for user
;Recieves:  none
;Returns:   none
;
;#################################################
userInstructions PROC USES edx
    
    ;//display instructions//
    mov edx, OFFSET instruction_s
    call WriteString

    ret
userInstructions ENDP 

;#################################################
;PROCEDURE:     getUserData 
;
;Purpose:   get the number of Fibonacci numbers to display
;Recieves:  none
;Returns:   number to be displayed in EAX
;
;#################################################
getUserData PROC USES edx
  
get_input:   
    ;//display prompt//
    mov edx, OFFSET mumPrompt_s
    call WriteString


    ;//get number from keyboard//
    call ReadDec

    ;//validate input//
	test eax,eax
    jz  bad_input   ; eax==0  alpha input, negative, blank or >2^32-1
    
    cmp eax,UPPER_BOUND 
    ja  bad_input   ; eax > UPPER_BOUND (46)

    ;//valid input in eax, exit PROCEDURE
    ret

bad_input:
    ;//print error message//
    mov edx, OFFSET outOfRange_s
    call WriteString

    ;//input again
    jmp get_input
    

    
getUserData ENDP 


;#################################################
;PROCEDURE:     calculate fibs 
;
;Purpose:   finds N Fibonacci numbers
;Recieves:  N number in ecx
;           beging address of DWORD array in edx
;Returns:   n numbers of fib terms in array pointed to by edx
;
;#################################################
calculate_fibs PROC
    
    push edx ;for test
    push ecx ;for test


find_fib:
    mov [edx],ecx
    add edx, TYPE DWORD
    LOOP find_fib

    pop ecx
    pop edx

    mov esi, edx
    mov ebx, TYPE DWORD
    call dumpMem

    ret
calculate_fibs ENDP

END main
