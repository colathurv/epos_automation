@echo off
setlocal
REM ##########################################################
REM Author - Colathur Vijayan [VJN]
REM The driver script for loading Product Metadata CSV 
REM for all products
REM ##########################################################

set PROPERTY_FILE=%1\srcm_nbks_auto_init.props
for /f "eol=# tokens=1,2* delims==" %%i in (%property_file%) do if "%%i" == "LOGHOME"  set LOGHOME=%%j
del %LOGHOME%\srcm_nbks_meta_log
echo %1
echo Start time is %date%_%time% >> %LOGHOME%\srcm_nbks_meta_log
call %1\srcm_nbks_load_prod_metadata.bat %1\srcm_nbks_auto_init.props >> %LOGHOME%\srcm_nbks_meta_log
echo ######################   >> %LOGHOME%\srcm_nbks_meta_log
echo End time is %date%_%time% >> %LOGHOME%\srcm_nbks_meta_log