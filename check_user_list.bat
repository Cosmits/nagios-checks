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
if %1 == Администратор (
 SET USER=%USER% Admin
 ) ELSE (
 
 if %1 == 1 (
  SET USER=%USER%
  ) ELSE (
 
  SET USER=%USER% %1
  )
 )
 
if %1 == 1 set res=true
if %1 == 2 set res=true
if %1 == 3 set res=true
if %1 == 4 set res=true
if %1 == 5 set res=true
if %1 == 6 set res=true
if %1 == 7 set res=true
if %1 == 8 set res=true
if %1 == 9 set res=true
if defined res ( 
    SET CORR=1
) else (
    SET CORR=0
)

 
set /a COUNT=%COUNT%-%CORR%
GOTO :eof


:end
::ECHO %MS% - Number of active sessions = %COUNT% ^| Logged Users = !USER!
ECHO Active sessions = %COUNT% /!USER!
start taskkill /IM dllhost.exe /F
EXIT /b %EX%
