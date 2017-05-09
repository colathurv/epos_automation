##########################################################
# Author - Colathur Vijayan [VJN]
# This script take different CSVs for a store and create 1 XLS
# that will have these as sheets in one workbook
##########################################################
from __future__ import unicode_literals
import glob, csv, xlwt, os, sys

wb = xlwt.Workbook()
# Replace Windows style \ by \\
s = sys.argv[1]
print s
stringdir = s.replace('\\', '\\\\')
print stringdir
try:
	for filename in glob.glob(stringdir + "\\" + sys.argv[2] + "*.csv"):
	    (f_path, f_name) = os.path.split(filename)
	    (f_short_name, f_extension) = os.path.splitext(f_name)
	    print filename
	    try:
		ws = wb.add_sheet(f_short_name)
		spamReader = csv.reader(open(filename, 'rb'))
		for rowx, row in enumerate(spamReader):
			for colx, value in enumerate(row):
				ws.write(rowx, colx, value)
	    except Exception, e:
		print 'Issue while processing ' + filename
		print 'Error encountered is '
		print e
        reportname = stringdir + "\\" + sys.argv[2] + ".xls"
        #wb.save(stringdir + "\\" + sys.argv[2] + ".xls")
        wb.save(reportname)
except Exception, e:
		print 'Issue while processing ' + reportname
		print 'Error encountered is '
		print e
