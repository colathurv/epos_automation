@echo off
REM ##########################################################
REM Author - Colathur Vijayan [VJN]
REM A batch script that will load initial inventory data from
REM a CSV file to a staging area, extract and load it to
REM the inventory tables.
REM ##########################################################
REM #### EXTRACTION PHASE ########
setlocal EnableDelayedExpansion


echo ################################
echo Begin Loading initial inventory
set PROPERTY_FILE=%1
echo Property file is %property_file%
echo Populating environmental variables from properties file
for /f "eol=# tokens=1,2* delims==" %%i in (%property_file%) do if "%%i" == "SCRIPTHOME"  set SCRIPTHOME=%%j
for /f "eol=# tokens=1,2* delims==" %%i in (%property_file%) do if "%%i" == "TEMPHOME"  set TEMPHOME=%%j
for /f "eol=# tokens=1,2* delims==" %%i in (%property_file%) do if "%%i" == "EPOSSTOCKHOME"  set EPOSSTOCKHOME=%%j
echo %SCRIPTHOME%
echo %TEMPHOME%
echo %EPOSSTOCKHOME%
echo Cleaning up temp files from previous run
del "%TEMPHOME%\temp1.txt"
REM #### EXTRACTION PHASE ########
echo Truncating Staging Table
mysql --defaults-file=%SCRIPTHOME%\srcm.cnf -s -usrcmadmin -e "truncate srcm.srcm_nbks_item_init_count_staging ;"
echo Truncation Successful
for %%v in (%EPOSSTOCKHOME%\*.csv) do (
echo %%v
set fname=%%v 
echo Preparing Load file for !fname!
echo LOAD DATA LOCAL INFILE ^'!fname:\=\\!^'   > %TEMPHOME%\temp1.txt
echo INTO TABLE srcm.srcm_nbks_item_init_count_staging >> %TEMPHOME%\temp1.txt
echo FIELDS TERMINATED BY ^'^,^' ENCLOSED BY ^'^"^' >>  %TEMPHOME%\temp1.txt
echo LINES TERMINATED BY ^'^\n^' >>  %TEMPHOME%\temp1.txt
echo ^(store_code^, >>  %TEMPHOME%\temp1.txt
echo item_code^,  >>  %TEMPHOME%\temp1.txt
echo item_desc^, >> %TEMPHOME%\temp1.txt
echo qty_delivered^  >>  %TEMPHOME%\temp1.txt
echo ^) >>  %TEMPHOME%\temp1.txt
echo Done preparing Loadfile for %%v
echo Ready to load ...
mysql --defaults-file=%SCRIPTHOME%\srcm.cnf -v -s -usrcmadmin -e "source %TEMPHOME%\temp1.txt"
echo Done Loading file %%v
)

REM #### TRANSFORM AND LOAD PHASE  ########
mysql --defaults-file=%SCRIPTHOME%\srcm.cnf -s -usrcmadmin -e "source %SCRIPTHOME%\epos_etl_init_inventory.sql"

echo End Loading initial inventory