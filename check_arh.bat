@ECHO OFF

:: текущаяя дата YYYYMMDD
set day=%DATE:~0,2%
set month=%DATE:~3,2%
set year=%DATE:~6,4%
set YYYYMMDD=%year%%month%%day%
::echo %YYYYMMDD%

SET folder=%1
set "filename="
for /f %%i in ('dir %folder% /b /T:A /A:-D /O:-D *.*') do (
set "filename=%%~i"
goto:finloop
)
:finloop

::echo.%filename%
::echo.%folder%%filename%

REM Получение даты и времени создания файла:
for /f "tokens=1-5 delims=.: " %%j in ('
 dir/a-d/tw "%folder%\%filename%"^| findstr/rc:"^[^ ]"
') do (
 set mydate=%%j.%%k.%%l
 set mymydate=%%l%%k%%j
 set mytime=%%m-%%n
)
::echo %mymydate%
::echo %mydate%
::echo %mytime%

REM Разница двух дат
SET /a COUNT = %YYYYMMDD% - %mymydate%


REM Разница двух дат
REM @powershell -Command "((Get-Date %date%)-(Get-Date %mydate%)).Days"

REM for /f "tokens=1 delims==" %%i in (' @powershell -Command "((Get-Date %date%)-(Get-Date %mydate%)).Days" ') do set "COUNT=%%i"


echo %mydate% %mytime% - Arhiv greated %COUNT% days.
IF %COUNT% GTR 2 ( SET /a COUNT=2 )

exit /b %COUNT%
