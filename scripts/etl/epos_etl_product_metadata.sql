#################################################################
# This script will extract, transform and load product metadata
# to a normalized schema, which will be in turn used
# for creating product data files.
# Author - Colathur Vijayan [VJN]
#################################################################

use srcm ;

 
-- Delete Items from product metadata table that are marked with version as -1
-- provided these item codes are not in any existing transactions.
-- Note that this USE CASE is really for typos in product data file requests.

delete a
from srcm.srcm_nbks_product_metadata as a, srcm.srcm_nbks_product_metadata_staging as b
where a.item_code = b.item_code and b.version = '-1' and a.primary_id <> 0
and a.item_code not in (select item_code from srcm.srcm_nbks_trans_detail) ;
   



-- Extract, transform and populate product metadata table

insert into srcm.srcm_nbks_product_metadata
(
item_code,
item_desc,
item_cost_price,
item_sale_price,
version,
date_str,
is_tax_free       
)
select  
item_code,
item_desc,
item_cost_price,
item_sale_price,
version,
date_str,
is_tax_free
from srcm.srcm_nbks_product_metadata_staging
where version <> '-1'
;