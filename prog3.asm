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
mumPrompt_s     BYTE    "input number ",0
input_total_s   BYTE    "you entered ",0
numbers_s       BYTE    " numbers",13,10,0
sum_total_s     BYTE    "all adding up to: ",0
average_s       BYTE    "with a rounded average of: ",0
no_values_s     BYTE    "you didn't enter any positive numbers",13,10,0
again           BYTE    13,10,"Would you like to perform these operations again?",13,10,0
yesNo           BYTE    "press 'y' for yes, any other key will exit",13,10,0
farewell_s      BYTE    13,10,"Come back soon ",0


;/////////////ERROR STRINGS//////////////////////////
noNameEntered   BYTE    "nothing was entered, please try again",13,10,0
outOfRange_s    BYTE    "please keep your input less than or equal to ",0 ;constant appended


;/////////////USER INPUT VARIABLES//////////////////
welcome_s       BYTE    13,10,"Welcome to The Acumulator "     
                ;user name will become concatenated with welcome string
userName        BYTE    STRING_MAX+1 dup (?)

;/////////////PROGRAM DATA/////////////////////////
final_total     DWORD   ?
num_values      DWORD   ?
rounded_average DWORD   ?

;///////////////////////CONTROL VARIABLE//////////
affirm          BYTE    'y'


.code
main PROC

    call Intro

    call userInstructions

get_numbers:

    call accumulate

    ;////check for no input
    test ebx, ebx
    jz no_input

    ;//store results of acumulation
    mov final_total, ecx    ;returned acumulation
    mov num_values, ebx     ;returned num values


    call calcRoundAverage
    mov rounded_average,eax ;returned average

    call outputResults      ;displays sum, num input, and average rounded

    jmp go_again               ;skip no input message
no_input:
    mov edx, OFFSET no_values_s
    call WriteString

go_again:
    call checkRepeat        ;sets zero flag if user wants to repeat
    je get_numbers          ;return to a new acumulation

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
;PROCEDURE:     Acumulate inputed numbers
;Purpose:   
;Recieves:  none
;Returns:   value in ecx, count of entries in ebx
;
;#################################################
accumulate PROC USES eax
    ;initialze registers for acumation and counting terms
    mov ebx,0
    mov ecx,0

    ;do ... while (eax >= 0)
nextNum:
    
    inc ebx     ;pre increment num_values counter for display Purpose

    call getNextNum     ;validated input returned in eax

    test eax,eax
    js leaveProc        ;inputed number is negative

    add ecx, eax        ;newly input number added to total
    jmp nextNum

leaveProc:
    dec ebx             ;last number was the negative
    ret
accumulate ENDP

;#################################################
;PROCEDURE:     get next number
;
;Purpose:   call input procedure and verify
;               -in bounds
;               -valid input
;Recieves:  num of input in ebx
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
    ;display input prompt with number
    mov edx, OFFSET mumPrompt_s
    call WriteString
    mov eax, ebx
    call WriteDec
    mov al, ':'
    call WriteChar
    mov al, ' '
    call WriteChar

    call ReadInt

    jo input            ;overflow indicated invalid input

    cmp eax, UPPER_BOUND
    jg outofBounds      ;input>UPPER_BOUND

    ret                 ;input is valid and less than UPPER_BOUND retruning
getNextNum  ENDP

;#################################################
;PROCEDURE:     caculate rounded average   
;Purpose:   find the rounded average of the inputed numbers
;Recieves:  none    accesses final_total and num_values
;Returns:   rounded average in eax
;
;#################################################
calcRoundAverage PROC USES edx

    mov ebx, num_values     ;to be used in division and later divided by 2 and compared to remainder
    
    mov eax, final_total    ;prepare dividend
    cdq                     ;fill edx with 0s

    div ebx                 ;perform division

    ;////////////////////////////////////////
    ;////rounding algorithm/////////////////
    ;///////////////////////////////////////
        ; the previous operation peformed floor on the theoretical floating results
        ; if the remainder is greater than half of the divisor (num_values/2)
        ; then it ought be rounded up instead of down and eax will be incremented

    shr ebx, 1              ;divide divisor by 2
    cmp edx, ebx

    jng leaveProc

    inc eax ; round up edx > ebx  meaning remainder is more than half the divisor

leaveProc:
    ret
calcRoundAverage ENDP
;#################################################
;PROCEDURE:     output   
;Purpose:   display the final results
;Recieves:  none    accesses final_total and num_values
;Returns:   none
;
;#################################################
outputResults PROC USES edx eax

    ;/////////////NUMBER OF INPUT////////

    mov edx, OFFSET input_total_s
    call Writestring

    mov eax, num_values
    call WriteDec

    mov edx, OFFSET numbers_s
    call Writestring

    ;/////////////GRAND TOTAL///////////
    mov edx, OFFSET sum_total_s
    call Writestring

    mov eax, final_total
    call WriteDec
    call crlf

    ;/////////////ROUNDED AVERAGE///////
    mov edx, OFFSET average_s
    call Writestring

    mov eax, rounded_average
    call WriteDec
    call crlf

    ret
outputResults ENDP

;#################################################
;PROCEDURE:     check for repeat
;
;Purpose:   ask user if they would like to repeat
;Recieves:  none
;Returns:   zero flag set if affirmative
;
;#################################################
checkRepeat PROC USES edx eax

    mov edx, OFFSET again
    call WriteString        ;display prompt to repeat
    mov edx, OFFSET yesNo
    call Writestring        ;display input instructions

    call Readchar           ;get single character from keyboard
    cmp al, affirm          ;check for char=='y'

    ret
checkRepeat ENDP


;#################################################
;PROCEDURE:    farewell
;
;Purpose:   print a farewell message and users name
;Recieves:  none
;Returns:   none
;
;#################################################
farewell PROC USES edx
    
    mov edx,OFFSET farewell_s 
    call WriteString

    mov edx,OFFSET userName
    call Writestring

    call crlf

    ret
farewell ENDP


END main