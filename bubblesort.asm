TITLE Program Template     (template.asm)

; Author:Brandon Swanson
; Course / Project ID                 Date:
; Description:

INCLUDE Irvine32.inc


hi = 99
lo = 10
range = hi-lo+1

.data

array WORD 20 dup(0)

.code
main PROC

    call randomize

    push OFFSET array
    push lengthof array
    call fill

    push OFFSET array
    push lengthof array
    call display

    push OFFSET array
    push lengthof array
    call bubble

    push OFFSET array
    push lengthof array
    call display

	exit	; exit to operating system
main ENDP

;adress of array
;num values to fill
bubble PROC
    push ebp
    mov ebp, esp
    push eax
    push ebx
    push ecx
    push edi
    push esi

;//prep outer loop
    mov ebx, [ebp+8]
    cld

outer:
    dec ebx
    cmp ebx, 0
    je exit_loop

    mov esi, [ebp+12]
    mov ecx, ebx

    inner:
        mov edi, esi
        lodsw
        cmp ax, word ptr [esi]
        jle loop_again

        movsw
        stosw
        sub esi, 2

    loop_again: loop inner

    jmp outer


exit_loop:
    pop esi
    pop edi
    pop ecx
    pop ebx
    pop eax

    pop ebp
    ret 8
bubble endp

;adress of array
;num values to fill
display PROC
    push ebp
    mov ebp, esp
    push eax

    mov eax, 0

    mov ecx, [ebp+8]
    mov esi, [ebp+12]

next_num:
    lodsw
    call writedec
    mov al, ','
    call writechar
    loop next_num

    call crlf

    pop eax
    pop ebp
    ret 8
display endp

;adress of array
;num values to fill
fill PROC
    push ebp
    mov ebp, esp

    push eax

    mov ecx, [ebp+8]
    mov edi, [ebp+12]

again:
    mov eax, range
    call randomrange
    add eax, lo
    stosw
    loop again   

    pop eax

    pop ebp
    ret 8
fill endp

END main
