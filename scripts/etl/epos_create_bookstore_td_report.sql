#################################################################
# This placeholder script will create the transaction detail
# based on the user variables - store_code and date_string.
# Author - Colathur Vijayan [VJN]
#################################################################

### Crank out the Transaction Detail Report
select
concat
(
'"',
'Transaction Number',
'"',
',',
'"',
'Item Code',
'"',
',',
'"',
'Description',
'"',
',',
'"',
'Quantity',
'"',
',',
'"',
'List Price',
'"',
',',
'"',
'Adjusted Price',
'"',
',',
'"',
'Final Price',
'"',
',',
'"',
'Aggregate Price',
'"',
',',
'"',
'Aggregate Price withtax',
'"',
',',
'"',
'Item Discount Code',
'"',
',',
'"',
'Transaction Discount Code',
'"'
)

union

select
concat
(
'"',
trans_no,
'"',
',',
'"',
item_code,
'"',
',',
'"',
item_desc,
'"',
',',
'"',
item_qty,
'"',
',',
'"',
item_list_price,
'"',
',',
'"',
item_adjlist_price,
'"',
',',
'"',
item_final_price,
'"',
',',
'"',
item_agg_price,
'"',
',',
'"',
item_agg_price_withtax,
'"',
',',
'"',
item_disc_code,
'"',
',',
'"',
trans_disc_code,
'"'
)
from
(
select 
a.trans_no,
a.item_code,
c.item_desc,
a.item_qty,
a.item_list_price,
a.item_adjlist_price,
a.item_final_price,
a.item_agg_price,
a.item_agg_price_withtax,
a.item_disc_code,
b.trans_disc_code
from srcm.srcm_nbks_trans_detail a, srcm.srcm_nbks_trans_summary b , srcm.srcm_nbks_inventory c
where a.store_code = @store_code
and a.trans_month = @date_string
and a.trans_no = b.trans_no
and a.item_code = c.item_code
and a.store_code = c.store_code
) A
;
