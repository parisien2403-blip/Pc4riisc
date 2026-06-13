Set fso = CreateObject("Scripting.FileSystemObject")
Set shell = CreateObject("WScript.Shell")
base = fso.GetParentFolderName(WScript.ScriptFullName)
vbs = base & "\INSTALLER-SUR-BUREAU.vbs"
If fso.FileExists(vbs) Then
  shell.Run "wscript.exe """ & vbs & """", 1, False
Else
  MsgBox "Fichier introuvable : INSTALLER-SUR-BUREAU.vbs", vbCritical, "TRIGONE PC"
End If
