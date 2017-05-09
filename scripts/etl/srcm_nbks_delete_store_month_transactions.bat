@echo off
REM ##########################################################
REM Author - Colathur Vijayan [VJN]
REM A batch script that will delete EPOS Transactions 
REM for a store in the store list and for a specific month
REM ##########################################################
REM : Init :: Populate all required variables from props file 
setlocal EnableDelayedExpansion


echo ################################
echo Begin Loading Transaction Data
set PROPERTY_FILE=%1
set DATESTRING=%2
echo Property file is %property_file%
echo Date String is %datestring%
echo Populating environmental variables from properties file
for /f "eol=# tokens=1,2* delims==" %%i in (%property_file%) do if "%%i" == "SCRIPTHOME"  set SCRIPTHOME=%%j
for /f "eol=# tokens=1,2* delims==" %%i in (%property_file%) do if "%%i" == "TEMPHOME"  set TEMPHOME=%%j
for /f "eol=# tokens=1,2* delims==" %%i in (%property_file%) do if "%%i" == "EPOSTRANSHOME"  set EPOSTRANSHOME=%%j
for /f "eol=# tokens=1,2* delims==" %%i in (%property_file%) do if "%%i" == "STORECODES"  set STORECODES=%%j
for /f "eol=# tokens=1,2* delims==" %%i in (%property_file%) do if "%%i" == "EPOSLZHOME"  set EPOSLZHOME=%%j
for /f "eol=# tokens=1,2* delims==" %%i in (%property_file%) do if "%%i" == "EPOSBUHOME"  set EPOSBUHOME=%%j
echo %SCRIPTHOME%
echo %TEMPHOME%
echo %EPOSTRANSHOME%
echo %STORECODES%
echo %EPOSLZHOME%
echo %EPOSBUHOME%
echo Cleaning up temp files from previous run
del "%TEMPHOME%\temp1.txt"

REM ###########################################
REM In a loop process each store
REM ###########################################

for /F %%S in (%STORECODES%) do (
	echo Begin Processing store %%S
        echo Creating Shipping Costs Report
	echo use srcm ;  > %TEMPHOME%\temp1.txt
	echo set @store_code = '%%S'; >> %TEMPHOME%\temp1.txt
	echo set @trans_month = '%DATESTRING%'; >> %TEMPHOME%\temp1.txt
	type %SCRIPTHOME%\epos_delete_store_month_transactions.sql >> %TEMPHOME%\temp1.txt
	REM Executing the Script to create the reports
	mysql --defaults-file=%SCRIPTHOME%\srcm.cnf -v -s -usrcmadmin -e "source %TEMPHOME%\temp1.txt" -v --show-warnings
)


