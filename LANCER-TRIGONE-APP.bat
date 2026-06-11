@echo off
cd /d "%~dp0"
set "EDGE86=%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe"
set "EDGE64=%ProgramFiles%\Microsoft\Edge\Application\msedge.exe"
set "CHR64=%ProgramFiles%\Google\Chrome\Application\chrome.exe"
set "CHR86=%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe"

if exist "%EDGE86%" goto runedge86
if exist "%EDGE64%" goto runedge64
if exist "%CHR64%" goto runchrome64
if exist "%CHR86%" goto runchrome86
start "" "%~dp0index.html"
exit /b 0

:runedge86
start "" "%EDGE86%" "%~dp0index.html"
exit /b 0

:runedge64
start "" "%EDGE64%" "%~dp0index.html"
exit /b 0

:runchrome64
start "" "%CHR64%" "%~dp0index.html"
exit /b 0

:runchrome86
start "" "%CHR86%" "%~dp0index.html"
exit /b 0
