TITLE Program Template     (template.asm)

; Author:Brandon Swanson
; Course / Project ID                 Date:
; Description:

INCLUDE Irvine32.inc

;////////////////PROGRAM CONSTANTS//////////////////
LOWER_BOUND = 0     ;input must be greater than this
UPPER_BOUND = 47    ;input must be less than this
;STRING_MAX  = 40    ;maximum length of user input strings
STRING_MAX  = 8    ;maximum length of user input strings

.data

;//////////////STRINGS///////////////////////////////
intro_s         BYTE    "Fibonacci Numbers",13,10
                BYTE    "Programed by Brandon Swanson",13,10,0
namePrompt_s    BYTE    "What is your name: ",0
instruction_s   BYTE    "You will enter the number of Fibonacci terms you would like displayed",13,10
                BYTE    "Enter a whole number between 1 and 46 inclusive",13,10,13,10,0
mumPrompt_s     BYTE    "How many terms would you like to see: ",0
farewell_s      BYTE    "Thank you for using my program" ,13,10
                BYTE    "-Brandon",13,10,0

;/////////////ERROR STRINGS//////////////////////////
noNameEntered   BYTE    "The name you entered was too long", 13,10 
                BYTE    "less than 40 characters please",13,10,0
outOfRange_s    BYTE    "nothing was entered, please try again",13,10,0


;/////////////USER INPUT VARIABLES//////////////////
welcome_s       BYTE    "Welcome to Fibonacci Numbers "     
                ;user name will become concatenated with welcome string
userName        BYTE    STRING_MAX+1 dup(?)
nTerms          BYTE    ?

;////////////PROGRAM INFORMATION///////////////////


.code
main PROC
    call Intro

    exit    ; exit to operating system
main ENDP



;#################################################
;PROCEDURE:     Intro
;
;Purpose:   print introduction and get users name
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


END main
