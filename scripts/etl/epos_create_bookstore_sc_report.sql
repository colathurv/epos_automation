#################################################################
# This placeholder script will create the shipping charges report
# based on the user variables - store_code and date_string.
# Author - Colathur Vijayan [VJN]
#################################################################


### Crank out the Shipping Charges Report
select 
concat
(
'"',
'Transaction Type',
'"',
',',
'"',
'Transaction Number',
'"',
',',
'"',
'Recipient Address',
'"',
',',
'"',
'Shipping Charges Incurred',
'"'
)

union

select 
concat
(
'"',
trans_type,
'"',
',',
'"',
trans_no, 
'"',
',',
'"',
trans_usd_comment, 
'"',
',',
'"',
item_agg_price,
'"'
)

from
(
select b.trans_type, b.trans_no, b.trans_usd_comment, a.item_agg_price
from srcm.srcm_nbks_trans_detail a, srcm.srcm_nbks_trans_summary b
where a.store_code = @store_code
and a.trans_month = @date_string
and a.item_code in ('SHIP', 'SHIP-ADJ')
and a.trans_no = b.trans_no
) T
;

