Function CharStrip
Exch $R0 #char
Exch
Exch $R1 #in string
Push $R2
Push $R3
Push $R4
 StrCpy $R2 -1
 IntOp $R2 $R2 + 1
 StrCpy $R3 $R1 1 $R2
 StrCmp $R3 "" +8
 StrCmp $R3 $R0 0 -3
  StrCpy $R3 $R1 $R2
  IntOp $R2 $R2 + 1
  StrCpy $R4 $R1 "" $R2
  StrCpy $R1 $R3$R4
  IntOp $R2 $R2 - 2
  Goto -9
  StrCpy $R0 $R1
Pop $R4
Pop $R3
Pop $R2
Pop $R1
Exch $R0
FunctionEnd
!macro CharStrip Char InStr OutVar
 Push '${InStr}'
 Push '${Char}'
  Call CharStrip
 Pop '${OutVar}'
!macroend
!define CharStrip '!insertmacro CharStrip'
 
Function StrStrip
Exch $R0 #string
Exch
Exch $R1 #in string
Push $R2
Push $R3
Push $R4
Push $R5
 StrLen $R5 $R0
 StrCpy $R2 -1
 IntOp $R2 $R2 + 1
 StrCpy $R3 $R1 $R5 $R2
 StrCmp $R3 "" +9
 StrCmp $R3 $R0 0 -3
  StrCpy $R3 $R1 $R2
  IntOp $R2 $R2 + $R5
  StrCpy $R4 $R1 "" $R2
  StrCpy $R1 $R3$R4
  IntOp $R2 $R2 - $R5
  IntOp $R2 $R2 - 1
  Goto -10
  StrCpy $R0 $R1
Pop $R5
Pop $R4
Pop $R3
Pop $R2
Pop $R1
Exch $R0
FunctionEnd
!macro StrStrip Str InStr OutVar
 Push '${InStr}'
 Push '${Str}'
  Call StrStrip
 Pop '${OutVar}'
!macroend
!define StrStrip '!insertmacro StrStrip'

; Trim
;   Removes leading & trailing whitespace from a string
; Usage:
;   Push 
;   Call Trim
;   Pop 
Function Trim
	Exch $R1 ; Original string
	Push $R2
 
Loop:
	StrCpy $R2 "$R1" 1
	StrCmp "$R2" " " TrimLeft
	StrCmp "$R2" "$\r" TrimLeft
	StrCmp "$R2" "$\n" TrimLeft
	StrCmp "$R2" "$\t" TrimLeft
	GoTo Loop2
TrimLeft:	
	StrCpy $R1 "$R1" "" 1
	Goto Loop
 
Loop2:
	StrCpy $R2 "$R1" 1 -1
	StrCmp "$R2" " " TrimRight
	StrCmp "$R2" "$\r" TrimRight
	StrCmp "$R2" "$\n" TrimRight
	StrCmp "$R2" "$\t" TrimRight
	GoTo Done
TrimRight:	
	StrCpy $R1 "$R1" -1
	Goto Loop2
 
Done:
	Pop $R2
	Exch $R1
FunctionEnd
