; This function makes a list of files in a directory.
;
; Usage:
;
; Push "$INSTDIR\output.txt" # output file
; Push "*.ext" # filter
; Push "C:\A-Folder" # folder to search in
; Call MakeFileList
;
Function MakeFileList
Exch $R0 #path
Exch
Exch $R1 #filter
Exch
Exch 2
Exch $R2 #output file
Exch 2
Push $R3
Push $R4
Push $R5
 ClearErrors
 FindFirst $R3 $R4 "$R0\$R1"
  FileOpen $R5 $R2 w
 
 Loop:
 IfErrors Done
  FileWrite $R5 "$R4$\r$\n"
  FindNext $R3 $R4
  Goto Loop
 
 Done:
  FileClose $R5
 FindClose $R3
Pop $R5
Pop $R4
Pop $R3
Pop $R2
Pop $R1
Pop $R0
FunctionEnd