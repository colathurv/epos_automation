# srcm-nbks.py -- A simple web application
# to display salient information from
# SRCM NBKS Repository
#
# Author :: Colathur Vijayan ["VJN"]
#

# Basic Imports

from flask import Flask, render_template, redirect, url_for, request, flash, jsonify
from sqlalchemy import create_engine, asc
from sqlalchemy.orm import sessionmaker
import srcm_nbks_read_db


# Imports for login
from flask import session as login_session
import random
import string
#import httplib2
import json
from flask import make_response
import requests

application = Flask(__name__)


	
@application.route('/searchiteminventory')
def searchItemInventory():
        return render_template('srcmsearchitem.html')
				
				
@application.route('/showiteminventory/<string:sku>')
def showItemInventory(sku):
        print 'showItemInventory'        	
        print 'sku is ' + sku
        try:
        	results = srcm_nbks_read_db.getAllStoreInventory(sku)
        	print results[0][0]
                return render_template('srcmshowinventory.html', sku = sku, results = results)
        except:
                return render_template('srcmsearchitem.html')

@application.route('/showitems', methods = ['POST'])
def showItems():
        print 'showItems'
        search_str = request.form['search_str']
        print 'search_str is ' +  search_str
        try:
        	results = srcm_nbks_read_db.getAllItems(search_str)
        	print results[0][0]
                return render_template('srcmshowitems.html', search_str = search_str, results = results)
        except:
                return render_template('srcmsearchitem.html')

				
if __name__ == '__main__':
        application.secret_key = 'super_secret_key'
	application.debug = True
	#application.run(host = '0.0.0.0', port = 5000)
	application.run(host = '0.0.0.0', port = 8080)
	#application.run()
