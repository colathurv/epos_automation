@echo off
REM ##########################################################
REM Author - Colathur Vijayan [VJN]
REM A batch script that will create Sales and Inventory Reports
REM from the Normalized Schema created for EPOS data
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
for /f "eol=# tokens=1,2* delims==" %%i in (%property_file%) do if "%%i" == "REPORTHOME"  set REPORTHOME=%%j
for /f "eol=# tokens=1,2* delims==" %%i in (%property_file%) do if "%%i" == "STORECODES"  set STORECODES=%%j
for /f "eol=# tokens=1,2* delims==" %%i in (%property_file%) do if "%%i" == "LOGHOME"  set LOGHOME=%%j
echo %SCRIPTHOME%
echo %TEMPHOME%
echo %REPORTHOME%
echo %STORECODES%
echo %DATESTRING%
echo %LOGHOME%
echo Cleaning up temp files from previous run
del %REPORTHOME%\*.csv
del %REPORTHOME%\*.xls
del %LOGHOME%\srcm_nbks_python_report_log


REM ###########################################
REM In a loop create report per store code
REM ###########################################

for /F %%i in (%STORECODES%) do (

        echo Begin Processing store %%i
	REM Creating SQL scripts to be executed based on requested date 
	
	
	echo Creating Transaction Summary Report
	echo use srcm ;  > %TEMPHOME%\temp2.txt
	echo set @store_code = '%%i'; >> %TEMPHOME%\temp2.txt
	echo set @date_string = '%DATESTRING%'; >> %TEMPHOME%\temp2.txt
	type %SCRIPTHOME%\epos_create_bookstore_ts_report.sql >> %TEMPHOME%\temp2.txt
	REM Executing the Script to create the reports
	mysql --defaults-file=%SCRIPTHOME%\srcm.cnf -s -usrcmadmin -e "source %TEMPHOME%\temp2.txt"  > %REPORTHOME%\%%i_%DATESTRING%_TRANS_SUMMARY.csv
		
	echo Creating Item Payments Report
	echo use srcm ;  > %TEMPHOME%\temp2.txt
	echo set @store_code = '%%i'; >> %TEMPHOME%\temp2.txt
	echo set @date_string = '%DATESTRING%'; >> %TEMPHOME%\temp2.txt
	type %SCRIPTHOME%\epos_create_bookstore_ip_report.sql >> %TEMPHOME%\temp2.txt
	REM Executing the Script to create the reports
	mysql --defaults-file=%SCRIPTHOME%\srcm.cnf -s -usrcmadmin -e "source %TEMPHOME%\temp2.txt"  > %REPORTHOME%\%%i_%DATESTRING%_ITEM_PAYMENTS.csv
		
	echo Creating Totals Report
	echo use srcm ;  > %TEMPHOME%\temp2.txt
	echo set @store_code = '%%i'; >> %TEMPHOME%\temp2.txt
	echo set @date_string = '%DATESTRING%'; >> %TEMPHOME%\temp2.txt
	type %SCRIPTHOME%\epos_create_bookstore_totals_report.sql >> %TEMPHOME%\temp2.txt
	REM Executing the Script to create the reports
	REM NOTE:: Totals are appended to Item Payments
	echo "                  " >> %REPORTHOME%\%%i_%DATESTRING%_ITEM_PAYMENTS.csv
	mysql --defaults-file=%SCRIPTHOME%\srcm.cnf -s -usrcmadmin -e "source %TEMPHOME%\temp2.txt"  >> %REPORTHOME%\%%i_%DATESTRING%_ITEM_PAYMENTS.csv
	
	
	echo Creating Total Differential
	echo use srcm ;  > %TEMPHOME%\temp2.txt
	echo set @store_code = '%%i'; >> %TEMPHOME%\temp2.txt
	echo set @date_string = '%DATESTRING%'; >> %TEMPHOME%\temp2.txt
	type %SCRIPTHOME%\epos_create_bookstore_total_differential.sql >> %TEMPHOME%\temp2.txt
	REM Executing the Script to create the reports
	REM NOTE:: Differentials are appended to Total Charges
	echo "                  " >> %REPORTHOME%\%%i_%DATESTRING%_ITEM_PAYMENTS.csv
	mysql --defaults-file=%SCRIPTHOME%\srcm.cnf -s -usrcmadmin -e "source %TEMPHOME%\temp2.txt"  >> %REPORTHOME%\%%i_%DATESTRING%_ITEM_PAYMENTS.csv
	
		
	echo Creating Total Payments Report
	echo use srcm ;  > %TEMPHOME%\temp2.txt
	echo set @store_code = '%%i'; >> %TEMPHOME%\temp2.txt
	echo set @date_string = '%DATESTRING%'; >> %TEMPHOME%\temp2.txt
	type %SCRIPTHOME%\epos_create_bookstore_tp_report.sql >> %TEMPHOME%\temp2.txt
	REM Executing the Script to create the reports
	REM NOTE:: Total Payments are appended to Item Payments
	echo "                  " >> %REPORTHOME%\%%i_%DATESTRING%_ITEM_PAYMENTS.csv
	echo "                  " >> %REPORTHOME%\%%i_%DATESTRING%_ITEM_PAYMENTS.csv
	echo "                  " >> %REPORTHOME%\%%i_%DATESTRING%_ITEM_PAYMENTS.csv
	echo "                  " >> %REPORTHOME%\%%i_%DATESTRING%_ITEM_PAYMENTS.csv
	echo System Calculated Charges >> %REPORTHOME%\%%i_%DATESTRING%_ITEM_PAYMENTS.csv
	mysql --defaults-file=%SCRIPTHOME%\srcm.cnf -s -usrcmadmin -e "source %TEMPHOME%\temp2.txt"  >> %REPORTHOME%\%%i_%DATESTRING%_ITEM_PAYMENTS.csv
	echo "                  " >> %REPORTHOME%\%%i_%DATESTRING%_ITEM_PAYMENTS.csv
        echo "                  " >> %REPORTHOME%\%%i_%DATESTRING%_ITEM_PAYMENTS.csv
	echo Payments Received >> %REPORTHOME%\%%i_%DATESTRING%_ITEM_PAYMENTS.csv
	echo Card, Cash, Check >> %REPORTHOME%\%%i_%DATESTRING%_ITEM_PAYMENTS.csv
	echo "                  " >> %REPORTHOME%\%%i_%DATESTRING%_ITEM_PAYMENTS.csv
        echo "                  " >> %REPORTHOME%\%%i_%DATESTRING%_ITEM_PAYMENTS.csv
        echo Donation Contribution >> %REPORTHOME%\%%i_%DATESTRING%_ITEM_PAYMENTS.csv
	echo Card, Cash, Check >> %REPORTHOME%\%%i_%DATESTRING%_ITEM_PAYMENTS.csv
		
	REM #########
	REM ONLINE CARD TRANSACTION REPORTS SHOULD BE GENERATED ONLY FOR ONLINE STORES
	REM #########	
		
	IF "%%i"=="ONLN" (
	echo This is the ONLINE Store 
	echo %%i
	echo Creating Online Credit Card Transactions Report
	echo use srcm ;  > %TEMPHOME%\temp2.txt
	echo set @store_code = '%%i'; >> %TEMPHOME%\temp2.txt
	echo set @date_string = '%DATESTRING%'; >> %TEMPHOME%\temp2.txt
	type %SCRIPTHOME%\epos_create_bookstore_oc_report.sql >> %TEMPHOME%\temp2.txt
	REM Executing the Script to create the reports
	mysql --defaults-file=%SCRIPTHOME%\srcm.cnf -s -usrcmadmin -e "source %TEMPHOME%\temp2.txt"  >> %REPORTHOME%\%%i_%DATESTRING%_ONLINECRD_TRANS.csv
	
	echo Creating CR Subscriptions Report
	echo use srcm ;  > %TEMPHOME%\temp2.txt
	echo set @store_code = '%%i'; >> %TEMPHOME%\temp2.txt
	echo set @date_string = '%DATESTRING%'; >> %TEMPHOME%\temp2.txt
	type %SCRIPTHOME%\epos_create_bookstore_cr_report.sql >> %TEMPHOME%\temp2.txt
	REM Executing the Script to create the reports
	mysql --defaults-file=%SCRIPTHOME%\srcm.cnf -s -usrcmadmin -e "source %TEMPHOME%\temp2.txt"  >> %REPORTHOME%\%%i_%DATESTRING%_CR_SUBS.csv
		
		
	echo Creating Inventory Report
	echo use srcm ;  > %TEMPHOME%\temp2.txt
	echo set @store_code = '%%i'; >> %TEMPHOME%\temp2.txt
	echo set @date_string = '%DATESTRING%'; >> %TEMPHOME%\temp2.txt
	type %SCRIPTHOME%\epos_create_bookstore_inv_report.sql >> %TEMPHOME%\temp2.txt
	REM Executing the Script to create the reports
	mysql --defaults-file=%SCRIPTHOME%\srcm.cnf -s -usrcmadmin -e "source %TEMPHOME%\temp2.txt"  >> %REPORTHOME%\%%i_%DATESTRING%_INVENTORY.csv
		
	echo Creating Stock Transfer Report
	echo use srcm ;  > %TEMPHOME%\temp2.txt
	echo set @store_code = '%%i'; >> %TEMPHOME%\temp2.txt
	echo set @date_string = '%DATESTRING%'; >> %TEMPHOME%\temp2.txt
	type %SCRIPTHOME%\epos_create_bookstore_st_report.sql >> %TEMPHOME%\temp2.txt
	REM Executing the Script to create the reports
	mysql --defaults-file=%SCRIPTHOME%\srcm.cnf -s -usrcmadmin -e "source %TEMPHOME%\temp2.txt"  >> %REPORTHOME%\%%i_%DATESTRING%_STOCK_TRFR.csv
		
	echo Creating Stock Addition Report
	echo use srcm ;  > %TEMPHOME%\temp2.txt
	echo set @store_code = '%%i'; >> %TEMPHOME%\temp2.txt
	echo set @date_string = '%DATESTRING%'; >> %TEMPHOME%\temp2.txt
	type %SCRIPTHOME%\epos_create_bookstore_sa_report.sql >> %TEMPHOME%\temp2.txt
	REM Executing the Script to create the reports
	mysql --defaults-file=%SCRIPTHOME%\srcm.cnf -s -usrcmadmin -e "source %TEMPHOME%\temp2.txt"  >> %REPORTHOME%\%%i_%DATESTRING%_STOCK_ADDN.csv
		
	echo Creating Shipping Charges Report
	echo use srcm ;  > %TEMPHOME%\temp2.txt
	echo set @store_code = '%%i'; >> %TEMPHOME%\temp2.txt
	echo set @date_string = '%DATESTRING%'; >> %TEMPHOME%\temp2.txt
	type %SCRIPTHOME%\epos_create_bookstore_sc_report.sql >> %TEMPHOME%\temp2.txt
	REM Executing the Script to create the reports
	mysql --defaults-file=%SCRIPTHOME%\srcm.cnf -s -usrcmadmin -e "source %TEMPHOME%\temp2.txt"  >> %REPORTHOME%\%%i_%DATESTRING%_SHIPPING_COST.csv
		
	REM Creating one XLS with CSVs as worksheets
	echo Arguments to csv2wbook.py is %REPORTHOME% and %%i_%DATESTRING%
        python %SCRIPTHOME%\csv2wbook.py %REPORTHOME%  %%i_%DATESTRING%
	echo End Processing store %%i
	goto continue1
	)
	

	echo Creating CR Subscriptions Report
	echo use srcm ;  > %TEMPHOME%\temp2.txt
	echo set @store_code = '%%i'; >> %TEMPHOME%\temp2.txt
	echo set @date_string = '%DATESTRING%'; >> %TEMPHOME%\temp2.txt
	type %SCRIPTHOME%\epos_create_bookstore_cr_report.sql >> %TEMPHOME%\temp2.txt
	REM Executing the Script to create the reports
	mysql --defaults-file=%SCRIPTHOME%\srcm.cnf -s -usrcmadmin -e "source %TEMPHOME%\temp2.txt"  >> %REPORTHOME%\%%i_%DATESTRING%_CR_SUBS.csv
		
        
        echo Creating E-RECEIPT Report
	echo use srcm ;  > %TEMPHOME%\temp2.txt
	echo set @store_code = '%%i'; >> %TEMPHOME%\temp2.txt
	echo set @date_string = '%DATESTRING%'; >> %TEMPHOME%\temp2.txt
	type %SCRIPTHOME%\epos_create_bookstore_er_report.sql >> %TEMPHOME%\temp2.txt
	REM Executing the Script to create the reports
	mysql --defaults-file=%SCRIPTHOME%\srcm.cnf -s -usrcmadmin -e "source %TEMPHOME%\temp2.txt"  >> %REPORTHOME%\%%i_%DATESTRING%_E-RECEIPT.csv
		
		
	
	REM ###### INVENTORY REPORT CREATION IS STOPPED CURRENTLY AS IT IS BECOMING SUB-OPTIMAL
	REM echo Creating Inventory Report
	REM echo use srcm ;  > %TEMPHOME%\temp2.txt
	REM echo set @store_code = '%%i'; >> %TEMPHOME%\temp2.txt
	REM echo set @date_string = '%DATESTRING%'; >> %TEMPHOME%\temp2.txt
	REM type %SCRIPTHOME%\epos_create_bookstore_inv_report.sql >> %TEMPHOME%\temp2.txt
	REM Executing the Script to create the reports
	REM mysql --defaults-file=%SCRIPTHOME%\srcm.cnf -s -usrcmadmin -e "source %TEMPHOME%\temp2.txt"  >> %REPORTHOME%\%%i_%DATESTRING%_INVENTORY.csv
		
	echo Creating Stock Transfer Report
	echo use srcm ;  > %TEMPHOME%\temp2.txt
	echo set @store_code = '%%i'; >> %TEMPHOME%\temp2.txt
	echo set @date_string = '%DATESTRING%'; >> %TEMPHOME%\temp2.txt
	type %SCRIPTHOME%\epos_create_bookstore_st_report.sql >> %TEMPHOME%\temp2.txt
	REM Executing the Script to create the reports
	mysql --defaults-file=%SCRIPTHOME%\srcm.cnf -s -usrcmadmin -e "source %TEMPHOME%\temp2.txt"  >> %REPORTHOME%\%%i_%DATESTRING%_STOCK_TRFR.csv
		
	echo Creating Stock Addition Report
	echo use srcm ;  > %TEMPHOME%\temp2.txt
	echo set @store_code = '%%i'; >> %TEMPHOME%\temp2.txt
	echo set @date_string = '%DATESTRING%'; >> %TEMPHOME%\temp2.txt
	type %SCRIPTHOME%\epos_create_bookstore_sa_report.sql >> %TEMPHOME%\temp2.txt
	REM Executing the Script to create the reports
	mysql --defaults-file=%SCRIPTHOME%\srcm.cnf -s -usrcmadmin -e "source %TEMPHOME%\temp2.txt"  >> %REPORTHOME%\%%i_%DATESTRING%_STOCK_ADDN.csv
		
	echo Creating Shipping Costs Report
	echo use srcm ;  > %TEMPHOME%\temp2.txt
	echo set @store_code = '%%i'; >> %TEMPHOME%\temp2.txt
	echo set @date_string = '%DATESTRING%'; >> %TEMPHOME%\temp2.txt
	type %SCRIPTHOME%\epos_create_bookstore_sc_report.sql >> %TEMPHOME%\temp2.txt
	REM Executing the Script to create the reports
	mysql --defaults-file=%SCRIPTHOME%\srcm.cnf -s -usrcmadmin -e "source %TEMPHOME%\temp2.txt"  >> %REPORTHOME%\%%i_%DATESTRING%_SHIPPING_COST.csv
	
	
	echo Creating Transaction Differential Report
	echo use srcm ;  > %TEMPHOME%\temp2.txt
	echo set @store_code = '%%i'; >> %TEMPHOME%\temp2.txt
	echo set @date_string = '%DATESTRING%'; >> %TEMPHOME%\temp2.txt
	type %SCRIPTHOME%\epos_create_bookstore_trans_differential_report.sql >> %TEMPHOME%\temp2.txt
	REM Executing the Script to create the reports
	REM NOTE:: Differentials are appended to Total Charges
	REM Executing the Script to create the reports
	mysql --defaults-file=%SCRIPTHOME%\srcm.cnf -s -usrcmadmin -e "source %TEMPHOME%\temp2.txt"  >> %REPORTHOME%\%%i_%DATESTRING%_TRANS_DIFFERENTIAL.csv
		
	REM Creating one XLS with CSVs as worksheets
	echo Arguments to csv2wbook.py is %REPORTHOME% and %%i_%DATESTRING%
	REM set PYTHONIOENCODING=utf8
	REM echo python encoding is %PYTHONIOENCODING%
        python %SCRIPTHOME%\csv2wbook.py %REPORTHOME%  %%i_%DATESTRING% >> %LOGHOME%\srcm_nbks_python_report_log
	echo End Processing store %%i

)

:continue1 
echo End Creating Transaction Reports