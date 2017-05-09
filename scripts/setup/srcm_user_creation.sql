-- Go as MYSQL Root user to create the srcm user 
USE mysql;
show databases ;
create database srcm ;
create user '<username>' identified by '<password>' ;
grant all on srcm.* to <username> ;
show grants for '<username>' ;


-- To let the srcmadmi user to be able to pipe the export to local file system

USE mysql;
UPDATE user SET File_priv = 'Y' WHERE user = '<username>' and host = '%' ;
FLUSH PRIVILEGES;