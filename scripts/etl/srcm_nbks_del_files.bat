@echo off
REM ##########################################################
REM Author - Colathur Vijayan [VJN]
REM Wrapper Script to invoke delete file script
REM ##########################################################
setlocal EnableDelayedExpansion

set PROPERTY_FILE=%1\srcm_nbks_auto_init.props
set DATE_STRING=%2
for /f "eol=# tokens=1,2* delims==" %%i in (%property_file%) do if "%%i" == "LOGHOME"  set LOGHOME=%%j
del %LOGHOME%\srcm_nbks_del_log
echo %1
echo %2
echo Start time is %date%_%time% > %LOGHOME%\srcm_nbks_del_log
call %1\srcm_nbks_del_trans_files.bat %1\srcm_nbks_auto_init.props %2  >> %LOGHOME%\srcm_nbks_del_log
echo ##################################### >> %LOGHOME%\srcm_nbks_del_log
echo End time is %date%_%time% >> %LOGHOME%\srcm_nbks_del_log