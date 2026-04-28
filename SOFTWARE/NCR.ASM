.MODEL SMALL
.STACK 100h

.DATA
    N   EQU 6
    R   EQU 2
    MSG DB 'nCr = $'

.CODE

; Input:  AL = number
; Output: BX = result
CALC_FACT PROC
    MOV BX, 1
    MOV AH, 0
    CMP AL, 0
    JE  FACT_DONE
FACT_LOOP:
    MOV CX, AX
    XCHG AX, BX
    MUL CX
    XCHG AX, BX
    MOV AH, 0
    DEC AL
    JNZ FACT_LOOP
FACT_DONE:
    RET
CALC_FACT ENDP

; Input:  AX = number to print
PRINT_NUM PROC
    MOV CX, 0
    MOV BX, 10
PUSH_DIGITS:
    MOV DX, 0
    DIV BX
    PUSH DX
    INC CX
    CMP AX, 0
    JNE PUSH_DIGITS
POP_DIGITS:
    POP DX
    ADD DL, '0'
    MOV AH, 02h
    INT 21h
    LOOP POP_DIGITS
    RET
PRINT_NUM ENDP

MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; Compute and push N!
    MOV AL, N
    CALL CALC_FACT
    PUSH BX

    ; Compute and push R!
    MOV AL, R
    CALL CALC_FACT
    PUSH BX

    ; Compute and push (N-R)!
    MOV AL, N-R
    CALL CALC_FACT
    PUSH BX

    ; Compute denominator: R! * (N-R)!
    POP CX              ; CX = (N-R)!
    POP AX              ; AX = R!
    MUL CX              ; AX = R! * (N-R)!
    MOV CX, AX          ; CX = denominator
    POP AX              ; AX = N!

    ; nCr = N! / denominator
    MOV DX, 0
    DIV CX              ; AX = nCr
    PUSH AX             ; save nCr before printing label

    ; Print label
    MOV AH, 09h
    LEA DX, MSG
    INT 21h

    ; Restore nCr and print it
    POP AX
    CALL PRINT_NUM

    ; Exit
    MOV AH, 4Ch
    MOV AL, 0
    INT 21h

MAIN ENDP
END MAIN
