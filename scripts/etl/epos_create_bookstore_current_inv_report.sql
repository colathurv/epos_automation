#################################################################
# This placeholder script will create the consolidated inventory report
# for all stores that are part of the National Bookstore Ecosystem.
# Author - Colathur Vijayan [VJN]
#################################################################

### Crank out the Inventory Report
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
'Item Cost Price',
'"',
',',
'"',
'CAFR',
'"',
',',
'"',
'ONLN',
'"',
',',
'"',
'NYNJ',
'"',
',',
'"',
'GAMO',
'"',
',',
'"',
'VARI',
'"',
',',
'"',
'OHDA',
'"',
',',
'"',
'MASU',
'"',
',',
'"',
'TXAU',
'"',
',',
'"',
'CALA',
'"',
',',
'"',
'MIDE',
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
item_desc, 
'"',
',',
'"',
item_cost_price,
'"',
',',
'"',
CAFR, 
'"',
',',
'"',
ONLN, 
'"',
',',
'"',
NYNJ,
'"',
',',
'"',
GAMO,
'"',
',',
'"',
VARI,
'"',
',',
'"',
OHDA,
'"',
',',
'"',
MASU,
'"',
',',
'"',
TXAU,
'"',
',',
'"',
CALA,
'"',
',',
'"',
MIDE,
'"'
)
from
(
select item_code,
       item_desc,
       item_cost_price,
       sum(CAFR) as CAFR,
       sum(ONLN) as ONLN,
       sum(NYNJ) as NYNJ,
       sum(GAMO) as GAMO,
       sum(VARI) as VARI,
       sum(OHDA) as OHDA,
       sum(MASU) as MASU,
       sum(TXAU) as TXAU,
       sum(CALA) as CALA,
       sum(MIDE) as MIDE
from
(
select 
A.item_code, 
A.item_desc,
B.item_cost_price,
 case when A.store_code = "CAFR" then calc_inventory else 0 end as CAFR,
 case when A.store_code = "ONLN" then calc_inventory else 0 end as ONLN,
 case when A.store_code = "NYNJ" then calc_inventory else 0 end as NYNJ,
 case when A.store_code = "GAMO" then calc_inventory else 0 end as GAMO,
 case when A.store_code = "VARI" then calc_inventory else 0 end as VARI,
 case when A.store_code = "OHDA" then calc_inventory else 0 end as OHDA,
 case when A.store_code = "MASU" then calc_inventory else 0 end as MASU,
 case when A.store_code = "TXAU" then calc_inventory else 0 end as TXAU,
 case when A.store_code = "CALA" then calc_inventory else 0 end as CALA,
 case when A.store_code = "MIDE" then calc_inventory else 0 end as MIDE
from 
srcm.srcm_nbks_inventory A, 
(select item_code, item_cost_price
from 
srcm.srcm_nbks_product_metadata
group by item_code, item_cost_price)
B
where A.item_code = B.item_code and
	  A.item_code not in ('SHIP', 'SHIP-ADJ') and
      A.item_code not like 'SUB%' and 
	  A.item_code not like 'MAG%'
)A
group by item_code, item_desc
) T
;