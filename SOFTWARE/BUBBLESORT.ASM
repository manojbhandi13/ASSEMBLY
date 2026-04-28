.MODEL SMALL
.STACK 100h

.DATA
    array   DB  5, 3, 8, 1, 9, 2, 7, 4
    n       EQU 8

    msg1    DB  'Before: $'
    msg2    DB  13, 10, 'After:  $'
    space   DB  ' $'

.CODE

BUBBLE_SORT PROC
    MOV CX, n

OUTER_LOOP:
    PUSH CX
    MOV CX, n
    SUB CX, 1
    MOV SI, 0

INNER_LOOP:
    MOV AL, array[SI]
    MOV BL, array[SI+1]

    CMP AL, BL
    JLE NO_SWAP

    MOV array[SI],   BL
    MOV array[SI+1], AL

NO_SWAP:
    INC SI
    LOOP INNER_LOOP

    POP CX
    LOOP OUTER_LOOP

    RET
BUBBLE_SORT ENDP

PRINT_ARRAY PROC
    MOV CX, n
    MOV SI, 0

PRINT_LOOP:
    MOV AL, array[SI]

    MOV AH, 0
    MOV BL, 10
    DIV BL                  ; AL = tens digit, AH = units digit

    PUSH AX

    CMP AL, 0
    JE  SKIP_TENS
    ADD AL, '0'
    MOV DL, AL
    MOV AH, 02h
    INT 21h

SKIP_TENS:
    POP AX

    ADD AH, '0'
    MOV DL, AH
    MOV AH, 02h
    INT 21h

    MOV AH, 09h
    LEA DX, space
    INT 21h

    INC SI
    LOOP PRINT_LOOP
    RET
PRINT_ARRAY ENDP

MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; Print "Before: "
    MOV AH, 09h
    LEA DX, msg1
    INT 21h

    CALL PRINT_ARRAY

    CALL BUBBLE_SORT

    ; Print newline + "After:  "
    MOV AH, 09h
    LEA DX, msg2
    INT 21h

    CALL PRINT_ARRAY

    ; Exit to DOS
    MOV AH, 4Ch
    MOV AL, 0
    INT 21h

MAIN ENDP
END MAIN
