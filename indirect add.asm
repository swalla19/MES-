MOV R1, #40H  ; Load the address 40H into Register R1
MOV A, @R1    ; Look at the value inside R1 (which is 40H), 
              ; then go to THAT address to get the data.