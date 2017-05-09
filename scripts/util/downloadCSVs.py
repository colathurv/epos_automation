################################################################
# Author - Colathur Vijayan [VJN]
# In a loop this script will download CSVs from GMAIL sub folders, 
# named after storecodes. 
################################################################

import email
import getpass, imaplib
import os
import sys

f = open('./srcm_nbks_store_list.txt', 'r')
detach_dir = '../csvfiles/attachments'

# Create directories per storecode in local drive if they do not exist
for scode in f:
    storecode = scode.rstrip();
    if storecode not in os.listdir(detach_dir):
         os.mkdir('../csvfiles/attachments/' + storecode)

# Get User Credentials to connect to GMAIL
userName = raw_input('Enter your GMail username:')
passwd = getpass.getpass('Enter your password: ')
#sStr = raw_input('Enter month in MM format: ')

# Connect to GMAIL, iterating through specific folders 
# to download attachments  
try:
    imapSession = imaplib.IMAP4_SSL('imap.gmail.com')
    typ, accountDetails = imapSession.login(userName, passwd)
    if typ != 'OK':
        print 'Not able to sign in!'
        raise
        
    # Open the metadata file that consists of store codes    
    f = open('./srcm_nbks_store_list.txt', 'r')
    
    # This script will abort only when a folder we expect to find does not exist 
    # in GMAIL. If a folder that we expect to find does exist, but does not have
    # emails with a desired subject, it will continue to the next iteration.
    for scode in f:
         #print "here"
         storecode = scode.rstrip();
         #print storecode
         # Keeping this commented line for Reference. 
         # imapSession.select('[Gmail]/All Mail')
    
    
         # We directly go against the subfolder at the root
         # level.
         imapSession.select('EPOS INBOUND/' + storecode)
         searchStr = '\'\"' + storecode + ' SALES' + '\"\''
         print 'Processing ' + searchStr
         typ, data = imapSession.search(None, 'SUBJECT', searchStr)
         if typ != 'OK':
              print 'Error searching Inbox for ' + storecode
              raise
    
         # Do list reveral to make sure we pick up the latest email
         msgIdList = data[0].split()
         msgIdList.reverse()
    
         # Iterating over all emails in this folder
         for msgId in msgIdList:
              try:
              	typ, messageParts = imapSession.fetch(msgId, '(RFC822)')
              	if typ != 'OK':
              	 	print 'Error fetching mail for ' + storecode
              	 	raise

              	emailBody = messageParts[0][1]
              	mail = email.message_from_string(emailBody)
              	for part in mail.walk():
              		if part.get_content_maintype() == 'multipart':
                 		# print part.as_string()
                 		continue
              		if part.get('Content-Disposition') is None:
                 		# print part.as_string()
                 		continue
              		
              		fileName = part.get_filename()
              		
              		if fileName.find('.csv') <= 0:
              		        continue
              		
              		#print 'Getting File ' + fileName  + ' ' + msgId

              		if bool(fileName):
                		filePath = os.path.join(detach_dir, storecode, fileName)
                		if not os.path.isfile(filePath) :
                   			print 'Writing contents of file ' + fileName + ' ' + msgId
                   			fp = open(filePath, 'wb')
                   			fp.write(part.get_payload(decode=True))
                   			fp.close()
              except Exception, e:
                        print 'Error retrieving attachments for ' + scode
                        continue
               
    imapSession.close()
    imapSession.logout()
except Exception, e:
    print e
    print 'Issue accessing the Gmail Inbox Folder'