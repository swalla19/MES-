ORG 0000H

    ; clear everything out first
    MOV R2, #0
    MOV R3, #0

    ; increments to get to 1024
    INC R2
    INC R2
    INC R2
    INC R2

    ; put the remainder (102) into R3
    ; 102 decimal = 66 hex
    MOV R3, #66H

DONE:
    SJMP DONE
END