# Project
This project grew out of an effort to leverage a publicly available light weight point of sale system 
that volunteers of a non-profit organization can use to sell items in geographically distributed
Brick and Mortar stores and create an **end to end automation** where in data files
created by these systems are loaded to a Relational DB to facilitate Sales and Inventory Reporting,
Web Front End as well as Rest Web Services for Item Lookup/Availability. 

The most important aspect of this project is to create make the automation robust, where in every step
(after the data files are sent by gmail), is entirely taken care of by scripting. 

# Software and Hardware Assumptions
## Store System
1. http://epos4excel.weebly.com/
   
Note that configuring this store system is not explained in this README file. The assumption for this project
is that this system is already configured to create unique store codes (one per store) and that the data files 
created by this system are sent by gmail. 
      
## Sales and Reporting System
1. Windows OS and MySQL client for Windows, to run Batch Scripts (which in turn perform ETL and Reporting)
2. Python 2.7.9 on Windows to run different utilities: 
	- Retrieving attachments from gmail
	- Formatting Reports created from MySQL
	- Uploading to Google Drive
	- Sending email to Store Managers with the Google Drive Link

## Item Lookup and Rest Web Services
1. Ubuntu with a MySQL DB
2. Apache Web server running on Ubuntu
3. Flask running on Ubuntu

# Environment Assumptions ( Test and Production)
0. A Windows 7 machine (with MySQL DB installed) to run Sales and Reporting and 
   Vagrant with Virtual Box for the Web Application [**Test**] 
1. A Windows 7 machine to run Sales and Reporting + AWS RDS (for Database) and 
   AWS EC2 for the Web Application [**Production**]
   
   
## How does all of these add up ?
1. Store Managers use Point of Sale System to perform sales. After end of the day reconciliation they send the 
data files created by email. 
2. The **run_all.bat** when invoked will perform all the steps in item 2 of the Sales and Reporting Section above. 