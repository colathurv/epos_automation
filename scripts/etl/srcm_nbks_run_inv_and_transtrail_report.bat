@echo off
REM ##########################################################
REM Author - Colathur Vijayan [VJN]
REM Wrapper Script to invoke delete file script
REM ##########################################################
setlocal EnableDelayedExpansion


set PROPERTY_FILE=%1\srcm_nbks_auto_init.props
echo %PROPERTY_FILE%

for /f "eol=# tokens=1,2* delims==" %%i in (%property_file%) do if "%%i" == "SCRIPTHOME"  set SCRIPTHOME=%%j
for /f "eol=# tokens=1,2* delims==" %%i in (%property_file%) do if "%%i" == "TEMPHOME"  set TEMPHOME=%%j
for /f "eol=# tokens=1,2* delims==" %%i in (%property_file%) do if "%%i" == "REPORTHOME"  set REPORTHOME=%%j
for /f "eol=# tokens=1,2* delims==" %%i in (%property_file%) do if "%%i" == "LOGHOME"  set LOGHOME=%%j


REM Start on a Clean Slate
echo %LOGHOME%
del "%TEMPHOME%\temp1.txt"
del %LOGHOME%\srcm_nbks_inv_and_transtrail_report_log
del %REPORTHOME%\inventory\*.csv

REM Get the System Date 
set $ext=%date:~4%
echo %$ext%
set $ext=%$ext:/=_%
echo %$ext%

echo Start time is %date%_%time% > %LOGHOME%\srcm_nbks_inv_and_transtrail_report_log

REM Executing the Script to create the Consolidated Inventory Report
type %SCRIPTHOME%\epos_create_bookstore_current_inv_report.sql > %TEMPHOME%\temp2.txt
mysql --defaults-file=%SCRIPTHOME%\srcm.cnf -s -usrcmadmin -e "source %TEMPHOME%\temp2.txt" >> %REPORTHOME%\inventory\srcm_nbks_nationwide_inventory_%$ext%.csv

REM Executing the Script to create the Transaction Trail Report
type %SCRIPTHOME%\epos_create_bookstore_negative_transtrail_report.sql > %TEMPHOME%\temp2.txt
mysql --defaults-file=%SCRIPTHOME%\srcm.cnf -s -usrcmadmin -e "source %TEMPHOME%\temp2.txt" >> %REPORTHOME%\inventory\srcm_nbks_negative_qty_transaction_trail_%$ext%.csv
	
echo End time is %date%_%time% >> %LOGHOME%\srcm_nbks_inv_and_transtrail_report_log