#################################################################
# This placeholder script will create the stock transfer report
# based on the user variables - store_code and date_string.
# Author - Colathur Vijayan [VJN]
#################################################################


### Crank out the Stock Transfer Report
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
'"',
',',
'"',
'Recipient Address',
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
store_code , 
'"',
',',
'"',
memo, 
'"',
',',
'"',
item_qty, 
'"',
',',
'"',
trans_no, 
'"',
',',
'"',
trans_usd_comment,
'"'
)
from
(
select b.item_code, a.store_code , substr(a.trans_memo,instr(a.trans_memo,'-') + 1,4) as memo, b.item_qty, a.trans_no, a.trans_usd_comment 
from srcm.srcm_nbks_trans_summary a, srcm.srcm_nbks_trans_detail b 
where a.trans_type = 'STOCKTRFR' 
and a.store_code = @store_code
and a.trans_month = @date_string
and b.item_code not in ('SHIP', 'SHIP-ADJ')
and a.trans_no = b.trans_no
) T 
;
