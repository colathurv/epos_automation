#################################################################
# This placeholder script will create the online card 
# transaction report based on the user variables 
# - store_code and date_string.
# Author - Colathur Vijayan [VJN]
#################################################################

select 
concat
(
'"',
'Item Code',
'"',
',',
'"',
'Description',
'"',
',',
'"',
'Total Quantity',
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
A, 
'"',
',',
'"',
B, 
'"',
',',
'"',
C,
'"',
',',
'"',
D,
'"'
)
from
(
select
a.item_code as A,
c.item_desc as B,
IF(sum(a.item_qty) IS NULL, '0.00',cast(sum(a.item_qty) as char(9)) ) as C,
b.trans_usd_comment as D
from srcm.srcm_nbks_trans_detail a, srcm.srcm_nbks_trans_summary b, srcm.srcm_nbks_inventory c
where a.store_code = @store_code
and a.trans_month = @date_string
and a.trans_no = b.trans_no
and a.item_code not in ('SHIP', 'SHIP-ADJ')
and b.trans_type = 'ONLINECRD'
and a.item_code = c.item_code
and a.store_code = c.store_code
group by a.item_code, 
          c.item_desc, 
          a.item_list_price, 
          a.item_adjlist_price, 
          a.item_final_price,
          a.item_disc_code
) T
;