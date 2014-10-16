TITLE Program Template     (template.asm)

; Author:Brandon Swanson
; Course / Project ID                 Date:
; Description:

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data

number	DWORD 10

.code
main PROC

	mov eax, number
	push edx
	push 11
	pop eax
	call dumpregs

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
