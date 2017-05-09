#################################################################
# This placeholder script will create the transaction summary
# based on the user variables - store_code and date_string.
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
'Credit Card Payment',
'"',
',',
'"',
'Cash Payment',
'"',
',',
'"',
'Check Payment',
'"',
',',
'"',
'Transaction Total',
'"',
',',
'"',
'Total Tax',
'"',
',',
'"',
'Transaction Date',
'"',
',',
'"',
'Transaction Time'
'"',
',',
'"',
'Transaction Memo'
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
trans_card_payment, 
'"',
',',
'"',
trans_cash_payment, 
'"',
',',
'"',
trans_check_payment,
'"',
',',
'"',
trans_total_withtax,
'"',
',',
'"',
trans_total_tax,
'"',
',',
'"',
trans_date,
'"',
',',
'"',
trans_time,
'"',
',',
'"',
trans_memo,
'"'
)
from
(
SELECT trans_type,
trans_no,
IF(trans_card_payment IS NULL, '0.00', trans_card_payment) as trans_card_payment,
IF(trans_cash_payment IS NULL, '0.00', trans_cash_payment) as trans_cash_payment,
IF(trans_check_payment IS NULL, '0.00', trans_check_payment) as trans_check_payment,
IF(trans_total_withtax IS NULL, '0.00', trans_total_withtax) as trans_total_withtax,
IF(trans_total_tax IS NULL, '0.00', trans_total_tax) as trans_total_tax,
trans_date,
trans_time,
IF(trans_type = 'STORESALE', trans_memo, '') as trans_memo
FROM srcm.srcm_nbks_trans_summary
where store_code = @store_code
and trans_month = @date_string
) T ;



