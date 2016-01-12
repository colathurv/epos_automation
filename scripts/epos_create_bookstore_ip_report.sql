#################################################################
# This placeholder script will create the item payment report
# based on the user variables - store_code and date_string.
# Author - Colathur Vijayan [VJN]
#################################################################


### Crank out the Item Payment Report
select 
concat
(
'"',
"Item Code",
'"',
",",
'"',
"Description",
'"',
",",
'"',
"Item List Price",
'"',
",",
'"',
"Item Adj Price",
'"',
",",
'"',
"Item Final Price",
'"',
",",
'"',
"Item Quantity",
'"',
",",
'"',
"Total Price",
'"',
",",
'"',
"Total Tax",
'"',
",",
'"',
"Total Price withtax",
'"',
",",
'"',
"Item Discount Code",
'"',
",",
'"',
"Transaction Discount Code"
'"'
)

union

select 
concat
(
'"',
item_code,
'"',
",",
'"',
item_desc,
'"',
",",
'"',
item_list_price,
'"',
",",
'"',
item_adjlist_price,
'"',
",",
'"',
item_final_price,
'"',
",",
'"',
total_qty,
'"',
",",
'"',
total_price,
'"',
",",
'"',
total_tax,
'"',
",",
'"',
total_price_withtax,
'"',
",",
'"',
item_disc_code,
'"',
",",
'"',
trans_disc_code,
'"'
)

from 
(
select 
a.item_code,
c.item_desc,
a.item_list_price,
a.item_adjlist_price,
a.item_final_price,
sum(a.item_qty) as total_qty,
sum(a.item_agg_price) as total_price,
(sum(a.item_agg_price_withtax) - sum(a.item_agg_price)) as total_tax,
sum(a.item_agg_price_withtax) as total_price_withtax,
a.item_disc_code,
b.trans_disc_code
from srcm.srcm_nbks_trans_detail a, srcm.srcm_nbks_trans_summary b, srcm.srcm_nbks_inventory c
where a.store_code = @store_code
and a.trans_month = @date_string
and a.trans_no = b.trans_no
and a.item_code not in ('SHIP', 'SHIP-ADJ')
and b.trans_type <> 'ONLINECRD' and b.trans_type <> 'STOCKTRFR' and b.trans_type <> 'STOCKADDN'
and a.item_code = c.item_code
and a.store_code = c.store_code
group by a.item_code, 
          a.item_desc, 
          a.item_list_price, 
          a.item_adjlist_price, 
          a.item_final_price,
          a.item_disc_code
) T ;


