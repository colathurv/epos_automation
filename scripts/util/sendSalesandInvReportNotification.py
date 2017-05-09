################################################################
# Author - Colathur Vijayan [VJN]
# This script is used to send a notification to Bookstore group
# about availability of reports in Google Drive.
################################################################

from email.mime.text import MIMEText
from email.mime.application import MIMEApplication
from email.mime.multipart import MIMEMultipart
from smtplib import SMTP
import smtplib
import os
import sys
import getpass, imaplib
import datetime
import csv


# Get Input
userName = raw_input('Enter your GMail username:')
passwd = getpass.getpass('Enter your password: ')
dateStr = str(raw_input('Enter month in MMYYYY format: '))
customStr = raw_input('Enter any Custom String to append to Subject:')


# Use Input
userName = userName + '@gmail.com'
formattedDate = datetime.datetime.strptime(dateStr, "%m%Y")
monthStr = formattedDate.strftime("%b %Y")

# Initialize and login to email Server
server = smtplib.SMTP("smtp.gmail.com:587")
server.ehlo()
server.starttls()	
server.login(userName, passwd)
recipients = ['<Enter email>', '<Enter email>']
emaillist = [elem.strip().split(',') for elem in recipients]
msg = MIMEMultipart()		
msg['From'] = userName
Subject = monthStr + ' SALES AND INVENTORY REPORT UPDATE IN GOOGLE DRIVE' + customStr  		
msg['Subject'] = Subject 		
msg.preamble = 'Multipart message.\n'

# Read template file and transcribe to body of email
try:
    ef = open("./reports_and_inv_email_body.html","r")
    text = ef.read()
    part = MIMEText(text, 'html')
    ef.close()
    msg.attach(part)	
    server.sendmail(msg['From'], emaillist , msg.as_string())
    server.quit()
    print "Email sent successfully"
    
except Exception, e:
    print e
    print 'Issue sending email'
    sys.exit(0)