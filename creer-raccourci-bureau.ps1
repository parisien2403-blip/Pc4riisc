# Raccourci bureau TRIGONE PC
$ErrorActionPreference = 'Stop'
$base = $PSScriptRoot
$bat = Join-Path $base 'LANCER-TRIGONE-APP.bat'
$icoScript = Join-Path $base 'build-trigone-ico.ps1'

if (-not (Test-Path (Join-Path $base 'trigone-pc.ico')) -and (Test-Path $icoScript)) {
  & powershell -NoProfile -ExecutionPolicy Bypass -File $icoScript | Out-Null
}

$ico = Join-Path $base 'trigone-pc.ico'
if (-not (Test-Path $ico)) { $ico = Join-Path $base 'icon-512.png' }

$desk = [Environment]::GetFolderPath('Desktop')
$lnk = Join-Path $desk 'TRIGONE PC.lnk'

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($lnk)
$Shortcut.TargetPath = $bat
$Shortcut.WorkingDirectory = $base
$Shortcut.IconLocation = "$ico,0"
$Shortcut.Description = 'TRIGONE PC — OMR et ABT (local, hors ligne)'
$Shortcut.Save()

Write-Host "Raccourci cree : $lnk"
