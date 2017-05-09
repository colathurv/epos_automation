# srcm_nbks_read_db.py -- Implements ORM to read
# item data from srcm store
# Author :: Colathur Vijayan ["VJN"]
#

import os
import sys
import string
import MySQLdb

from sqlalchemy import create_engine
from sqlalchemy.engine.url import URL
from sqlalchemy.sql import text

myDB = URL(drivername='mysql', username='srcmadmin',
    database='srcm',
    query={ 'read_default_file' : '/vagrant/srcm.cnf' }
)

engine = create_engine(name_or_url=myDB)

def getAllStoreInventory(item_code):
    """Helper function to read Items from the database"""
    conn = engine.connect()
    stmt = text( "select"
       " A.item_desc,"
       " A.item_sale_price,"
       " B.store_code,"
       " B.calc_inventory"
" from srcm.srcm_nbks_product_metadata A, srcm.srcm_nbks_inventory B"
" where A.item_code = :x "
" and   A.item_code = B.item_code"
" and (A.item_code, A.version )"
" in"
"("
" select item_code, max(version)"
" from srcm.srcm_nbks_product_metadata"
" group by item_code"
")"
                ) 
    result = conn.execute(stmt, x = item_code).fetchall()
    return result
    conn.close()


def getAllItems(search_str):
    """Helper function to read Items from the database"""
    conn = engine.connect()
    stmt = text( "select"
    	" item_code,"
    	" item_desc,"
    	" item_sale_price," 
    	" date_str"
" from srcm.srcm_nbks_product_metadata A" 
" where match(item_desc, item_code) against(:x IN BOOLEAN MODE)"
" and (A.item_code, A.version )"
" in"
"("
" select B.item_code, max(B.version)"
" from srcm.srcm_nbks_product_metadata B"
" group by B.item_code"
")"
                ) 
    result = conn.execute(stmt, x = search_str).fetchall()
    return result
    conn.close()


def main():
    """Test Function"""
    item_code = 'HBK0000001'
    rslt = getAllStoreInventory(item_code)
    for row in rslt:
        print row["item_desc"]
        print row["store_code"]
        print row["item_sale_price"]
        print row["calc_inventory"]
    
    """Test Function"""
    search_str = 'Principles'
    rslt = getAllItems(search_str)
    for row in rslt:
        print row["item_code"]
        print row["item_desc"]
        print row["item_sale_price"]
        print row["date_str"]
    
    
if __name__ == '__main__':
    main()
