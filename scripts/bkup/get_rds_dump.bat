@echo off

REM Get the mysqldump file from amazon
mysqldump --defaults-file=.\srcm.cnf -u<username> --databases srcm > rds_dump.sql
REM Apply the mysqldump file to local instance
mysql -u<username> -p<password> srcm < rds_dump.sql