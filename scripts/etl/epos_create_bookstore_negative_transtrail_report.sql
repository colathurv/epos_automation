#################################################################
# This placeholder script will create the transaction trail
# per store, for all items that have a negative inventory.
# Author - Colathur Vijayan [VJN]
#################################################################

### Crank out the Negative Transaction Trail Report
select 
concat
(
'"',
'Store Code',
'"',
',',
'"',
'Item Code',
'"',
',',
'"',
'Transaction Type',
'"',
',',
'"',
'Transaction Number',
'"',
',',
'"',
'Item Quantity',
'"',
',',
'"',
'Beginning Inventory',
'"',
',',
'"',
'System Calculated Inventory',
'"'
)
union
select
concat
(
'"',
store_code, 
'"',
',',
'"',
item_code, 
'"',
',',
'"',
trans_type, 
'"',
',',
'"',
trans_no, 
'"',
',',
'"',
item_qty,
'"',
',',
'"',
beginning_inventory,
'"',
',',
'"',
calc_inventory,
'"'
)
from
(
select A.store_code,
       A.item_code, 
       C.trans_type, 
       A.trans_no,  
       sum(A.item_qty) as item_qty, 
       B.beginning_inventory,  
       B.calc_inventory
from srcm.srcm_nbks_trans_detail A, srcm.srcm_nbks_inventory B, srcm.srcm_nbks_trans_summary C
where A.store_code = B.store_code
and A.trans_no = C.trans_no
and A.item_code = B.item_code
and B.calc_inventory < 0 
and A.item_code not like 'SUB%' and A.item_code not like 'MAG%'
group by A.store_code, A.item_code, A.trans_no
order by A.store_code, A.item_code, A.trans_no
) T
;