######################################################################################
# This script will update system calculated inventory data by starting on a clean slate
# always. It will start from the beginning inventory, subtract quantity for items
# to be decremented, followed by adding quantity for items to be incremented.
# In essence, inventory update is done using the following 3 steps -
# 1. set calc_inventory = beginning_inventory for all items
# 2. for items that have a decrement,
#      set calc_inventory = beginning_inventory - (stock transfer outs, store sales, online sales, mail order sales, item adjustment removes) 
# 3. for items that have an increment,
#      set calc_inventory = calc_inventory + stock adds + item adjustment adds 
# NOTE : For Hub Stores Stock Adds will be through EPOS Transactions of type STOCKADDN
#        For Satellite Stores Stock Adds will be through EPOS Transactions of type STOCKTRFR 
# Author - Colathur Vijayan [VJN]
######################################################################################

use srcm ;

-- NOTE :: These statements have become ugly, due to a MYSQL idiosyncracy where in updates
-- to rows based on rules for selecting them involves a very complex predicate.

-- Initialize calc_inventory to be beginning inventory and last updated date to be current date

update srcm.srcm_nbks_inventory a
set a.last_updated_date = ( select current_timestamp()),
a.calc_inventory = a.beginning_inventory
where a.primary_id <> 0
and a.store_code = @store_code ;

-- Update Stock Decrements [Anything other than a Stock Add will be a decrement]
update srcm.srcm_nbks_inventory a
set a.calc_inventory = 
(
 select X 
 from
       (
	select
	(c.beginning_inventory - sum(a.item_qty)) as X , c.primary_id as id
	from srcm.srcm_nbks_trans_detail as a, 
	     srcm.srcm_nbks_trans_summary as b, 
	     srcm.srcm_nbks_inventory as c
	where c.store_code = @store_code
	      and c.item_code not in ('SHIP', 'SHIP-ADJ', 'SBK0000053')
	      and c.store_code = a.store_code
	      and c.item_code = a.item_code
	      and a.trans_no = b.trans_no
	      and b.trans_type <> 'STOCKADDN' 
	      and b.trans_type <> 'ITMADJADD'
	group by a.item_code
	) T
    where T.id = a.primary_id
)
where a.primary_id <> 0
and a.primary_id in
(
select id from
       (
	select c.primary_id as id 
	from srcm.srcm_nbks_trans_detail as a, 
	     srcm.srcm_nbks_trans_summary as b, 
	     srcm.srcm_nbks_inventory as c
	where c.store_code = @store_code
             and c.item_code not in ('SHIP', 'SHIP-ADJ', 'SBK0000053')
	     and c.store_code = a.store_code
             and c.item_code = a.item_code
	     and a.trans_no = b.trans_no
	     and b.trans_type <> 'STOCKADDN'
	     and b.trans_type <> 'ITMADJADD'
	group by a.item_code
        ) Q
) ;


-- Update Stock Increments.
-- CASE 1 :: This is the case where the store for which the script is run, gets its stocks
-- from Manapakkam [HQ].
update srcm.srcm_nbks_inventory a
set a.calc_inventory = 
(
	select X from
    (
	select (c.calc_inventory + sum(a.item_qty)) as X, c.item_code as item_code,
	c.store_code as store_code, c.primary_id as id
	from srcm.srcm_nbks_trans_detail as a, 
             srcm.srcm_nbks_trans_summary as b,
             srcm.srcm_nbks_inventory as c
	where c.store_code = @store_code
        and c.item_code not in ('SHIP', 'SHIP-ADJ', 'SBK0000053')
	and c.store_code = a.store_code
        and c.item_code = a.item_code
	and a.trans_no = b.trans_no
	and b.trans_type = 'STOCKADDN'
	group by a.item_code
    ) T
    where T.id = a.primary_id 
)
where  
a.primary_id <> 0
and a.primary_id in
(
    select id from
    (
    select  c.primary_id as id
	from srcm.srcm_nbks_trans_detail as a, 
	     srcm.srcm_nbks_trans_summary as b,
             srcm.srcm_nbks_inventory as c
	where c.store_code = @store_code
        and c.item_code not in ('SHIP', 'SHIP-ADJ', 'SBK0000053')
	and c.store_code = a.store_code
        and c.item_code = a.item_code
	and a.trans_no = b.trans_no
	and b.trans_type = 'STOCKADDN'
	group by a.item_code
    ) Q
) ;

-- Update Stock Increments.
-- CASE 2 :: This is the case where the store for which the script is run, gets its stocks
-- from another store through a STOCK TRANSFER.
update srcm.srcm_nbks_inventory a
set a.calc_inventory = 
(
	select X from
    (
	select (c.calc_inventory + sum(a.item_qty)) as X, c.item_code as item_code,
	c.store_code as store_code, c.primary_id as id
	from srcm.srcm_nbks_trans_detail as a, 
             srcm.srcm_nbks_trans_summary as b,
             srcm.srcm_nbks_inventory as c
	where c.store_code = @store_code
	and c.store_code = b.to_store_code
	and b.trans_type = 'STOCKTRFR'
	and b.trans_no = a.trans_no
	and c.item_code = a.item_code
	group by a.item_code
    ) T
    where T.id = a.primary_id 
)
where  
a.primary_id <> 0
and a.primary_id in
(
    select id from
    (
    select  c.primary_id as id
	from srcm.srcm_nbks_trans_detail as a, 
	     srcm.srcm_nbks_trans_summary as b,
             srcm.srcm_nbks_inventory as c
	where c.store_code = @store_code
	and c.store_code = b.to_store_code
	and b.trans_type = 'STOCKTRFR'
	and b.trans_no = a.trans_no
	and c.item_code = a.item_code
	group by a.item_code
    ) Q
) ;

-- Update Stock Increments.
-- CASE 3 :: This is the case where the store for which the script is run,requests 
-- an item adjustment to add.
update srcm.srcm_nbks_inventory a
set a.calc_inventory = 
(
	select X from
    (
	select (c.calc_inventory + sum(a.item_qty)) as X, c.item_code as item_code,
	c.store_code as store_code, c.primary_id as id
	from srcm.srcm_nbks_trans_detail as a, 
             srcm.srcm_nbks_trans_summary as b,
             srcm.srcm_nbks_inventory as c
	where c.store_code = @store_code
        and c.item_code not in ('SHIP', 'SHIP-ADJ', 'SBK0000053')
	and c.store_code = a.store_code
        and c.item_code = a.item_code
	and a.trans_no = b.trans_no
	and b.trans_type = 'ITMADJADD'
	group by a.item_code
    ) T
    where T.id = a.primary_id 
)
where  
a.primary_id <> 0
and a.primary_id in
(
    select id from
    (
    select  c.primary_id as id
	from srcm.srcm_nbks_trans_detail as a, 
	     srcm.srcm_nbks_trans_summary as b,
             srcm.srcm_nbks_inventory as c
	where c.store_code = @store_code
        and c.item_code not in ('SHIP', 'SHIP-ADJ', 'SBK0000053')
	and c.store_code = a.store_code
        and c.item_code = a.item_code
	and a.trans_no = b.trans_no
	and b.trans_type = 'ITMADJADD'
	group by a.item_code
    ) Q
) ;