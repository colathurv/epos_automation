#################################################################
# This placeholder script will create the total prices and taxes
# based on the user variables - store_code and date_string.
# Author - Colathur Vijayan [VJN]
#################################################################
### Crank out the Total Payment Report

select 
concat
(
'"',
'TOTAL CHARGES', 
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
'"',
',',
'"',
B,
'"'
)
from
(
select 
IF((sum(trans_total_withtax)- sum(trans_total_tax))IS NULL, '0.00', cast((sum(trans_total_withtax)- sum(trans_total_tax)) as char(9)) ) as A,
IF(sum(trans_total_tax) IS NULL, '0.00', cast(sum(trans_total_tax) as char(9)) ) as B
from srcm.srcm_nbks_trans_summary
where store_code = @store_code
and trans_month = @date_string
and trans_type not in ('STOCKTRFR', 'ONLINECRD', 'STOCKADDN')
) T ;

