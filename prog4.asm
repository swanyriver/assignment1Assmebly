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
                BYTE    13,10,"less than or equal to ",0
mumPrompt_s     BYTE    13,10,"Number of primes desired: ",0
farewell_s      BYTE    13,10,"Thank you for using my Prime Finder",0


;/////////////ERROR STRINGS//////////////////////////
outOfRange_s    BYTE    "please keep your input greater than 0 and less than or equal to ",0 ;constant appended

;/////////////USER INPUT VARIABLES//////////////////
num_primes      BYTE    ?

;/////////////PROGRAM DATA/////////////////////////
primes_a        DWORD   UPPER_BOUND dup (?)


.code
main PROC

    call dumpregs

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
