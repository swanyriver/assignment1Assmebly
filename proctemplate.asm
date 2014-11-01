;#################################################
;PROCEDURE:      
;
;Purpose:   
;Recieves:  none
;Returns:   none
;
;#################################################
X_local EQU DWORD PTR [ebp-4]
 PROC
    push ebp
    mov ebp,esp ;set up stack frame

    pop ebp     ;restore callers stack frame
    Ret
 ENDP