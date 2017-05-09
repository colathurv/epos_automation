@echo off
REM ##########################################################
REM Author - Colathur Vijayan [VJN]
REM A batch script that will create the initial schema
REM required for Automation
REM ##########################################################
setlocal EnableDelayedExpansion

echo ######################
echo Begin Schema Creation
set PROPERTY_FILE=%1
echo Property file is %property_file%
echo Populating environmental variables from properties file
for /f "eol=# tokens=1,2* delims==" %%i in (%property_file%) do if "%%i" == "SCRIPTHOME"  set SCRIPTHOME=%%j
echo %SCRIPTHOME%

REM #### TRANSFORM AND LOAD PHASE  ########
mysql --defaults-file=%SCRIPTHOME%\srcm.cnf -s -usrcmadmin -e "source %SCRIPTHOME%\epos_repo_ddl.sql"
echo End Schema Creation


