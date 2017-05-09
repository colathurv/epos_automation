#################################################################
# This placeholder script will create the differential 
# based on price breakdown of items from transaction amount 
# based on the user variables - store_code and date_string.
# Author - Colathur Vijayan [VJN]
#################################################################
### Crank out the Total Payment Report

select 
concat
(
'"',
'TOTAL DIFFERENTIAL', 
'"',
',',
'"',
'   ',
'"',
',',
'"',
'   ',
'"',
',',
'"',
'   ',
'"',
',',
'"',
'   ',
'"',
',',
'"',
'   ',
'"',
',',
'"',
A, 
'"'
)
from
(

select IF ( sum(trans_differential) is null, 0.00, sum(trans_differential)) as A
from
(
select 
a.trans_no,
a.trans_disc_code,
( IF (a.trans_card_payment is null, 0.00, a.trans_card_payment) + 
IF (a.trans_cash_payment is null, 0.00, a.trans_cash_payment) +
IF (a.trans_check_payment is null, 0.00, a.trans_check_payment) 
) as trans_payment,
( IF (a.trans_card_payment is null, 0.00, a.trans_card_payment) + 
IF (a.trans_cash_payment is null, 0.00, a.trans_cash_payment) +
IF (a.trans_check_payment is null, 0.00, a.trans_check_payment) -
sum(b.item_agg_price_withtax) 
) as trans_differential,
(sum(b.item_agg_price_withtax) - sum(b.item_agg_price)) as total_tax,
sum(b.item_agg_price_withtax) as total_price_withtax
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
) T1

) T2 ;

