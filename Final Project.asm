; Name: Amber Martin
; Class: CS-155, Spring 2025
; Assignment: Final
; Description: Displays a short ascii animation of a guy walking under snowfall

;Register list:
; R0 - Ragdoll 1, address edition
; R1 - Track's Malice's legs
; R2 - Counter ragdoll, always 0 in main
; R3 - Snow Stack!
; R4 - Position in main loop
; R5 - Counter for animation loop
; R6 - open
; R7 - used for subroutine addresses
    .ORIG x3000
    
    LD R3, StackS

AND R5, R5, #0
ADD R5, R5, #8
AND R1, R1, #0
SNOWLOOP

    AND R4, R4, #0 ;tracks rotation of snow lines
    ADD R4, R4, #4
    
    JSR RotateSnow 
    JSR Snow ;display
    JSR DisplayMeep
    ADD R4, R4, #-1 
    
    JSR Pause
    
    ADD R1, R1, #1 ;determines which of Meep's legs are used
    JSR RotateSnow 
    JSR Snow
    JSR DisplayMeep
    ADD R4, R4, #-1
    
    JSR Pause
    
    ADD R1, R1, #1
    JSR RotateSnow 
    JSR Snow
    JSR DisplayMeep
    ADD R4, R4, #-1
    
    JSR Pause
    
    ADD R1, R1, #1
    JSR RotateSnow 
    JSR Snow
    JSR DisplayMeep

    JSR Pause
    ADD R1, R1, #1

    ADD R5, R5, #-1
BRp SNOWLOOP
    
    HALT
;Misc
StackS   .FILL       x5000
SaveR7   .BLKW       1
PauseIt  .FILL       x4000

;Snow
Top      .STRINGZ    "-----------------------------------\n"
Snow1    .STRINGZ    "*            *            *\n"
Snow2    .STRINGZ    "		 * 	       *\n"
Snow3    .STRINGZ    "         *\n"
Snow4    .STRINGZ    "  *                 *       *\n"
SnowE    .STRINGZ    "*"

;Meep
Space    .STRINGZ    " "
Umbrella .STRINGZ    "_--_\n"
Head     .STRINGZ    " \O\n"
Torso    .STRINGZ    "  |\n"
Forward  .STRINGZ    "  |\ \n"
Back     .STRINGZ    " /| \n"
Stand    .STRINGZ    "  | \n"


;*************PAUSE****************
Pause

LD R6, PauseIt

LoopPause

ADD R6, R6, #-1

BRp LoopPause

RET


;***************DISPLAY MEEP******************

;R0 - display ragdoll
;R2 - Used for calculations
;R4 - determines which legs to use
DisplayMeep
    ST R7, SaveR7
    
    JSR DISPLAYSPACE
    LEA R0, Umbrella
    TRAP x22

    JSR DISPLAYSPACE
    LEA R0, Head
    TRAP x22

    JSR DISPLAYSPACE
    LEA R0, Torso
    TRAP x22

;legs
;first check for stand
    ADD R2, R1, #0
BRz WalkStand
    ADD R2, R2, #-16
    ADD R2, R2, #-15
BRz WalkStand
;not beginning or end, check for forward/back
    ADD R2, R4, #0
;determine which leg: 
    
    ADD R2, R2, #-1 ;r4 = 1
    BRz WalkBack
    ADD R2, R2, #-1 ;r4 = 2
    BRz WalkForward
    ADD R2, R2, #-1 ;r4 = 3
    BRz WalkBack
    ADD R2, R2, #-1 ;r4 = 4
    BRz WalkForward
    
WalkBack ; /|
    JSR DISPLAYSPACE
    LEA R0, Back
    TRAP x22
    BR DoneWalk
WalkStand ; |
    JSR DISPLAYSPACE
    LEA R0, Stand
    TRAP x22
    BR DoneWalk
WalkForward ; |\
    JSR DISPLAYSPACE
    LEA R0, Forward
    TRAP x22
DoneWalk
    AND R2, R2, #0
    LD R7, SaveR7
    RET




;**********DISPLAY SPACE************
; R0 - ragdoll display
; R1 - number of spaces to display
; R2 - used for maths
DISPLAYSPACE
    AND R2, R2, #0
    ADD R2, R1, #0 ;R1 is position in main * amount of loops already done
    BRz SPACEDONE
LOOPDS
    LEA R0, Space
    TRAP x22
    ADD R2, R2, #-1
BRp LOOPDS

SPACEDONE
AND R2, R2, #0
RET





;************* DISPLAY SNOW ********************
;Basic display snow function
; R0 - display ragdoll
; R2 - Counter for display loop
; R3 - contains addresses of snow lines
Snow
    AND R2, R2, #0
    ADD R2, R2, #4
    LEA R0, Top
    TRAP x22
    
    LD R3, StackS    
DisplaySnow
    ;Display line
    LDR R0, R3, #0
    TRAP x22
    ADD R3, R3, #1
    ADD R2, R2, #-1
BRp DisplaySnow
RET

;***************ROTATE SNOW****************
;Rotates the snow based on R4, aka position in main loop
; R2 - used for math
; R3 - stack to load addresses
; R4 - position in main loop
RotateSnow

    LD R3, StackS

    AND R2, R2, #0
    ADD R2, R4, #0
    
    ADD R2, R2, #-1
    BRz ONE
    ADD R2, R2, #-1
    BRz TWO
    ADD R2, R2, #-1
    BRz THREE
    ADD R2, R2, #-1
    BRz FOUR

ONE
    LEA R0, Snow1
    STR R0, R3, #0
    ADD R3, R3, #1
    
    LEA R0, Snow2
    STR R0, R3, #0
    ADD R3, R3, #1
    
    LEA R0, Snow3
    STR R0, R3, #0
    ADD R3, R3, #1
    
    LEA R0, Snow4
    STR R0, R3, #0
    ADD R3, R3, #1

    BR ROTATEDONE
TWO
    LEA R0, Snow2
    STR R0, R3, #0
    ADD R3, R3, #1
    
    LEA R0, Snow3
    STR R0, R3, #0
    ADD R3, R3, #1
    
    LEA R0, Snow4
    STR R0, R3, #0
    ADD R3, R3, #1
    
    LEA R0, Snow1
    STR R0, R3, #0
    ADD R3, R3, #1
    BR ROTATEDONE   
    
THREE
    LEA R0, Snow3
    STR R0, R3, #0
    ADD R3, R3, #1
    
    LEA R0, Snow4
    STR R0, R3, #0
    ADD R3, R3, #1
    
    LEA R0, Snow1
    STR R0, R3, #0
    ADD R3, R3, #1
    
    LEA R0, Snow2
    STR R0, R3, #0
    ADD R3, R3, #1
    BR ROTATEDONE
    
FOUR
    LEA R0, Snow4
    STR R0, R3, #0
    ADD R3, R3, #1
    
    LEA R0, Snow1
    STR R0, R3, #0
    ADD R3, R3, #1
    
    LEA R0, Snow2
    STR R0, R3, #0
    ADD R3, R3, #1
    
    LEA R0, Snow3
    STR R0, R3, #0
    ADD R3, R3, #1
    BR ROTATEDONE
    
ROTATEDONE
RET


.END