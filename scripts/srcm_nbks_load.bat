@echo off
setlocal
REM ##########################################################
REM Author - Colathur Vijayan [VJN]
REM The driver script for loading EPOS transactions CSVs 
REM which in turn will call other batch scripts
REM ##########################################################

set PROPERTY_FILE=%1\srcm_nbks_auto_init.props
for /f "eol=# tokens=1,2* delims==" %%i in (%property_file%) do if "%%i" == "LOGHOME"  set LOGHOME=%%j

del %LOGHOME%\srcm_nbks_load_log
echo %1
echo Start time is %date%_%time% >> %LOGHOME%\srcm_nbks_load_log
call %1\srcm_nbks_etl_epos_trans.bat %1\srcm_nbks_auto_init.props  >> %LOGHOME%\srcm_nbks_load_log
echo ##############################  >> %LOGHOME%\srcm_nbks_load_log
echo End time is %date%_%time% >> %LOGHOME%\srcm_nbks_load_log
