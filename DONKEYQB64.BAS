'==============
 
' **** Donkey ****
 
'THIS IS ONLY AN ADAPTATION FROM QuickBasic DONKEY.BAS TO QB64
'Adapted Because DONKEY.BAS (QuickBasic) run so fast when compile with QB64
 
'-----------------
' 2020 05 18 1.43 AM   porting from spaghetti structure(GOTO) to meatball structure (GOSUB)
'**************
'Used QuickBasic DONKEY.BAS (from https://web.archive.org/web/20050405104141/http://www.jujusoft.com/drivey/DONKEYQB.BAS.html) as base
'Used GW-BASIC DONKEY.BAS (from http://peyre.x10.mx/GWBASIC/) as guide
'Used "PC-BASIC" (https://robhagemans.github.io/pcbasic/) to run GW-BASIC DONKEY.BAS
 
'Added some DELAYs to make the program run like GW-BASIC version (on PC-BASIC)
 
'TO DO:
' * If possible, Make the game sound dont delay (For example when you press space)
 
'===============
 
REM The IBM Personal Computer Donkey
REM Version 1.10 (C)Copyright IBM Corp 1981, 1982
REM Licensed Material - Program Property of IBM
DEF SEG: POKE 106, 0
SAMPLES$ = "NO"
DIM CAR%(900)
GOSUB StartScreen 'GOTO 1010
SAMPLES$ = "YES"
 
 
StartGraphic:
REM
COLOR 0
DEFINT A-Y
SCREEN 1, 0: COLOR 8, 1
DIM Q%(500)
DIM D1%(150), D2%(150), C1%(200), C2%(200)
DIM DNK%(300)
GOSUB MakeDonkey
GOSUB MakeCar
CLS
DIM B%(300)
FOR I = 2 TO 300: B%(I) = -16384 + 192: NEXT
B%(0) = 2: B%(1) = 193
 
WHILE 1
   1540 REM
    CX = 110: CLS
    LINE (0, 0)-(305, 199), , B
    LINE (6, 6)-(97, 195), 1, BF
    LINE (183, 6)-(305, 195), 1, BF
    LOCATE 3, 5: PRINT "Donkey"
    LOCATE 3, 29: PRINT "Driver"
    LOCATE 19, 25: PRINT "Press Space ";
    LOCATE 20, 25: PRINT "Bar to switch";
    LOCATE 21, 25: PRINT "lanes ";
    LOCATE 23, 25: PRINT "Press ESC ";
    LOCATE 24, 25: PRINT "to exit ";
    FOR Y = 4 TO 199 STEP 20: LINE (140, Y)-(140, Y + 10): NEXT
    CY = 105: CX = 105
    LINE (100, 0)-(100, 199): LINE (180, 0)-(180, 199)
    DO '1670
        LOCATE 5, 6: PRINT SD: LOCATE 5, 31: PRINT SM
        CY = CY - 4: IF CY < 60 THEN GOSUB DonkeyLoss: EXIT DO '2230
        PUT (CX, CY), CAR%(), PRESET
        DX = 105 + 42 * INT(RND * 2)
        FOR Y = (RND * -4) * 8 TO 124 STEP 6
 
            'Delay added
            _DELAY 0.05
 
            SOUND 20000, 0.9 'Modified SOUND Duration
            A$ = INKEY$: IF A$ = CHR$(27) THEN GOSUB Escape ELSE POKE 106, 0:
            IF LEN(A$) > 0 THEN LINE (CX, CY)-(CX + 28, CY + 44), 0, BF: CX = 252 - CX: PUT (CX, CY), CAR%(), PRESET: SOUND 200, 1
            IF Y >= 3 THEN PUT (DX, Y), DNK%(), PSET
            IF CX = DX AND Y + 25 >= CY THEN GOSUB Collision: EXIT DO '2060
            IF Y AND 3 THEN PUT (140, 6), B%()
        NEXT
        : LINE (DX, 124)-(DX + 32, 149), 0, BF:
    LOOP 'GOTO 1670
WEND
RETURN
 
Collision:
SD = SD + 1: LOCATE 14, 6: PRINT "BOOM!"
GET (DX, Y)-(DX + 16, Y + 25), D1%()
D1X = DX: D1Y = Y: D2X = DX + 17
GET (DX + 17, Y)-(DX + 31, Y + 25), D2%()
GET (CX, CY)-(CX + 14, CY + 44), C1%()
GET (CX + 15, CY)-(CX + 28, CY + 44), C2%()
C1X = CX: C1Y = CY: C2X = CX + 15
FOR P = 6 TO 0 STEP -1: Z = 1 / (2 ^ P): Z1 = 1 - Z
 
    'Delay added too
    _DELAY 0.20
 
    PUT (C1X, C1Y), C1%(): PUT (C2X, C1Y), C2%()
    PUT (D1X, D1Y), D1%(): PUT (D2X, D1Y), D2%()
    C1X = CX * Z1: D1Y = Y * Z1: C2X = C2X + (291 - C2X) * Z
    D1X = DX * Z1: C1Y = C1Y + (155 - C1Y) * Z: D2X = D2X + (294 - D2X) * Z
    PUT (C1X, C1Y), C1%(): PUT (C2X, C1Y), C2%()
    PUT (D1X, D1Y), D1%(): PUT (D2X, D1Y), D2%()
    SOUND 37 + RND * 200, 4:
NEXT
FOR Y = 1 TO 2000: NEXT
 
'More Delay
_DELAY 0.25
 
CLS: 'GOTO 1540
RETURN
 
DonkeyLoss:
SM = SM + 1: LOCATE 7, 25: PRINT "Donkey loses!"
FOR Y = 1 TO 1000: NEXT
CLS: 'GOTO 1540
RETURN
 
StartScreen:
KEY OFF: SCREEN 0, 1: COLOR 15, 0, 0: WIDTH 40: CLS: LOCATE 5, 19: PRINT "IBM"
LOCATE 7, 12, 0: PRINT "Personal Computer"
COLOR 10, 0: LOCATE 10, 9, 0: PRINT CHR$(213) + STRING$(21, 205) + CHR$(184)
LOCATE 11, 9, 0: PRINT CHR$(179) + "       DONKEY        " + CHR$(179)
LOCATE 12, 9, 0: PRINT CHR$(179) + STRING$(21, 32) + CHR$(179)
LOCATE 13, 9, 0: PRINT CHR$(179) + "    Version 1.10     " + CHR$(179)
LOCATE 14, 9, 0: PRINT CHR$(212) + STRING$(21, 205) + CHR$(190)
COLOR 15, 0: LOCATE 17, 4, 0: PRINT "(C) Copyright IBM Corp 1981, 1982"
COLOR 14, 0: LOCATE 23, 7, 0: PRINT "Press space bar to continue"
DO WHILE INKEY$ = ""
    CMD$ = INKEY$
    IF CMD$ = CHR$(27) THEN GOSUB Escape 'GOTO 1298
    IF CMD$ = " " THEN GOSUB TestAdapter 'GOTO 1160
LOOP
RETURN
 
TestAdapter:
DEF SEG = 0
IF (PEEK(&H410) AND &H30) = &H30 THEN
    WIDTH 80: CLS: LOCATE 3, 1
    PRINT "HOLD IT!"
    PRINT "YOU'RE NOT USING THE COLOR/GRAPHICS MONITOR ADAPTER!"
    PRINT "THIS PROGRAM USES GRAPHICS AND REQUIRES THAT ADAPTER."
    PRINT "PRESS THE SPACE BAR TO CONTINUE."
    DEF SEG
    DO WHILE INKEY$ = ""
        CMD$ = INKEY$
        IF CMD$ = CHR$(27) THEN GOSUB Escape 'GOTO 1298
        IF CMD$ = " " THEN GOSUB Escape 'GOTO 1298
    LOOP
ELSE
    DEF SEG: GOSUB TestBasic 'GOTO 1291
    GOSUB StartGraphic
END IF
RETURN
 
Escape:
ON ERROR GOTO 0
SCREEN 0, 1: COLOR 7, 0, 0: CLS: END
RETURN
 
TestBasic:
KEY OFF
ON ERROR GOTO WarningBASICA '1295
PLAY "p16"
RETURN
 
WarningBASICA:
COLOR 31, 0, 0
PRINT "THIS PROGRAM REQUIRES ADVANCED BASIC -- USE COMMAND 'BASICA'": COLOR 15, 0, 0: FOR I = 1 TO 9000: NEXT:
RESUME Escape '1298
 
MakeDonkey:
CLS
DRAW "S08"
DRAW "BM14,18"
DRAW "M+2,-4R8M+1,-1U1M+1,+1M+2,-1"
DRAW "M-1,1M+1,3M-1,1M-1,-2M-1,2"
DRAW "D3L1U3M-1,1D2L1U2L3D2L1U2M-1,-1"
DRAW "D3L1U5M-2,3U1"
PAINT (21, 14), 3
PRESET (37, 10): PRESET (40, 10)
PRESET (37, 11): PRESET (40, 11)
GET (13, 0)-(45, 25), DNK%()
RETURN
 
MakeCar:
CLS
DRAW "S8C3"
DRAW "BM12,1r3m+1,3d2R1ND2u1r2d4l2u1l1"
DRAW "d7R1nd2u2r3d6l3u2l1d3m-1,1l3"
DRAW "m-1,-1u3l1d2l3u6r3d2nd2r1u7l1d1l2"
DRAW "u4r2d1nd2R1U2"
DRAW "M+1,-3"
DRAW "BD10D2R3U2M-1,-1L1M-1,1"
DRAW "BD3D1R1U1L1BR2R1D1L1U1"
DRAW "BD2BL2D1R1U1L1BR2R1D1L1U1"
DRAW "BD2BL2D1R1U1L1BR2R1D1L1U1"
LINE (0, 0)-(40, 60), , B
PAINT (1, 1)
REM DIM CAR%(900)
GET (1, 1)-(28, 44), CAR%() 'Modified "29" and "45" for a line that appeared on the side of the car
RETURN
 
 