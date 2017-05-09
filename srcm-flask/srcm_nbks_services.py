# srcm_nbks_services.py -- Implementation of Rest Services that 
#                          return json objects
# Author :: Colathur Vijayan ["VJN"]
#
import sys, os

from flask import Flask, render_template, redirect, url_for, request, flash, jsonify
from sqlalchemy import create_engine, asc
import srcm_nbks_read_db

import json
application = Flask(__name__)
@application.route('/srcmnbks/<item_code>/storeinventory/JSON')
def getAllStoreInventoryJSON(item_code):
        try:
	    results = srcm_nbks_read_db.getAllStoreInventory(item_code)
        except Exception as inst:
            print inst
        #for row in results:
            #x =  row["item_desc"] 
        #print ' x is ' + x
        #return x
        try:
            #t = jsonify(Items = [srcm_nbks_read_db.serializer(r) for r in results] )
            print "Reached Here for Test" 
            #return t
        except Exception as inst:
            print inst
            print "Unexpected Error:" , sys.exc_info()[0]
        else:
            return 'No Exception Raised' 
			
if __name__ == '__main__':
        application.secret_key = 'super_secret_key'
        application.debug = True
	#application.run(host = '0.0.0.0', port = 5000)
	application.run()
