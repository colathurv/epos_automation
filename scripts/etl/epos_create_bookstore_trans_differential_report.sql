#################################################################
# This placeholder script will create the transaction differential
# for STORESALE or CRSUBSCRP Transactions, based on 
# the user variables - store_code and date_string.
# Author - Colathur Vijayan [VJN]
#################################################################

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
'Transaction Discount Code',
'"',
',',
'"',
'Transaction Payment',
'"',
',',
'"',
'Total Tax',
'"',
',',
'"',
'Total Price With Tax',
'"',
',',
'"',
'Total Differential (Round Off)',
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
trans_disc_code,
'"',
',',
'"',
trans_payment,
'"',
',',
'"',
total_tax,
'"',
',',
'"',
total_price_withtax,
'"',
',',
'"',
trans_differential,
'"'
)
from
(
select 
a.trans_type,
a.trans_no,
a.trans_disc_code,
( IF (a.trans_card_payment is null, 0.00, a.trans_card_payment) + 
IF (a.trans_cash_payment is null, 0.00, a.trans_cash_payment) +
IF (a.trans_check_payment is null, 0.00, a.trans_check_payment) 
) as trans_payment,
(sum(b.item_agg_price_withtax) - sum(b.item_agg_price)) as total_tax,
sum(b.item_agg_price_withtax) as total_price_withtax,
( IF (a.trans_card_payment is null, 0.00, a.trans_card_payment) + 
IF (a.trans_cash_payment is null, 0.00, a.trans_cash_payment) +
IF (a.trans_check_payment is null, 0.00, a.trans_check_payment) -
sum(b.item_agg_price_withtax) 
) as trans_differential
from srcm.srcm_nbks_trans_summary a, srcm.srcm_nbks_trans_detail b
where a.store_code = @store_code
and a.trans_month = @date_string
and a.trans_no = b.trans_no
and b.item_code not in ('SHIP', 'SHIP-ADJ')
and a.trans_type <> 'ONLINECRD' 
and a.trans_type <> 'STOCKTRFR' 
and a.trans_type <> 'STOCKADDN' 
and a.trans_type <> 'PREORDERS'
and a.trans_type <> 'ITMADJADD'
and a.trans_type <> 'ITMADJREM'
group by  a.trans_no
) T ;