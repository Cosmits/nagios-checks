@ECHO Off
setlocal EnableDelayedExpansion
REM -------------------------------------------
REM - Version 0.4 - By briandent@redshift.com
REM - Original Version
REM -------------------------------------------
REM - Version 0.5 - By julienchpt@gmail.com
REM - ADD CRITICAL AND WARNING STATUS
REM -------------------------------------------
REM - Version 0.6 - By roberto.mereu@gmail.com
REM - ADD USERNAME LOGGED IN
REM -------------------------------------------
REM - Version 0.7 - By ejo1974@yahoo.com
REM - Bugfix
REM - Formatting changes
REM -------------------------------------------
REM USAGE: check_user_count warn crit
REM warn: Number of session before warning 
REM crit: Number of session before Critical
REM Example: check_user_count 2 4
REM -------------------------------------------
REM CALLING SEQUENCE: 
REM command[nrpe_nt_check_users]=c:nrpe_ntpluginscheck_user_count.bat $ARG1$ $ARG2$
REM -------------------------------------------
set EX=0 
set MS=OK 
SET /a COUNT=0
SET USER=
FOR /f "TOKENS=1" %%i IN ('query session ^|find "rdp-tcp#"') DO SET /a COUNT+=1
FOR /f "TOKENS=2" %%G IN ('query session ^|find "rdp-tcp#"') DO (
call :subroutine %%G
)

FOR /f "TOKENS=1" %%i IN ('query session ^|find "console"') DO SET /a COUNT+=1
FOR /f "TOKENS=2" %%G IN ('query session ^|find "console"') DO (
call :subroutine %%G
)


REM - CRITICAL (COUNT => $2)
::if %COUNT% GEQ %2 ( set EX=2 && set MS=CRITICAL && goto end )

REM - OK (COUNT = 0)
if %COUNT% EQU 0 ( set EX=0 && set MS=OK && goto end )

REM - WARNING (COUNT => $1)
if %COUNT% GEQ %1 ( set EX=1 && set MS=WARNING && goto end )




REM - NOT CRITICAL / WARNING
set EX=0
set CORR=0
set MS=OK
goto end

:subroutine
::ECHO qwe %1
set word=%1

set word=%word:�=a%
SET word=%word:�=b%
SET word=%word:�=v%
SET word=%word:�=g%
SET word=%word:�=d%
SET word=%word:�=e%
SET word=%word:�=jo%
SET word=%word:�=zh%
SET word=%word:�=z%
SET word=%word:�=i%
SET word=%word:?=i%
SET word=%word:�=ji%
SET word=%word:�=j%
SET word=%word:�=k%
SET word=%word:�=l%
SET word=%word:�=m%
SET word=%word:�=n%
SET word=%word:�=o%
SET word=%word:�=p%
SET word=%word:�=r%
SET word=%word:�=s%
SET word=%word:�=t%
SET word=%word:�=u%
SET word=%word:�=f%
SET word=%word:�=h%
SET word=%word:�=ts%
SET word=%word:�=ch%
SET word=%word:�=sh%
SET word=%word:�=sch%
SET word=%word:�="%
SET word=%word:�=y%
SET word=%word:�=`%
SET word=%word:�=e%
SET word=%word:�=ju%
SET word=%word:�=ja%

::echo qwe %word% 222

 
::SET USER=%USER% %word%
 
if %1 GEQ 1 if %1 LEQ 20 set res=true
if defined res ( 
    SET CORR=1
	SET USER=%USER%
) else (
    SET CORR=0
	SET USER=%USER% %word%
)

 
set /a COUNT=%COUNT%-%CORR%
GOTO :eof


:end
::ECHO %MS% - Number of active sessions = %COUNT% ^| Logged Users = !USER!
ECHO Active sessions = %COUNT% /!USER!
start taskkill /IM dllhost.exe /F
EXIT /b %EX%
