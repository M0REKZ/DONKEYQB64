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
 
Rem The IBM Personal Computer Donkey
Rem Version 1.10 (C)Copyright IBM Corp 1981, 1982
Rem Licensed Material - Program Property of IBM
Def Seg: Poke 106, 0
SAMPLES$ = "NO"
$Resize:Stretch
Dim CAR%(900)
GoSub StartScreen 'GOTO 1010
SAMPLES$ = "YES"
 
 
StartGraphic:
Rem
Color 0
DefInt A-Y
Screen 1, 0: Color 8, 1
Dim Q%(500)
Dim D1%(150), D2%(150), C1%(200), C2%(200)
Dim DNK%(300)
GoSub MakeDonkey
GoSub MakeCar
Cls
Dim B%(300)
For I = 2 To 300: B%(I) = -16384 + 192: Next
B%(0) = 2: B%(1) = 193
 
While 1
    1540 Rem
    CX = 110: Cls
    Line (0, 0)-(305, 199), , B
    Line (6, 6)-(97, 195), 1, BF
    Line (183, 6)-(305, 195), 1, BF
    Locate 3, 5: Print "Donkey"
    Locate 3, 29: Print "Driver"
    Locate 19, 25: Print "Press Space ";
    Locate 20, 25: Print "Bar to switch";
    Locate 21, 25: Print "lanes ";
    Locate 23, 25: Print "Press ESC ";
    Locate 24, 25: Print "to exit ";
    For Y = 4 To 199 Step 20: Line (140, Y)-(140, Y + 10): Next
    CY = 105: CX = 105
    Line (100, 0)-(100, 199): Line (180, 0)-(180, 199)
    Do '1670
        Locate 5, 6: Print SD: Locate 5, 31: Print SM
        CY = CY - 4: If CY < 60 Then GoSub DonkeyLoss: Exit Do '2230
        Put (CX, CY), CAR%(), PReset
        DX = 105 + 42 * Int(Rnd * 2)
        For Y = (Rnd * -4) * 8 To 124 Step 6
 
            'Delay added
            _Delay 0.05
 
            Sound 20000, 0.9 'Modified SOUND Duration
            A$ = InKey$: If A$ = Chr$(27) Then GoSub Escape Else Poke 106, 0:
            If Len(A$) > 0 Then Line (CX, CY)-(CX + 28, CY + 44), 0, BF: CX = 252 - CX: Put (CX, CY), CAR%(), PReset: Sound 200, 1
            If Y >= 3 Then Put (DX, Y), DNK%(), PSet
            If CX = DX And Y + 25 >= CY Then GoSub Collision: Exit Do '2060
            If Y And 3 Then Put (140, 6), B%()
        Next
        : Line (DX, 124)-(DX + 32, 149), 0, BF:
    Loop 'GOTO 1670
Wend
Return
 
Collision:
SD = SD + 1: Locate 14, 6: Print "BOOM!"
Get (DX, Y)-(DX + 16, Y + 25), D1%()
D1X = DX: D1Y = Y: D2X = DX + 17
Get (DX + 17, Y)-(DX + 31, Y + 25), D2%()
Get (CX, CY)-(CX + 14, CY + 44), C1%()
Get (CX + 15, CY)-(CX + 28, CY + 44), C2%()
C1X = CX: C1Y = CY: C2X = CX + 15
For P = 6 To 0 Step -1: Z = 1 / (2 ^ P): Z1 = 1 - Z
 
    'Delay added too
    _Delay 0.20
 
    Put (C1X, C1Y), C1%(): Put (C2X, C1Y), C2%()
    Put (D1X, D1Y), D1%(): Put (D2X, D1Y), D2%()
    C1X = CX * Z1: D1Y = Y * Z1: C2X = C2X + (291 - C2X) * Z
    D1X = DX * Z1: C1Y = C1Y + (155 - C1Y) * Z: D2X = D2X + (294 - D2X) * Z
    Put (C1X, C1Y), C1%(): Put (C2X, C1Y), C2%()
    Put (D1X, D1Y), D1%(): Put (D2X, D1Y), D2%()
    Sound 37 + Rnd * 200, 4:
Next
'FOR Y = 1 TO 2000: NEXT
_Delay 0.25
 
Cls: 'GOTO 1540
Return
 
DonkeyLoss:
SM = SM + 1: Locate 7, 25: Print "Donkey loses!"
'FOR Y = 1 TO 1000: NEXT
_Delay 0.75
Cls: 'GOTO 1540
Return
 
StartScreen:
Key Off: Screen 0, 1: Color 15, 0, 0: Width 40: Cls: Locate 5, 19: Print "IBM"
Locate 7, 12, 0: Print "Personal Computer"
Color 10, 0: Locate 10, 9, 0: Print Chr$(213) + String$(21, 205) + Chr$(184)
Locate 11, 9, 0: Print Chr$(179) + "       DONKEY        " + Chr$(179)
Locate 12, 9, 0: Print Chr$(179) + String$(21, 32) + Chr$(179)
Locate 13, 9, 0: Print Chr$(179) + "    Version 1.10     " + Chr$(179)
Locate 14, 9, 0: Print Chr$(212) + String$(21, 205) + Chr$(190)
Color 15, 0: Locate 17, 4, 0: Print "(C) Copyright IBM Corp 1981, 1982"
Color 14, 0: Locate 23, 7, 0: Print "Press space bar to continue"
Do While InKey$ = ""
    CMD$ = InKey$
    If CMD$ = Chr$(27) Then GoSub Escape 'GOTO 1298
    If CMD$ = " " Then GoSub TestAdapter 'GOTO 1160
Loop
Return
 
TestAdapter:
Def Seg = 0
If (Peek(&H410) And &H30) = &H30 Then
    Width 80: Cls: Locate 3, 1
    Print "HOLD IT!"
    Print "YOU'RE NOT USING THE COLOR/GRAPHICS MONITOR ADAPTER!"
    Print "THIS PROGRAM USES GRAPHICS AND REQUIRES THAT ADAPTER."
    Print "PRESS THE SPACE BAR TO CONTINUE."
    Def Seg
    Do While InKey$ = ""
        CMD$ = InKey$
        If CMD$ = Chr$(27) Then GoSub Escape 'GOTO 1298
        If CMD$ = " " Then GoSub Escape 'GOTO 1298
    Loop
Else
    Def Seg: GoSub TestBasic 'GOTO 1291
    GoSub StartGraphic
End If
Return
 
Escape:
On Error GoTo 0
Screen 0, 1: Color 7, 0, 0: Cls: End
Return
 
TestBasic:
Key Off
On Error GoTo WarningBASICA '1295
Play "p16"
Return
 
WarningBASICA:
Color 31, 0, 0
Print "THIS PROGRAM REQUIRES ADVANCED BASIC -- USE COMMAND 'BASICA'": Color 15, 0, 0: For I = 1 To 9000: Next:
Resume Escape '1298
 
MakeDonkey:
Cls
Draw "S08"
Draw "BM14,18"
Draw "M+2,-4R8M+1,-1U1M+1,+1M+2,-1"
Draw "M-1,1M+1,3M-1,1M-1,-2M-1,2"
Draw "D3L1U3M-1,1D2L1U2L3D2L1U2M-1,-1"
Draw "D3L1U5M-2,3U1"
Paint (21, 14), 3
PReset (37, 10): PReset (40, 10)
PReset (37, 11): PReset (40, 11)
Get (13, 0)-(45, 25), DNK%()
Return
 
MakeCar:
Cls
Draw "S8C3"
Draw "BM12,1r3m+1,3d2R1ND2u1r2d4l2u1l1"
Draw "d7R1nd2u2r3d6l3u2l1d3m-1,1l3"
Draw "m-1,-1u3l1d2l3u6r3d2nd2r1u7l1d1l2"
Draw "u4r2d1nd2R1U2"
Draw "M+1,-3"
Draw "BD10D2R3U2M-1,-1L1M-1,1"
Draw "BD3D1R1U1L1BR2R1D1L1U1"
Draw "BD2BL2D1R1U1L1BR2R1D1L1U1"
Draw "BD2BL2D1R1U1L1BR2R1D1L1U1"
Line (0, 0)-(40, 60), , B
Paint (1, 1)
Rem DIM CAR%(900)
Get (1, 1)-(28, 44), CAR%() 'Modified "29" and "45" for a line that appeared on the side of the car
Return
 
 
