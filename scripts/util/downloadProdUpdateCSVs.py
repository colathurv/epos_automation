################################################################
# Author - Colathur Vijayan [VJN]
# In a loop this script will download Product metadata 
# CSVs from an appropriate GMAIL sub folder.
################################################################

import email
import getpass, imaplib
import os
import sys

detach_dir = '../csvfiles/metadata'

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
        
    # This script will abort either when a folder we expect to find does not exist 
    # or does not have emails with a desired subject.
   
    imapSession.select('EPOS INBOUND/PROD UPDATE')
    searchStr = '\'\"' + 'APPROVED UPLOAD PRODUCT METADATA' + '\"\''
    print 'Processing ' + searchStr
    typ, data = imapSession.search(None, 'SUBJECT', searchStr)
    if typ != 'OK':
        print 'Error searching Inbox ... '
        raise
    
    # Do list reveral to make sure we pick up the latest email
    msgIdList = data[0].split()
    msgIdList.reverse()
    
    # Iterating over all emails in this folder
    for msgId in msgIdList:
        try:
             typ, messageParts = imapSession.fetch(msgId, '(RFC822)')
             if typ != 'OK':
                  print 'Error fetching mail ... '
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
                       filePath = os.path.join(detach_dir, fileName)
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