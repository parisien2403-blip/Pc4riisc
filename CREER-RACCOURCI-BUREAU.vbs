Set fso = CreateObject("Scripting.FileSystemObject")
Set shell = CreateObject("WScript.Shell")
base = fso.GetParentFolderName(WScript.ScriptFullName)
desk = shell.SpecialFolders("Desktop")

launcher = base & "\LANCER-TRIGONE-APP.bat"
icon = base & "\trigone-pc.ico"
If Not fso.FileExists(icon) Then icon = base & "\icon-512.png"

Set sc = shell.CreateShortcut(desk & "\TRIGONE PC.lnk")
sc.TargetPath = launcher
sc.WorkingDirectory = base
sc.IconLocation = icon & ",0"
sc.Description = "TRIGONE PC - OMR et ABT"
sc.Save

MsgBox "Raccourci TRIGONE PC cree sur le bureau.", vbInformation, "TRIGONE PC"
