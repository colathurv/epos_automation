#################################################################
# This placeholder script will create the prod data files
# per store, to be used with EPOS, based on the following variable : 
# - store_code.
# Author - Colathur Vijayan [VJN]
#################################################################


### Crank out the CR Subscription Report
select
concat
(
'"',
'Item Code',
'"',
',',
'"',
'Product Description',
'"',
',',
'"',
'Product Price',
'"',
',',
'"',
'Tax Class',
'"',
',',
'"',
'Deal Code',
'"',
',',
'"',
'Description2',
'"'
)
union
select 
concat
(
'"',
item_code,
'"',
',',
'"',
item_desc,
'"',
',',
'"',
item_sale_price,
'"',
',',
'"',
tax_class,
'"',
',',
'"',
deal_code,
'"',
',',
'"',
desc2,
'"'
)
from
(
select A.item_code, 
       A.item_desc, 
       A.item_sale_price, 
       IF(A.is_tax_free = 'N', B.tax_class, 'T0') as tax_class,
       '' as deal_code,
       concat(A.date_str,'-',A.version) as desc2
	   
from srcm.srcm_nbks_product_metadata A, srcm.srcm_nbks_state_tax_rates B
where (A.item_code, A.version )
in
(
select item_code, max(version) 
from srcm.srcm_nbks_product_metadata
where item_code not in (select item_code from srcm.srcm_nbks_product_metadata where version = 0)
group by item_code
)
and B.store_code = @store_code
order by item_code
) T ;
