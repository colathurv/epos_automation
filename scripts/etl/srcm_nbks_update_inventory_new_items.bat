@echo off
REM ##########################################################
REM Author - Colathur Vijayan [VJN]
REM A batch script that will update inventory
REM by calling the update inventory SQL
REM ##########################################################
REM #### EXTRACTION PHASE ########
setlocal EnableDelayedExpansion



echo ################################
echo Begin Updating Inventory
set PROPERTY_FILE=%1
echo Property file is %property_file%
echo Populating environmental variables from properties file
for /f "eol=# tokens=1,2* delims==" %%i in (%property_file%) do if "%%i" == "SCRIPTHOME"  set SCRIPTHOME=%%j
for /f "eol=# tokens=1,2* delims==" %%i in (%property_file%) do if "%%i" == "TEMPHOME"  set TEMPHOME=%%j
for /f "eol=# tokens=1,2* delims==" %%i in (%property_file%) do if "%%i" == "STORECODES"  set STORECODES=%%j
echo %SCRIPTHOME%
echo %TEMPHOME%
echo %STORECODES%

REM ###########################################
REM In a loop update inventory per store code
REM ###########################################
for /F %%i in (%STORECODES%) do (
  REM Creating SQL scripts to be executed based on requested date 
  echo Begin Processing store %%i
  echo use srcm ;  > %TEMPHOME%\temp2.txt
  echo set @store_code = '%%i'; >> %TEMPHOME%\temp2.txt
  type %SCRIPTHOME%\epos_update_inventory_new_items.sql >> %TEMPHOME%\temp2.txt
  
  REM Executing the Script to create the reports
  mysql --defaults-file=%SCRIPTHOME%\srcm.cnf -s -usrcmadmin -e "source %TEMPHOME%\temp2.txt"
  echo End Processing store %%i
)

echo End Updating Inventory