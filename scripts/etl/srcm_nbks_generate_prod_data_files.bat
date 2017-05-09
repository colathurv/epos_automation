@echo off
REM ##########################################################
REM Author - Colathur Vijayan [VJN]
REM A batch script that will create store specific 
REM product files to be used with EPOS
REM ##########################################################
REM #### EXTRACTION PHASE ########
setlocal EnableDelayedExpansion

echo ################################
echo Begin Creating Transaction Reports
set PROPERTY_FILE=%1
set DATESTRING=%2
echo Property file is %property_file%
echo Date String is %datestring%
echo Populating environmental variables from properties file
for /f "eol=# tokens=1,2* delims==" %%i in (%property_file%) do if "%%i" == "SCRIPTHOME"  set SCRIPTHOME=%%j
for /f "eol=# tokens=1,2* delims==" %%i in (%property_file%) do if "%%i" == "TEMPHOME"  set TEMPHOME=%%j
for /f "eol=# tokens=1,2* delims==" %%i in (%property_file%) do if "%%i" == "MDREPORTHOME"  set MDREPORTHOME=%%j
for /f "eol=# tokens=1,2* delims==" %%i in (%property_file%) do if "%%i" == "PRODSTORECODES"  set PRODSTORECODES=%%j
for /f "eol=# tokens=1,2* delims==" %%i in (%property_file%) do if "%%i" == "LOGHOME"  set LOGHOME=%%j
echo %SCRIPTHOME%
echo %TEMPHOME%
echo %MDREPORTHOME%
echo %PRODSTORECODES%
echo %DATESTRING%
echo %LOGHOME%
echo Cleaning up temp files from previous run
del %MDREPORTHOME%\*.csv
del %MDREPORTHOME%\*.xls
del %LOGHOME%\srcm_nbks_python_report_log


REM ###########################################
REM In a loop create report per store code
REM ###########################################

for /F %%i in (%PRODSTORECODES%) do (

        echo Begin Processing store %%i
	REM Creating SQL script to be executed 
	
	
	echo Creating Product Data File
	echo use srcm ;  > %TEMPHOME%\temp2.txt
	echo set @store_code = '%%i'; >> %TEMPHOME%\temp2.txt
	type %SCRIPTHOME%\epos_create_prod_data_files.sql >> %TEMPHOME%\temp2.txt
	REM Executing the Script to create the prod data files
	mysql --defaults-file=%SCRIPTHOME%\srcm.cnf -s -usrcmadmin -e "source %TEMPHOME%\temp2.txt"  > %MDREPORTHOME%\%%i_proddatafile.csv
		
		
	REM Creating one XLS with CSVs as worksheets
	echo Arguments to csv2wbook.py is %MDREPORTHOME% and %%i_proddatafile
	REM set PYTHONIOENCODING=utf8
	REM echo python encoding is %PYTHONIOENCODING%
        python %SCRIPTHOME%\csv2xlsx.py %MDREPORTHOME%  %%i_proddatafile >> %LOGHOME%\srcm_nbks_python_report_log
	echo End Processing store %%i
)

echo End Creating Product Data Files