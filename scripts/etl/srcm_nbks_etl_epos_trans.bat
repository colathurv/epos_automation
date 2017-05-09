@echo off
REM ##########################################################
REM Author - Colathur Vijayan [VJN]
REM A batch script that will ETL [Extract, Transform and Load] 
REM EPOS generated CSVs to MySQL
REM ##########################################################
REM : Init :: Populate all required variables from props file 
setlocal EnableDelayedExpansion


echo ################################
echo Begin Loading Transaction Data
set PROPERTY_FILE=%1
echo Property file is %property_file%
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
REM #### EXTRACTION PHASE ########
echo Truncating Staging Table
mysql --defaults-file=%SCRIPTHOME%\srcm.cnf -s -usrcmadmin -e "truncate srcm.srcm_nbks_epos_trans_staging;"
echo Truncation Successful

REM ###########################################
REM In a loop process th CSV files per store
REM ###########################################

for /F %%S in (%STORECODES%) do (
	echo Begin Processing store %%S
	for %%v in (%EPOSLZHOME%\%%S\*.csv) do (
		echo %%v
		set fname=%%v 
		echo Preparing Load file for !fname!
		echo LOAD DATA LOCAL INFILE ^'!fname:\=\\!^'   > %TEMPHOME%\temp1.txt
		echo INTO TABLE srcm.srcm_nbks_epos_trans_staging >> %TEMPHOME%\temp1.txt
		echo FIELDS TERMINATED BY ^'^,^' ENCLOSED BY ^'^"^' >>  %TEMPHOME%\temp1.txt
		echo LINES TERMINATED BY ^'^\n^' >>  %TEMPHOME%\temp1.txt
		echo IGNORE 1 ROWS >>  %TEMPHOME%\temp1.txt
		echo ^(trans_no^, >>  %TEMPHOME%\temp1.txt
		echo item_code^,  >>  %TEMPHOME%\temp1.txt
		echo item_desc^,  >>  %TEMPHOME%\temp1.txt
		echo item_qty^,   >>  %TEMPHOME%\temp1.txt
		echo item_final_price^, >>  %TEMPHOME%\temp1.txt
		echo trans_paytype1^,  >>  %TEMPHOME%\temp1.txt
		echo trans_payment1^, >>  %TEMPHOME%\temp1.txt
		echo trans_paytype2^, >>  %TEMPHOME%\temp1.txt
		echo trans_payment2^, >>  %TEMPHOME%\temp1.txt
		echo trans_paytype3^, >>  %TEMPHOME%\temp1.txt
		echo trans_payment3^, >>  %TEMPHOME%\temp1.txt
		echo trans_paytype4^, >>  %TEMPHOME%\temp1.txt
		echo trans_payment4^, >>  %TEMPHOME%\temp1.txt
		echo trans_paytype5^, >>  %TEMPHOME%\temp1.txt
		echo trans_payment5^, >>  %TEMPHOME%\temp1.txt
		echo item_final_price_withtax^, >>  %TEMPHOME%\temp1.txt
		echo trans_total_withtax^, >>  %TEMPHOME%\temp1.txt
		echo ^@temp_trans_time^, >>  %TEMPHOME%\temp1.txt
		echo trans_memo^, >>  %TEMPHOME%\temp1.txt
		echo item_tax_class^, >>  %TEMPHOME%\temp1.txt
		echo ^@dummy^, >>  %TEMPHOME%\temp1.txt
		echo ^@temp_trans_date^, >>  %TEMPHOME%\temp1.txt
		echo trans_disc_code^, >>  %TEMPHOME%\temp1.txt
		echo trans_sale_no^, >>  %TEMPHOME%\temp1.txt
		echo trans_total_tax^, >>  %TEMPHOME%\temp1.txt
		echo item_adjlist_price_withtax^, >>  %TEMPHOME%\temp1.txt
		echo trans_counter_no^, >>  %TEMPHOME%\temp1.txt
		echo trans_cashier_name^, >>  %TEMPHOME%\temp1.txt
		echo item_disc_code^, >>  %TEMPHOME%\temp1.txt
		echo item_adjlist_price^, >>  %TEMPHOME%\temp1.txt
		echo item_list_price^, >>  %TEMPHOME%\temp1.txt
		echo item_desc2^, >>  %TEMPHOME%\temp1.txt
		echo item_desc3^, >>  %TEMPHOME%\temp1.txt
		echo item_tax_percent^, >>  %TEMPHOME%\temp1.txt
		echo ^@dummy^, >>  %TEMPHOME%\temp1.txt
		echo trans_usd_comment^, >>  %TEMPHOME%\temp1.txt
		echo ^@dummy^, >>  %TEMPHOME%\temp1.txt
		echo ^@dummy^, >>  %TEMPHOME%\temp1.txt
		echo ^@dummy^, >>  %TEMPHOME%\temp1.txt
		echo ^@dummy^, >>  %TEMPHOME%\temp1.txt
		echo ^@dummy ^) >>  %TEMPHOME%\temp1.txt
		echo set trans_date^=str_to_date^(^@temp_trans_date^, ^'%%c^/%%d^/^%%Y^'^)^, >>  %TEMPHOME%\temp1.txt
		echo trans_time^=time_format^(^@temp_trans_time^, ^'%%H^:%%i^:^%%s^'^)^; >>  %TEMPHOME%\temp1.txt
		echo Done preparing Loadfile for %%v
		echo Ready to load ...
		mysql --defaults-file=%SCRIPTHOME%\srcm.cnf -v -usrcmadmin -e "source %TEMPHOME%\temp1.txt" -v --show-warnings
	        echo Done Loading file %%v
	)
	echo Moving files for %%S to the backup zone
	echo First delete them
	del %EPOSBUHOME%\%%S\*.csv
	robocopy %EPOSLZHOME%\%%S %EPOSBUHOME%\%%S *.csv /mov
  	echo End Processing store %%S
)

REM #### TRANSFORM AND LOAD PHASE  ########
mysql --defaults-file=%SCRIPTHOME%\srcm.cnf -v -usrcmadmin -e "source %SCRIPTHOME%\epos_etl_transactions.sql" -v --show-warnings


echo End Loading Transaction Data

