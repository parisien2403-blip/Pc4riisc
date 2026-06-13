# Installe TRIGONE PC sur le bureau — raccourci avec icone + mode application
$ErrorActionPreference = 'Stop'
$base = $PSScriptRoot
$bat = Join-Path $base 'LANCER-TRIGONE-APP.bat'
$icoScript = Join-Path $base 'build-trigone-ico.ps1'
$iconScript = Join-Path $base 'build-app-icons.ps1'

if (-not (Test-Path (Join-Path $base 'icon-512.png'))) {
  if (Test-Path $iconScript) {
    & powershell -NoProfile -ExecutionPolicy Bypass -File $iconScript | Out-Null
  }
}
if (-not (Test-Path (Join-Path $base 'trigone-pc.ico')) -and (Test-Path $icoScript)) {
  & powershell -NoProfile -ExecutionPolicy Bypass -File $icoScript | Out-Null
}

$ico = Join-Path $base 'trigone-pc.ico'
if (-not (Test-Path $ico)) { $ico = Join-Path $base 'icon-512.png' }

$desk = [Environment]::GetFolderPath('Desktop')
$lnk = Join-Path $desk 'TRIGONE PC.lnk'

$Wsh = New-Object -ComObject WScript.Shell
$sc = $Wsh.CreateShortcut($lnk)
$sc.TargetPath = $bat
$sc.WorkingDirectory = $base
$sc.IconLocation = "$ico,0"
$sc.Description = 'TRIGONE PC — OMR et ABT (local, hors ligne)'
$sc.Save()

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.MessageBox]::Show(
@'
Raccourci « TRIGONE PC » cree sur le bureau.

Double-cliquez-le pour ouvrir TRIGONE en mode application
(fenetre dediee, icone phénix, sans barre du navigateur).

Laissez la fenetre « serveur » minimisée ouverte.
'@,
  'TRIGONE PC — installe',
  [System.Windows.Forms.MessageBoxButtons]::OK,
  [System.Windows.Forms.MessageBoxIcon]::Information
) | Out-Null

Start-Process -FilePath $bat -WorkingDirectory $base
