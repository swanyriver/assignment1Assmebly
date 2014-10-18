TITLE Program Template     (template.asm)

; Author:Brandon Swanson
; Course / Project ID   CS271-400 Fall14 Programming Assignment #2  Date: 10/17/14
; Description: Will calculate n number of Fibonacci terms and display them in a neatly aligned format
;              will adjust collumns to leave a minimum of 5 spaces folowing the longest number

INCLUDE Irvine32.inc

;////////////////PROGRAM CONSTANTS//////////////////
LOWER_BOUND = 1     ;input must be greater than or equal to this
UPPER_BOUND = 46    ;input must be less than or equal this
STRING_MAX  = 40    ;maximum length of user input strings
SPACING     = 5     ;minimum spaces between numbers
PER_LINE    = 5     ;number of terms to display per line
MAX_SPACING = 15    ;longest number + SPACING 

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
again           BYTE    13,10,"Would you like to see a different number of terms?",13,10,0
yesNo           BYTE    "press 'y' for yes, any other key will exit",13,10,0


;/////////////ERROR STRINGS//////////////////////////
noNameEntered   BYTE    "nothing was entered, please try again",13,10,0
outOfRange_s    BYTE    "please keep your input greater than 0 and less than 47",13,10,0


;/////////////USER INPUT VARIABLES//////////////////
welcome_s       BYTE    13,10,"Welcome to Fibonacci Numbers "     
                ;user name will become concatenated with welcome string
userName        BYTE    STRING_MAX+1 dup (?)
nTerms          BYTE    ?

;////////////PROGRAM INFORMATION///////////////////
fibTemrs        DWORD   UPPER_BOUND dup (?)

;///////////////////USED FOR ALIGNMENT////////////
spaces_needed   BYTE    ? ;calculated each time as longest numbers digits + SPACING

;///////////////////////CONTROL VARIABLE//////////
affirm          BYTE    'y'


.code
main PROC

    call Intro

    call userInstructions

get_n:
    call getUserData
    mov nTerms, al     ;save result

    ;#############displayFibs#######    ;divided into two procedures
    movzx ecx, nTerms           ;pass the number of terms to calculate
    mov edx, OFFSET fibTemrs    ;pass the array address
    call calculate_fibs
    call display_fibs           ;same preconditions as calculate_fibs, ecx and edx are poped back 

    call check_repeat           ;sets zero flag if use wants to repeat
    je get_n                    ;return to getUserData

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
calculate_fibs PROC USES eax ebx ecx edx

;/////////////////////////////////////////////////
;///filling first two Fibonacci terms 1 and 1 ////
;/// returning early if 1 or 2 terms requested ///
;/////////////////////////////////////////////////


    mov eax, 1 
    mov ebx, 1      ;prepare algorithm registers

    mov [edx],eax
    mov [edx+TYPE DWORD],ebx  ;initialize first two terms
    add edx, TYPE DWORD * 2 ;adjust array pointer

    sub ecx,2       ;adjust loop counter

    jz leave_early  ;2 terms requested
    js leave_early  ;less than 2 terms requested

    jmp find_fib

leave_early:    
    ret
   

;/////////////////////////////////////////////////
;//////finding fibonaci terms from 3-N (ecx)//////
;/////////////////////////////////////////////////
find_fib:
    add eax,ebx         ;add terms n-1 and n-2
    mov [edx], eax      ;store result
    add edx, TYPE DWORD ;increment array position
    xchg eax,ebx        ;term n-1 moves to eax and term n to ebx
    LOOP find_fib

    ret
calculate_fibs ENDP

;#################################################
;PROCEDURE:     display fibs 
;
;Purpose:   display N Fibonacci numbers
;Recieves:  N number in ecx
;           beging address of DWORD array in edx containing n terms
;Returns:   none
;
; ebx conts output per line
;#################################################
display_fibs PROC USES eax ebx ecx edx

    call set_alignment

    mov ebx, PER_LINE    ;count terms per line

show_one_number:
    mov eax, [edx]      ;retrive next element in arry    
    call print_fib      ;output number with spacing

    dec ebx
    jz return_line      ;numbers per line reached
    jmp no_return_line  ;else

return_line:
    call crlf
    mov ebx, PER_LINE    ;reset numbers line count
no_return_line:
            
    add edx, TYPE DWORD ;increment array position
    LOOP show_one_number

	call crlf
	ret
display_fibs ENDP

;#################################################
;PROCEDURE:     print fib
;               used by displayFibs
;
;Purpose:   display single alligneed Fibonacci number
;Recieves:  number in eax
;Returns:   none
;
;#################################################
print_fib PROC USES eax ebx

    call WriteDec       ;display number passed to EAX

    call count_digits   ;retrive number of digits in bl
    
    mov al,' '          ;mov space to register used by WriteChar
print_space:
    call WriteChar
    inc bl
    cmp bl,spaces_needed
    jne print_space     ;print spaces until ready for next number


    ret
print_fib ENDP

;#################################################
;PROCEDURE:    set alignment
;              used by display_fibs
;Purpose:   adjust number of spaces in spaces_s
;Recieves:  N number in ecx
;           beging address of DWORD array in edx containing n terms
;Returns:   none
;
;#################################################
set_alignment PROC USES eax ebx ecx edx

    ;//get last term in array
    mov eax, TYPE DWORD
    dec ecx
    push edx
    mul ecx
    pop edx
    add edx, eax 
    mov eax,[edx]           ;eax now contains edx[n] last element

    ;//find its length
    call count_digits       ;length of longest number in ebx

    ;//add 5 spaces
    add bl,SPACING
    
    ;//save as spaces needed
    mov spaces_needed,bl                

    ret
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