Set fso = CreateObject("Scripting.FileSystemObject")
Set shell = CreateObject("WScript.Shell")

Function TrouverDossierTrigone()
  Dim scriptBase, docs, candidat, test
  scriptBase = fso.GetParentFolderName(WScript.ScriptFullName)
  test = scriptBase & "\LANCER-TRIGONE-APP.bat"
  If fso.FileExists(test) Then
    TrouverDossierTrigone = scriptBase
    Exit Function
  End If
  docs = shell.SpecialFolders("MyDocuments")
  candidat = docs & "\TRIGONE pc"
  test = candidat & "\LANCER-TRIGONE-APP.bat"
  If fso.FileExists(test) Then
    TrouverDossierTrigone = candidat
    Exit Function
  End If
  TrouverDossierTrigone = ""
End Function

Function GenererIconeIco(base)
  Dim ps1, cmd, ec
  ps1 = base & "\build-trigone-ico.ps1"
  If Not fso.FileExists(ps1) Then Exit Function
  cmd = "powershell.exe -NoProfile -ExecutionPolicy Bypass -File """ & ps1 & """"
  ec = shell.Run(cmd, 0, True)
  GenererIconeIco = (ec = 0)
End Function

base = TrouverDossierTrigone()
If base = "" Then
  MsgBox "TRIGONE PC introuvable." & vbCrLf & vbCrLf & _
    "Allez dans Documents \ TRIGONE pc et relancez ce fichier.", vbCritical, "TRIGONE PC"
  WScript.Quit 1
End If

launcher = base & "\LANCER-TRIGONE-APP.bat"
icon = base & "\trigone-pc.ico"

If Not fso.FileExists(icon) Or fso.GetFile(icon).Size < 5000 Then
  GenererIconeIco base
End If

If Not fso.FileExists(icon) Then
  MsgBox "Icone introuvable : trigone-pc.ico" & vbCrLf & vbCrLf & _
    "Lancez build-trigone-ico.ps1 dans le dossier TRIGONE pc.", vbCritical, "TRIGONE PC"
  WScript.Quit 1
End If

desk = shell.SpecialFolders("Desktop")
lnkPath = desk & "\TRIGONE PC.lnk"

Set sc = shell.CreateShortcut(lnkPath)
sc.TargetPath = launcher
sc.WorkingDirectory = base
sc.IconLocation = fso.GetAbsolutePathName(icon) & ",0"
sc.Description = "TRIGONE PC - OMR et ABT"
sc.Save

On Error Resume Next
shell.Run """" & launcher & """", 1, False
On Error GoTo 0

MsgBox "Raccourci mis a jour sur le bureau." & vbCrLf & vbCrLf & _
  "L'icone phénix TRIGONE doit apparaitre sur TRIGONE PC.", vbInformation, "TRIGONE PC - OK"
