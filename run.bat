@echo off
echo "init app"
;tasklist /fi "lovr eq lovr.exe" /fo csv 2>search.log | find /I "lovr.exe">NUL
;if "%ERRORLEVEL%"=="0" echo "Program is running"
;echo "check...."

start lovr.exe --console .
pause