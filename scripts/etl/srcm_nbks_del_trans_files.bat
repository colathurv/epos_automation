@echo off
REM ##########################################################
REM Author - Colathur Vijayan [VJN]
REM A batch script that will delete transaction files downloaded from  
REM GMAIL in the attachments folder, for a specific month.
REM ##########################################################
setlocal EnableDelayedExpansion

echo ######################
set PROPERTY_FILE=%1
set DATESTRING=%2
echo Property file is %property_file%
echo Date String is %datestring%
echo Populating environmental variables from properties file
for /f "eol=# tokens=1,2* delims==" %%i in (%property_file%) do if "%%i" == "EPOSARCHOME"  set EPOSARCHOME=%%j
for /f "eol=# tokens=1,2* delims==" %%i in (%property_file%) do if "%%i" == "STORECODES"  set STORECODES=%%j
echo %EPOSARCHOME%
echo %STORECODES%

for /F %%S in (%STORECODES%) do (
	echo Begin Processing store %%S
	del %EPOSARCHOME%\%%S\*%DATESTRING%.csv"
	)