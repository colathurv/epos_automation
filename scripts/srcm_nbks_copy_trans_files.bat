@echo off
REM ##########################################################
REM Author - Colathur Vijayan [VJN]
REM Wrapper Script to invoke copy file script
REM ##########################################################
setlocal EnableDelayedExpansion

echo ######################
set PROPERTY_FILE=%1
set DATESTRING=%2
echo Property file is %property_file%
echo Date String is %datestring%
echo Populating environmental variables from properties file
for /f "eol=# tokens=1,2* delims==" %%i in (%property_file%) do if "%%i" == "EPOSLZHOME"  set EPOSLZHOME=%%j
for /f "eol=# tokens=1,2* delims==" %%i in (%property_file%) do if "%%i" == "EPOSARCHOME"  set EPOSARCHOME=%%j
for /f "eol=# tokens=1,2* delims==" %%i in (%property_file%) do if "%%i" == "STORECODES"  set STORECODES=%%j
echo %EPOSLZHOME%
echo %EPOSARCHOME%
echo %STORECODES%

for /F %%S in (%STORECODES%) do (
	echo Begin Processing store %%S
	del %EPOSLZHOME%\%%S\*.csv
	robocopy "%EPOSARCHOME%\%%S" "%EPOSLZHOME%\%%S" "*%DATESTRING%.csv"
	)