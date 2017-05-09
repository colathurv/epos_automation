######################################################################################
# This script updates inventory table with new items i.e., items that have no previous 
# entry in Inventory.
# Author - Colathur Vijayan [VJN]
######################################################################################

use srcm ;

-- NOTE :: These statements have become ugly, due to a MYSQL idiosyncracy where in updates
-- to rows based on rules for selecting them involves a very complex predicate.

-- Check if there are STOCKADDN Transactions where the Item does not exist in the inventory [i.e., these are
-- NEW RELEASES]. If they exist make sure a row is created for each such item.


insert into srcm.srcm_nbks_inventory
(
store_code, 
item_code,
item_desc,
beginning_inventory,
calc_inventory,
last_updated_date,
creation_date
)
select @store_code as store_code, 
       item_code, 
       item_desc,
       0, 
       0, 
       current_timestamp(), 
       current_timestamp() 
       from
       (
	select b.item_code, b.item_desc
	from srcm.srcm_nbks_trans_summary as a,
             srcm.srcm_nbks_trans_detail as b
	where a.trans_type = 'STOCKADDN'
              and a.trans_no = b.trans_no
	      and b.item_code not in ('SHIP', 'SHIP-ADJ', 'SBK0000053')
	      group by b.item_code, b.item_desc
        ) Q
where (@store_code, item_code) not in
(
select store_code, item_code
from srcm.srcm_nbks_inventory
) ;




