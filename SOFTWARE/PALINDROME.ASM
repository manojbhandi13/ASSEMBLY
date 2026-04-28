.MODEL SMALL
.STACK 100h

.DATA
    string      DB  'RACECAR', '$'
    len         EQU 7

    msg_yes     DB  'Palindrome!$'
    msg_no      DB  'Not a Palindrome!$'
    msg_str     DB  'String: $'
    newline     DB  13, 10, '$'

.CODE

; -----------------------------------------------
; PRINT_STRING: prints the hardcoded string
; -----------------------------------------------
PRINT_STRING PROC
    MOV AH, 09h
    LEA DX, string
    INT 21h
    RET
PRINT_STRING ENDP

; -----------------------------------------------
; CHECK_PALINDROME: checks if string is palindrome
; Sets AL = 1 if palindrome, AL = 0 if not
; -----------------------------------------------
CHECK_PALINDROME PROC
    MOV SI, 0               ; SI = left index (start)
    MOV DI, len - 1         ; DI = right index (end)

COMPARE_LOOP:
    CMP SI, DI              ; if left >= right, done
    JGE IS_PALINDROME       ; all chars matched

    MOV AL, string[SI]      ; AL = left  char
    MOV BL, string[DI]      ; BL = right char

    CMP AL, BL              ; compare left and right
    JNE NOT_PALINDROME      ; mismatch → not palindrome

    INC SI                  ; move left  pointer forward
    DEC DI                  ; move right pointer backward
    JMP COMPARE_LOOP

IS_PALINDROME:
    MOV AL, 1               ; return 1 = true
    RET

NOT_PALINDROME:
    MOV AL, 0               ; return 0 = false
    RET

CHECK_PALINDROME ENDP

; -----------------------------------------------
; MAIN
; -----------------------------------------------
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; Print "String: "
    MOV AH, 09h
    LEA DX, msg_str
    INT 21h

    ; Print the string
    CALL PRINT_STRING

    ; Print newline
    MOV AH, 09h
    LEA DX, newline
    INT 21h

    ; Call palindrome check
    CALL CHECK_PALINDROME   ; result in AL

    ; Print result based on AL
    CMP AL, 1
    JE  PRINT_YES

    ; Print "Not a Palindrome!"
    MOV AH, 09h
    LEA DX, msg_no
    INT 21h
    JMP EXIT

PRINT_YES:
    ; Print "Palindrome!"
    MOV AH, 09h
    LEA DX, msg_yes
    INT 21h

EXIT:
    MOV AH, 4Ch
    MOV AL, 0
    INT 21h

MAIN ENDP
END MAIN
