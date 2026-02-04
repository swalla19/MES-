; Embedded Logger Memory Compaction Program
; Compacts data in 40H-5FH, removes FFH, shifts left, fills end with 00H

ORG 0000H           ; Start at address 0000H

; -------------------------------------------------------------
; SHOW INITIAL MEMORY CONTENTS (for simulation/demonstration)
; -------------------------------------------------------------
; Let's initialize some sample data in 40H-5FH
MOV 40H, #01H      ; Valid data
MOV 41H, #0FFH     ; To be removed
MOV 42H, #02H      ; Valid data
MOV 43H, #0FFH     ; To be removed
MOV 44H, #0FFH     ; To be removed
MOV 45H, #03H      ; Valid data
MOV 46H, #04H      ; Valid data
MOV 47H, #0FFH     ; To be removed
MOV 48H, #05H      ; Valid data
MOV 49H, #06H      ; Valid data
MOV 4AH, #0FFH     ; To be removed
; Fill rest with various values including FFH
MOV 4BH, #07H
MOV 4CH, #0FFH
MOV 4DH, #08H
MOV 4EH, #0FFH
MOV 4FH, #09H
MOV 50H, #0AH
MOV 51H, #0FFH
MOV 52H, #0BH
MOV 53H, #0FFH
MOV 54H, #0CH
MOV 55H, #0FFH
MOV 56H, #0FFH
MOV 57H, #0FFH
MOV 58H, #0DH
MOV 59H, #0EH
MOV 5AH, #0FFH
MOV 5BH, #0FH
MOV 5CH, #10H
MOV 5DH, #0FFH
MOV 5EH, #11H
MOV 5FH, #12H

; -------------------------------------------------------------
; MAIN COMPACTION ALGORITHM
; -------------------------------------------------------------
; Algorithm: Two-pointer technique
; R0 = Source pointer (scans all bytes)
; R1 = Destination pointer (where next valid byte goes)

COMPACT:
    MOV R0, #40H    ; Source pointer starts at beginning
    MOV R1, #40H    ; Destination pointer starts at beginning
    MOV R2, #32     ; Counter for 32 bytes (40H-5FH = 32 bytes)

SCAN_LOOP:
    MOV A, @R0      ; Load byte from source
    CJNE A, #0FFH, COPY_BYTE  ; If not FFH, copy it
    
    ; Byte is FFH - skip it (don't copy)
    SJMP NEXT_SOURCE

COPY_BYTE:
    ; Copy valid byte from source to destination
    MOV @R1, A      ; Store at destination
    
    ; Check if we need to move (source != destination)
    MOV A, R0
    XRL A, R1       ; XOR to compare addresses
    JZ NO_OVERWRITE ; If equal, no overwrite needed
    
    ; We're moving data, clear old location (optional but clean)
    MOV @R0, #00H   ; Clear source location
    
NO_OVERWRITE:
    INC R1          ; Move destination pointer forward

NEXT_SOURCE:
    INC R0          ; Move to next source byte
    DJNZ R2, SCAN_LOOP ; Repeat for all 32 bytes

; -------------------------------------------------------------
; FILL REMAINING SPACES WITH 00H
; -------------------------------------------------------------
FILL_ZEROS:
    ; R1 now points to first empty location
    ; Calculate how many bytes to fill
    MOV A, #60H     ; End address + 1
    CLR C
    SUBB A, R1      ; A = number of bytes to fill with 00H
    JZ COMPLETED    ; If none, we're done
    
    MOV R2, A       ; Use R2 as counter
    
FILL_LOOP:
    MOV @R1, #00H   ; Fill with 00H
    INC R1
    DJNZ R2, FILL_LOOP

COMPLETED:
    ; Program complete - infinite loop
    SJMP $

; -------------------------------------------------------------
; ALTERNATIVE VERSION (More optimized, doesn't clear source)
; -------------------------------------------------------------
; This version doesn't clear source as it copies, only fills end
; Uncomment to use instead

;COMPACT_ALT:
;    MOV R0, #40H    ; Source pointer (reads all data)
;    MOV R1, #40H    ; Destination pointer (writes valid data)
;    MOV R2, #32     ; 32 bytes total
;
;SCAN_LOOP_ALT:
;    MOV A, @R0      ; Get current byte
;    CJNE A, #0FFH, VALID_BYTE
;    
;    ; Invalid byte (FFH) - skip
;    SJMP NEXT_BYTE_ALT
;
;VALID_BYTE:
;    ; Copy valid byte if source != destination
;    MOV A, R0
;    XRL A, R1
;    JZ SAME_PTR     ; If equal, byte already in place
;    
;    MOV @R1, A      ; Actually need to get byte again
;    MOV A, @R0      ; Re-get the byte
;    MOV @R1, A      ; Store at destination
;
;SAME_PTR:
;    INC R1          ; Advance destination
;
;NEXT_BYTE_ALT:
;    INC R0          ; Next source byte
;    DJNZ R2, SCAN_LOOP_ALT
;
;; Fill remaining with zeros
;FILL_ALT:
;    MOV A, #60H
;    CLR C
;    SUBB A, R1
;    JZ DONE_ALT
;    
;    MOV R2, A
;FILL_LOOP_ALT:
;    MOV @R1, #00H
;    INC R1
;    DJNZ R2, FILL_LOOP_ALT
;
;DONE_ALT:
;    SJMP $

END