TITLE assingment 3     (prog3.asm)

; Author:Brandon Swanson  swansonb@onid.orst.edu
; Course / Project ID   CS271-400 Fall14 Programming Assignment #3  Date: 11/02/14
; Description: this program will repeatdly ask the user to enter numbers below the defined 
;               UPPER_BOUND until a negative is entered at wich time the sum and average will be displayed

INCLUDE Irvine32.inc

;////////////////PROGRAM CONSTANTS//////////////////
UPPER_BOUND = 100    ;input must be less than or equal this
STRING_MAX  = 40    ;maximum length of user input strings

.data

;//////////////STRINGS///////////////////////////////
intro_s         BYTE    "The Acumulator",13,10
                BYTE    "Programed by Brandon Swanson",13,10,0
namePrompt_s    BYTE    "What is your name: ",0
instruction_s   BYTE    13,10,"Please enter numbers less than or equal to ",0
instruction2_s  BYTE    13,10, "Enter a negative number to signal that you are finished",13,10,13,10,0
mumPrompt_s     BYTE    "number ",0
farewell_s      BYTE    13,10,"Thank you for using my program" ,13,10
                BYTE    "-Brandon",13,10,0
again           BYTE    13,10,"Would you like to perform these operations again?",13,10,0
yesNo           BYTE    "press 'y' for yes, any other key will exit",13,10,0


;/////////////ERROR STRINGS//////////////////////////
noNameEntered   BYTE    "nothing was entered, please try again",13,10,0
outOfRange_s    BYTE    "please keep your input less than or equal to ",0 ;constant appended


;/////////////USER INPUT VARIABLES//////////////////
welcome_s       BYTE    13,10,"Welcome to The Acumulator "     
                ;user name will become concatenated with welcome string
userName        BYTE    STRING_MAX+1 dup (?)
nTerms          BYTE    ?

;///////////////////////CONTROL VARIABLE//////////
affirm          BYTE    'y'


.code
main PROC

    call Intro

    call userInstructions

get_numbers:



    call check_repeat           ;sets zero flag if use wants to repeat
    je get_numbers                    ;return to getUserData

    call farewell


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
    
    ;//display instructions line 1//
    mov edx, OFFSET instruction_s
    call WriteString

    ;//display UPPER_BOUND
    mov eax, UPPER_BOUND
    call WriteDec

    ;//display instructions about negatgive termination//
    mov edx, OFFSET instruction2_s
    call WriteString

    ret
userInstructions ENDP 

;#################################################
;PROCEDURE:     get next number
;
;Purpose:   call input procedure and verify
;               -in bounds
;               -valid input
;Recieves:  none
;Returns:   value in eax
;
;#################################################
getNextNum  PROC USES edx

; do{ call readint } while(invalid || above UPPER_BOUND)
jmp input
outofBounds:
    ;//load error message and UPPER_BOUND value
    mov edx, OFFSET outOfRange_s
    mov eax, UPPER_BOUND
    ;/display message and UPPER_BOUND
    call WriteString
    call WriteDec
    call crlf

input:    
    call ReadInt

    jo input            ;overflow indicated invalid input

    cmp eax, UPPER_BOUND
    jg outofBounds      ;input>UPPER_BOUND

    ret                 ;input is valid and less than UPPER_BOUND retruning
getNextNum  ENDP

;#################################################
;PROCEDURE:     check for repeat
;
;Purpose:   ask user if they would like to repeat
;Recieves:  none
;Returns:   zero flag set if affirmative
;
;#################################################
check_repeat PROC USES edx eax

    mov edx, OFFSET again
    call WriteString        ;display prompt to repeat
    mov edx, OFFSET yesNo
    call Writestring        ;display input instructions

    call Readchar           ;get single character from keyboard
    cmp al, affirm          ;check for char=='y'

    ret
check_repeat ENDP


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