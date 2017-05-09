@echo off
setlocal
REM ##########################################################
REM Author - Colathur Vijayan [VJN]
REM The driver script for creating SRCM Schema and DB objects
REM required for automation which will also load beginning 
REM inventory of products for all stores.
REM ##########################################################

set PROPERTY_FILE=%1\srcm_nbks_auto_init.props
for /f "eol=# tokens=1,2* delims==" %%i in (%property_file%) do if "%%i" == "LOGHOME"  set LOGHOME=%%j
del %LOGHOME%\srcm_nbks_setup_log
echo %1
echo Start time is %date%_%time% >> %LOGHOME%\srcm_nbks_setup_log
call %1\srcm_nbks_create_schema.bat %1\srcm_nbks_auto_init.props >> %LOGHOME%\srcm_nbks_setup_log
call %1\srcm_nbks_etl_init_inventory.bat %1\srcm_nbks_auto_init.props  >> %LOGHOME%\srcm_nbks_setup_log
echo ######################   >> %LOGHOME%\srcm_nbks_setup_log
echo End time is %date%_%time% >> %LOGHOME%\srcm_nbks_setup_log