@echo off
setlocal
REM ##########################################################
REM Author - Colathur Vijayan [VJN]
REM The driver script for running reports 
REM which in turn will call other batch scripts
REM ##########################################################

set PROPERTY_FILE=%1\srcm_nbks_auto_init.props
for /f "eol=# tokens=1,2* delims==" %%i in (%property_file%) do if "%%i" == "LOGHOME"  set LOGHOME=%%j
del %LOGHOME%\srcm_nbks_reports_log
echo %1
echo Start time is %date%_%time% >> %LOGHOME%\srcm_nbks_reports_log

REM ###### INVENTORY REPORT CREATION IS STOPPED CURRENTLY AS IT IS BECOMING SUB-OPTIMAL
REM call %1\srcm_nbks_update_inventory.bat %1\srcm_nbks_auto_init.props  >> %LOGHOME%\srcm_nbks_reports_log

call %1\srcm_nbks_update_inventory_new_items.bat %1\srcm_nbks_auto_init.props  >> %LOGHOME%\srcm_nbks_reports_log

call %1\srcm_nbks_report_trans.bat %1\srcm_nbks_auto_init.props %2 >> %LOGHOME%\srcm_nbks_reports_log
echo ##################################### >> %LOGHOME%\srcm_nbks_reports_log
echo End time is %date%_%time% >> %LOGHOME%\srcm_nbks_reports_log