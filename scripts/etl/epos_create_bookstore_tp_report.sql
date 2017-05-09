#################################################################
# This placeholder script will create the total payments
# based on the user variables - store_code and date_string.
# Author - Colathur Vijayan [VJN]
#################################################################


### Crank out the Total Payment Report
select 
concat
(
'"',
'Card',
'"',
',',
'"',
'Cash',
'"',
',',
'"',
'Check',
'"'
)

union

select 
concat
(
'"',
A, 
'"',
',',
'"',
B, 
'"',
',',
'"',
C,
'"'
)
from
(
select 
IF(sum(trans_card_payment) IS NULL, '0.00', cast(sum(trans_card_payment) as char(9)) ) as A,
IF(sum(trans_cash_payment) IS NULL, '0.00', cast(sum(trans_cash_payment) as char(9)) ) as B,
IF(sum(trans_check_payment) IS NULL, '0.00',cast(sum(trans_check_payment) as char(9)) ) as C
from srcm.srcm_nbks_trans_summary
where store_code = @store_code
and trans_month = @date_string
and trans_type not in ('STOCKTRFR', 'ONLINECRD', 'STOCKADDN','PREORDERS')
) T ;

