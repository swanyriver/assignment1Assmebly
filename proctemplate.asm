;#################################################
;PROCEDURE:      
;
;Purpose:   
;Recieves:  none
;Returns:   none
;
;#################################################
;X_local EQU DWORD PTR [ebp-4]
;Y_local EQU DWORD PTR [ebp-8]

;X_param EQU DWORD PTR [ebp+8]
;Y_param EQU DWORD PTR [ebp+12]

 PROC
    push ebp
    mov ebp,esp ;set up stack frame

    pop ebp     ;restore callers stack frame
    Ret
 ENDP


;///with local vars
  PROC
    push ebp
    mov ebp,esp ;set up stack frame

    pop ebp     ;restore callers stack frame
    Ret
 ENDP