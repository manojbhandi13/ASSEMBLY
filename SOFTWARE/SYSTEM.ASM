.MODEL SMALL
.STACK 100h

.DATA
    msg_date    DB 'Date: $'
    msg_time    DB 'Time: $'
    newline     DB 13, 10, '$'
    colon       DB ':$'
    slash       DB '/$'
    day_val     DB 0
    month_val   DB 0
    hour_val    DB 0
    min_val     DB 0
    sec_val     DB 0

.CODE

; Input:  AL = byte to print as 2 digits
PRINT_BYTE PROC
    MOV AH, 0
    MOV BL, 10
    DIV BL              ; AL = tens, AH = units
    PUSH AX

    ADD AL, '0'
    MOV DL, AL
    MOV AH, 02h
    INT 21h

    POP AX
    ADD AH, '0'
    MOV DL, AH
    MOV AH, 02h
    INT 21h
    RET
PRINT_BYTE ENDP

; Input:  AX = 16-bit year to print
PRINT_YEAR PROC
    MOV CX, 0
    MOV BX, 10          ; explicitly set BX = 10 here
PY_PUSH:
    MOV DX, 0
    DIV BX
    PUSH DX
    INC CX
    CMP AX, 0
    JNE PY_PUSH
PY_POP:
    POP DX
    ADD DL, '0'
    MOV AH, 02h
    INT 21h
    LOOP PY_POP
    RET
PRINT_YEAR ENDP

MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; -------- PRINT DATE --------
    MOV AH, 09h
    LEA DX, msg_date
    INT 21h

    MOV AH, 2Ah
    INT 21h                     ; CX=year, DH=month, DL=day

    ; Save to memory immediately before any INT 21h corrupts registers
    MOV day_val,   DL
    MOV month_val, DH
    PUSH CX                     ; save year on stack

    ; Print DD
    MOV AL, day_val
    CALL PRINT_BYTE

    MOV AH, 09h
    LEA DX, slash
    INT 21h

    ; Print MM
    MOV AL, month_val
    CALL PRINT_BYTE

    MOV AH, 09h
    LEA DX, slash
    INT 21h

    ; Print YYYY
    POP AX
    CALL PRINT_YEAR

    MOV AH, 09h
    LEA DX, newline
    INT 21h

    ; -------- PRINT TIME --------
    MOV AH, 09h
    LEA DX, msg_time
    INT 21h

    MOV AH, 2Ch
    INT 21h                     ; CH=hours, CL=minutes, DH=seconds

    ; Save to memory immediately
    MOV hour_val, CH
    MOV min_val,  CL
    MOV sec_val,  DH

    ; Print HH
    MOV AL, hour_val
    CALL PRINT_BYTE

    MOV AH, 09h
    LEA DX, colon
    INT 21h

    ; Print MM
    MOV AL, min_val
    CALL PRINT_BYTE

    MOV AH, 09h
    LEA DX, colon
    INT 21h

    ; Print SS
    MOV AL, sec_val
    CALL PRINT_BYTE

    MOV AH, 09h
    LEA DX, newline
    INT 21h

    ; Exit
    MOV AH, 4Ch
    MOV AL, 0
    INT 21h

MAIN ENDP
END MAIN
