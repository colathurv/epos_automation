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
       item_desc ,
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
item_code, 
item_desc,
 case when store_code = "CAFR" then calc_inventory else 0 end as CAFR,
 case when store_code = "ONLN" then calc_inventory else 0 end as ONLN,
 case when store_code = "NYNJ" then calc_inventory else 0 end as NYNJ,
 case when store_code = "GAMO" then calc_inventory else 0 end as GAMO,
 case when store_code = "VARI" then calc_inventory else 0 end as VARI,
 case when store_code = "OHDA" then calc_inventory else 0 end as OHDA,
 case when store_code = "MASU" then calc_inventory else 0 end as MASU,
 case when store_code = "TXAU" then calc_inventory else 0 end as TXAU,
 case when store_code = "CALA" then calc_inventory else 0 end as CALA,
 case when store_code = "MIDE" then calc_inventory else 0 end as MIDE
from 
srcm.srcm_nbks_inventory
where item_code not in ('SHIP', 'SHIP-ADJ') and
      item_code not like 'SUB%' and 
	  item_code not like 'MAG%'
)A
group by item_code, item_desc
) T
;