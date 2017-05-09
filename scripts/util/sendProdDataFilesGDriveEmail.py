################################################################
# Author - Colathur Vijayan [VJN]
# Adaptation of an existing Python Script.
# This sends an email to EPOS Group about product data files being in 
# Google Drive.
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
customStr = raw_input('Enter any Custom String to append to Subject:')


# Use Input
userName = userName + '@gmail.com'


# Initialize and login to email Server
server = smtplib.SMTP("smtp.gmail.com:587")
server.ehlo()
server.starttls()	
server.login(userName, passwd)



recipients = ['<Enter email>']
emaillist = [elem.strip().split(',') for elem in recipients]
msg = MIMEMultipart()		
msg['From'] = userName
Subject = 'NEW PRODUCT DATA FILES IN GOOGLE DRIVE'  		
msg['Subject'] = Subject 		
msg.preamble = 'Multipart message.\n'

try:
    
    ef = open("./produpdate_email_body.html","r")
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