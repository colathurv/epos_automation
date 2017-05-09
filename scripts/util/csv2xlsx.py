##########################################################
# Author - Colathur Vijayan [VJN]
# This script takes a CSV and saves it as an XLSX workbook
# that will have these as sheets in one workbook
##########################################################
from __future__ import unicode_literals
import glob, csv, os, sys, xlsxwriter

# Replace Windows style \ by \\
s = sys.argv[1]
print s
stringdir = s.replace('\\', '\\\\')
print stringdir

try:
	for filename in glob.glob(stringdir + "\\" + sys.argv[2] + ".csv"):
	    (f_path, f_name) = os.path.split(filename)
	    (f_short_name, f_extension) = os.path.splitext(f_name)
	    print filename
	    try:
	        wb = xlsxwriter.Workbook(stringdir + "\\" + sys.argv[2] + '.xlsx')
		ws = wb.add_worksheet(f_short_name)
		spamReader = csv.reader(open(filename, 'rb'))
		for rowx, row in enumerate(spamReader):
			for colx, value in enumerate(row):
				ws.write(rowx, colx, value)
                wb.close()
	    except Exception, e:
		print 'Issue while processing ' + filename
		print 'Error encountered is '
		print e
except Exception, e:
		print 'Issue while processing ' + filename
		print 'Error encountered is '
		print e