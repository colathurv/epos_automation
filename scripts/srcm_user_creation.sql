-- Go as MYSQL Root user to create the srcm user 
USE mysql;
show databases ;
create database srcm ;
create user 'srcmadmin' identified by '<Enter the password of this user>' ;
grant all on srcm.* to srcmadmin ;
show grants for 'srcmadmin' ;

