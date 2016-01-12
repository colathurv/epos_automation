#################################################################
# This placeholder script will create the stock addition report
# based on user variables - store_code and date_string.
# Author - Colathur Vijayan [VJN]
#################################################################

### Crank out the Stock Addition Report
select 
concat
(
'"',
'Item Code',
'"',
',',
'"',
'From Store Code',
'"',
',',
'"',
'To Store Code',
'"',
',',
'"',
'Quantity Transferred',
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
A, 
'"',
',',
'"',
B, 
'"',
',',
'"',
item_qty, 
'"',
',',
'"',
trans_no,
'"'
)
from
(
select b.item_code, 'HQ' as A, a.store_code as B, b.item_qty, a.trans_no 
from srcm.srcm_nbks_trans_summary a, srcm.srcm_nbks_trans_detail b 
where a.trans_type = 'STOCKADDN' 
and a.store_code = @store_code
and a.trans_month = @date_string
and b.item_code not in ('SHIP', 'SHIP-ADJ')
and a.trans_no = b.trans_no

union all

select b.item_code, a.store_code as A, a.to_store_code as B, b.item_qty, a.trans_no 
from srcm.srcm_nbks_trans_summary a, srcm.srcm_nbks_trans_detail b 
where a.trans_type = 'STOCKTRFR' 
and a.to_store_code = @store_code
and a.trans_month = @date_string
and b.item_code not in ('SHIP', 'SHIP-ADJ')
and a.trans_no = b.trans_no
) T ;