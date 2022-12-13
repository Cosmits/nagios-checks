@echo off

ipconfig /flushdns

:: HOST NAME in Internet
set ComputerName=host.xxx.cloudns.cl

:: URL NAME
::set ComputerName=%1
set DDNS_URL=https://ipv4.cloudns.net/api/dynamicURL/?q=any-token

::URL for detect Public IPAddress this computer
set whatismyip=http://whatismyip.akamai.com/

echo ============================================

for /f "delims=" %%a in ('curl -s %whatismyip%') do @set ThisIP=%%a
:: get result from curl and set in variable  ThisIP
echo URL  IP: %ThisIP%

for /f "delims=[] tokens=2" %%a in ('ping -4 -n 1 %ComputerName% ^| findstr [') do set HOSTIP=%%a
echo HOST IP: %HOSTIP%

if %HOSTIP%==%ThisIP% (
	echo Not update IP
) ELSE (
	curl -s %DDNS_URL%
	echo    Update IP
)
echo ============================================

set DDNS_URL="https://www.duckdns.org/update?domains=<host>&token=<token>&ip="
curl -s %DDNS_URL%

"C:\Program Files\Windows Defender\MpCmdRun.exe" -SignatureUpdate
exit
