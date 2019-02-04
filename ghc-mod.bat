@echo off
for /f %%i in ('C:\Windows\System32\wsl.exe wslpath "%~dp0stdin-wsl.py"') do set PYTHON_SCRIPT=%%i
set LINUX_EXECUTABLE="~/bin/ghc-mod"

REM this executes python directly to try and minimise side effects on the TTY for the REPL to think it's a native terminal
C:\Windows\System32\wsl.exe -e /usr/bin/python3 "%PYTHON_SCRIPT%" "%LINUX_EXECUTABLE%" %*