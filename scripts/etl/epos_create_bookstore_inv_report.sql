#################################################################
# This placeholder script will create the inventory report
# based on the user variables - store_code and date_string.
# Author - Colathur Vijayan [VJN]
#################################################################


### Crank out the Inventory Report
select 
concat
(
'"',
'Item Code',
'"',
',',
'"',
'Description',
'"',
',',
'"',
'Beginning Inventory',
'"',
',',
'"',
'System Calculated Inventory',
'"',
',',
'"',
'Last Updated Date',
'"',
',',
'"',
'Product Creation Date',
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
beginning_inventory, 
'"',
',',
'"',
calc_inventory, 
'"',
',',
'"',
last_updated_date,
'"',
',',
'"',
creation_date,
'"'
)
from
(
select item_code, item_desc, beginning_inventory, calc_inventory, last_updated_date, creation_date
from srcm.srcm_nbks_inventory 
where item_code not in ('SHIP', 'SHIP-ADJ', 'SBK0000053')
and store_code = @store_code
) T
;