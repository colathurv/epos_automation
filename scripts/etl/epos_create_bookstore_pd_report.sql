#################################################################
# This placeholder script will create the Preorder 
# distribution report based on the user variables 
# store_code and date_string.
# Author - Colathur Vijayan [VJN]
#################################################################


### Crank out the Preorder Distribution Report
select
concat
(
'"',
'Item Code',
'"',
',',
'"',
'Item Description',
'"',
',',
'"',
'Store Code',
'"',
',',
'"',
'Subscriber Address',
'"',
',',
'"',
'Transaction Number',
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
store_code,
'"',
',',
'"',
trans_usd_comment,
'"',
',',
'"',
trans_no,
'"'
)
from
(
select b.item_code, c.item_desc, a.store_code, a.trans_usd_comment, a.trans_no 
from srcm.srcm_nbks_trans_summary a, srcm.srcm_nbks_trans_detail b , srcm.srcm_nbks_inventory c
where a.trans_type = 'PREORDERS' 
and a.store_code = @store_code
and a.trans_month = @date_string
and b.item_code not in ('SHIP', 'SHIP-ADJ')
and a.trans_no = b.trans_no
and b.item_code = c.item_code
and b.store_code = c.store_code

) T ;
