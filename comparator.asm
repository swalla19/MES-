ORG 0000H
        LJMP MAIN
        ORG 0040H

MAIN:
        ; Configure ports for output
        MOV P1, #0FFH       ; LEDs will show result
        MOV P2, #0FFH       ; Optional display
        
        ; ========================================
        ; TEST CASE 1: A > B (Change these values)
        ; ========================================
        MOV 50H, #01H       ; A = 8
        MOV 51H, #08H       ; B = 3
        
        ; ========================================
        ; Alternatively, use these for other tests:
        ; TEST CASE 2: A = B
        ; MOV 50H, #07H       ; A = 7
        ; MOV 51H, #07H       ; B = 7
        
        ; TEST CASE 3: A < B  
        ; MOV 50H, #02H       ; A = 2
        ; MOV 51H, #09H       ; B = 9
        ; ========================================
        
        ; Perform comparison
        MOV A, 50H          ; A = first number
        MOV R2, A           ; Copy to R2
        MOV A, 51H          ; A = second number
        MOV R3, A           ; Copy to R3
        MOV R4, #00H        ; Default result = equal

LOOP:
        MOV A, R2
        JZ CHECK_B          ; If A_copy = 0, check B
        
        MOV A, R3
        JZ A_GREATER        ; If B_copy = 0 (and A not 0), A > B
        
        ; Both > 0, decrement both
        DEC R2
        DEC R3
        SJMP LOOP

CHECK_B:
        MOV A, R3
        JZ EQUAL            ; If B also 0, equal
        ; A is 0, B not 0
A_LESS:
        MOV R4, #0FFH       ; Result = FF for A < B
        SJMP DISPLAY

A_GREATER:
        MOV R4, #01H        ; Result = 01 for A > B
        SJMP DISPLAY

EQUAL:
        MOV R4, #00H        ; Result = 00 for equal

DISPLAY:
        ; Store result in memory
        MOV 52H, R4
        
        ; Display on Port 1 LEDs
        MOV P1, R4
        
        ; Also light specific LEDs for visual clarity:
        ; If result = 01 (A>B), light only LED0
        ; If result = 00 (A=B), light LED0 and LED1
        ; If result = FF (A<B), light all LEDs
        MOV A, R4
        CJNE A, #01H, NOT_GREATER
        MOV P2, #01H        ; LED0 on for A>B
        SJMP END_PROG
        
NOT_GREATER:
        CJNE A, #00H, NOT_EQUAL2
        MOV P2, #03H        ; LED0 & LED1 on for A=B
        SJMP END_PROG
        
NOT_EQUAL2:
        MOV P2, #0FFH       ; All LEDs on for A<B

END_PROG:
        ; Infinite loop to keep display visible
        SJMP $

        END