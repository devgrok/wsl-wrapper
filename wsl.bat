@echo off
REM Usage: wsl <command>
REM Example: wsl git status
setlocal enabledelayedexpansion
set TEMP_FILE=%~dp0%~n0.%RANDOM%.sh
set LOG_FILE=%~dpf0.wsl-wrapper.log

rem build up command one argument at a time to make sure quotes are stripped off and only one set of quotes are added back on.
set wslcmd=%1
shift
:start
if [%1] == [] goto done
set wslcmd=%wslcmd% "%~1"
shift
goto start
:done

echo path-convert.sh !wslcmd!;rm -- "$0">"%TEMP_FILE%"
echo path-convert.sh !wslcmd!;rm -- "$0">>"%LOG_FILE%"

rem bash doesn't handle backslashes well so convert them before calling path-convert.sh to avoid single/double quotes being messed up
echo bash -ic "sed -i 's/[\r]//g; s/\\\\/\\//g' $(wslpath '%TEMP_FILE%'); $(wslpath '%TEMP_FILE%')" >> %LOG_FILE%
bash -ic "sed -i 's/[\r]//g; s/\\\\/\\//g' $(wslpath '%TEMP_FILE%'); $(wslpath '%TEMP_FILE%') 2>&1"
