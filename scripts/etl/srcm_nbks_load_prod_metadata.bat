@echo off
REM ##########################################################
REM Author - Colathur Vijayan [VJN]
REM A batch script that will load product metadata from
REM a CSV file to a staging area.
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
for /f "eol=# tokens=1,2* delims==" %%i in (%property_file%) do if "%%i" == "EPOSMETADATAHOME"  set EPOSMETADATAHOME=%%j
echo %SCRIPTHOME%
echo %TEMPHOME%
echo %EPOSMETADATAHOME%
echo Cleaning up temp files from previous run
del "%TEMPHOME%\temp1.txt"
REM #### EXTRACTION PHASE ########
echo Truncating Staging Table
mysql --defaults-file=%SCRIPTHOME%\srcm.cnf -s -usrcmadmin -e "truncate srcm.srcm_nbks_product_metadata_staging ;"
echo Truncation Successful
for %%v in (%EPOSMETADATAHOME%\*productmetadata*.csv) do (
echo %%v
set fname=%%v 
echo Preparing Load file for !fname!
echo LOAD DATA LOCAL INFILE ^'!fname:\=\\!^'   > %TEMPHOME%\temp1.txt
echo INTO TABLE srcm.srcm_nbks_product_metadata_staging >> %TEMPHOME%\temp1.txt
echo FIELDS TERMINATED BY ^'^,^' ENCLOSED BY ^'^"^' >>  %TEMPHOME%\temp1.txt
echo LINES TERMINATED BY ^'^\n^' >>  %TEMPHOME%\temp1.txt
echo IGNORE 1 ROWS >>  %TEMPHOME%\temp1.txt
echo ^(item_code^, >>  %TEMPHOME%\temp1.txt
echo item_desc^, >> %TEMPHOME%\temp1.txt
echo item_cost_price^,  >>  %TEMPHOME%\temp1.txt
echo item_sale_price^,  >>  %TEMPHOME%\temp1.txt
echo version^,  >>  %TEMPHOME%\temp1.txt
echo date_str^,  >>  %TEMPHOME%\temp1.txt
echo is_tax_free^  >>  %TEMPHOME%\temp1.txt
echo ^) >>  %TEMPHOME%\temp1.txt
echo Done preparing Loadfile for %%v
echo Ready to load ...
mysql --defaults-file=%SCRIPTHOME%\srcm.cnf -v -s -usrcmadmin -e "source %TEMPHOME%\temp1.txt" -v --show-warnings
echo Done Loading file %%v
)


REM #### TRANSFORM AND LOAD PHASE  ########
mysql --defaults-file=%SCRIPTHOME%\srcm.cnf -v -usrcmadmin -e "source %SCRIPTHOME%\epos_etl_product_metadata.sql" -v --show-warnings


echo End Loading Product Metadata