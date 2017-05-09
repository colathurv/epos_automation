@echo off
REM ##########################################################
REM Author - Colathur Vijayan [VJN]
REM A batch script that will invoke other modular scripts
REM in sequence and at the end of which Sales and Inventory
REM Reports get created, uploaded to google drive and an email
REM sent to that effect to all bookstores.
REM ##########################################################

setlocal EnableDelayedExpansion

echo ################################
echo Run All Script begins

set DATESTRING=%1


REM  ######### START ON A CLEAN SLATE #######
echo Start on a clean slate
CALL srcm_nbks_del_files.bat C:\vjn\vjnspace\SRCM\epos_report_automation_rds_final\scripts %DATESTRING%
CALL srcm_nbks_del_trans.bat C:\vjn\vjnspace\SRCM\epos_report_automation_rds_final\scripts %DATESTRING%

REM  ######### DOWNLOAD EMAIL ATTACHMENTS IF ANY #######
echo Downloading Files from Gmail
python downloadCSVs.py 

REM  ######### COPYING FILES TO INBOUND ZONE #######
echo Copying Files to Inbound Zone
CALL srcm_nbks_copy_files.bat C:\vjn\vjnspace\SRCM\epos_report_automation_rds_final\scripts %DATESTRING%

REM  ######### RUN EVERY TIME THERE ARE SALES FILES TO LOAD
echo Loading Files to NBKS
CALL srcm_nbks_load.bat C:\vjn\vjnspace\SRCM\epos_report_automation_rds_final\scripts         

REM  #########  RUN EVERY TIME THERE IS A NEED TO RUN A SALES REPORT
echo Running Reports
CALL srcm_nbks_run_reports.bat C:\vjn\vjnspace\SRCM\epos_report_automation_rds_final\scripts %DATESTRING%

REM  #########  UPDATE INVENTORY
echo Updating Inventory
CALL srcm_nbks_update_inventory.bat C:\vjn\vjnspace\SRCM\epos_report_automation_rds_final\scripts\srcm_nbks_auto_init.props

REM  #########  CREATE TRANSACTION TRAIL FOR ITEMS THAT HAVE NEGATIVE INVENTORY
echo Creating Transaction Trail
CALL srcm_nbks_run_inv_and_transtrail_report.bat C:\vjn\vjnspace\SRCM\epos_report_automation_rds_final\scripts

REM  #########  UPLOAD TO GOOGLE DRIVE
echo Uploading to Google Drive
python uploadReports2gdrive.py

REM  ######### SEND EMAIL
echo Sending email to Store Group
python sendSalesandInvReportNotification.py

echo Run All Script completed successfully