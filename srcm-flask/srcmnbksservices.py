# srcmnbks-services.py -- Implementation of Rest Services that 
#                          return json objects
# Author :: Colathur Vijayan ["VJN"]

import sys
from flask import Flask, render_template, redirect, url_for, request, flash, jsonify
from sqlalchemy import create_engine, asc
from sqlalchemy.engine.url import URL
from sqlalchemy.sql import text
import os
import string
import MySQLdb
import json
from srcm_nbks_read_db import *

application = Flask(__name__)


def serializer(storeinv):
    """Return object data in easily serializeable format"""
    return {
                 'Item Title'         : storeinv["item_desc"],
                 'Item Price'         : str(storeinv["item_sale_price"]),
                 'Store Code'         : storeinv["store_code"],
                 'Item Quantity'         : storeinv["calc_inventory"]
           }

@application.route('/<item_code>/storeinventory/JSON')
def getAllStoreInventoryJSON(item_code):
    print "item_code is " + item_code
    results = getAllStoreInventory(item_code)
    try:
         return jsonify(Items = [serializer(r) for r in results] )
    except Exception as inst:
         print inst

def main():
    """Test Function"""
    item_code = 'HBK0000001'
    rslt = getAllStoreInventory(item_code)
    for row in rslt:
         print row["item_desc"]
         print row["store_code"]
         print row["item_sale_price"]
         print row["calc_inventory"]
    
			
if __name__ == '__main__':
    application.run()
    #main()
