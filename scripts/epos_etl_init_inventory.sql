#################################################################
# This script will extract, transform and load initial
# inventory data.
# Author - Colathur Vijayan [VJN]
#################################################################
-- Extract, transform and load inventory data

use srcm ;


-- Do a cleanup where in if the script is re-run for any reason
-- As the delete is not based on a Primary Key we induce an artificial predicate
delete a
from srcm_nbks_inventory as a, srcm_nbks_item_init_count_staging as b
where a.store_code = b.store_code and a.primary_id <> 0;
 

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
select store_code,
       item_code,
       item_desc,
       qty_delivered,
       qty_delivered,
       current_timestamp(),
       current_timestamp()
from srcm.srcm_nbks_item_init_count_staging ;