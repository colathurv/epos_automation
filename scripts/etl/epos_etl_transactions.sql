#################################################################
# This script will extract, transform and load EPOS data
# to a normalized schema, which will be in turn used
# for creating sales and inventory reports. 
# Author - Colathur Vijayan [VJN]
#################################################################
-- Extract, transform and populate transaction level columns to the trans_summary
-- table

use srcm ;

insert into srcm.srcm_nbks_trans_summary
(
store_code,
to_store_code,
trans_month,
trans_type, 
trans_no,
trans_cashier_name,          
trans_card_payment,
trans_cash_payment,
trans_check_payment,
trans_st_payment,
trans_gift_payment,
trans_total_withtax,
trans_total_tax,
trans_disc_code,
trans_date,
trans_time,
trans_memo,
trans_usd_comment,
last_updated_date
)
select substr(trans_no,1, instr(trans_no,'-') - 1),
       CASE
           WHEN substring(trans_memo,1,9) = 'STOCKTRFR'
           	THEN substr(trans_memo,instr(trans_memo,'-') + 1,4)
       END,
       substr(trans_no,instr(trans_no,'-') + 3,6),
       CASE 
       	   WHEN substring(trans_memo,1,9) NOT IN ('STOCKTRFR', 'ONLINECHK', 'ONLINECRD', 'MAILORCHK', 'MAILORCRD', 'CRSUBSCRP', 'STOCKADDN', 'PREORDERS', 'ITMADJADD', 'ITMADJREM')
           	THEN 'STORESALE'
	   ELSE 
		   substring(trans_memo,1,9)
       END as trans_type, 
       trans_no,   
       trans_cashier_name,
       CASE 
	   WHEN trans_paytype1 = 'Card' and trans_payment1 > 0.00
			THEN trans_payment1
           WHEN trans_paytype2 = 'Card' and trans_payment2 > 0.00
			THEN trans_payment2
	   WHEN trans_paytype3 = 'Card' and trans_payment3 > 0.00
			THEN trans_payment3
	   END as trans_card_payment,

      CASE 
	   WHEN trans_paytype1 = 'Cash' and trans_payment1 > 0.00
			THEN trans_payment1
           WHEN trans_paytype2 = 'Cash' and trans_payment2 > 0.00
			THEN trans_payment2
	   WHEN trans_paytype3 = 'Cash' and trans_payment3 > 0.00
			THEN trans_payment3
           END as trans_cash_payment,

      CASE 
	   WHEN trans_paytype1 = 'Check' and trans_payment1 > 0.00
			THEN trans_payment1
           WHEN trans_paytype2 = 'Check' and trans_payment2 > 0.00
			THEN trans_payment2
	   WHEN trans_paytype3 = 'Check' and trans_payment3 > 0.00
			THEN trans_payment3
	   END as trans_check_payment,

      CASE 
	   WHEN trans_paytype1 = 'ST' and trans_payment1 > 0.00
			THEN trans_payment1
           WHEN trans_paytype2 = 'ST' and trans_payment2 > 0.00
			THEN trans_payment2
	   WHEN trans_paytype3 = 'ST' and trans_payment3 > 0.00
			THEN trans_payment3
	   END as trans_st_payment,
       NULL as trans_gift_payment,
       trans_total_withtax,
       trans_total_tax,
       trans_disc_code,
       trans_date,
       trans_time,
       trans_memo,
       trans_usd_comment,
       current_timestamp()
from srcm.srcm_nbks_epos_trans_staging
where trans_payment1 > 0.00 or length(trans_disc_code) <> 0
and substr(trans_no,1, instr(trans_no,'-') - 1) in 
(
select distinct(store_code) from srcm.srcm_nbks_state_tax_rates
);


-- Extract, transform and populate transaction level columns to the trans_detail
-- table
insert into srcm.srcm_nbks_trans_detail
(
       store_code,
       trans_month,
       trans_no, 
       item_code, 
       item_desc, 
       item_qty,
       item_list_price, 
       item_adjlist_price, 
       item_final_price,
       item_agg_price,
       item_agg_price_withtax,
       item_tax_percent,	
       item_disc_code,
       item_desc2, 
       item_desc3,
       last_updated_date
)
select substr(trans_no,1, instr(trans_no,'-') - 1), 
       substr(trans_no,instr(trans_no,'-') + 3,6),
       trans_no, 
       upper(item_code), 
       item_desc, 
       sum(item_qty),
       item_list_price, 
       item_adjlist_price, 
       item_final_price,
       sum(item_final_price),
       sum(item_final_price_withtax),
       item_tax_percent,	
       item_disc_code,
       item_desc2, 
       item_desc3,
       current_timestamp() 
from srcm_nbks_epos_trans_staging
where substr(trans_no,1, instr(trans_no,'-') - 1) in 
(
select distinct(store_code) from srcm.srcm_nbks_state_tax_rates
)
group by trans_no, item_code, item_desc, item_qty, 
         item_list_price, item_adjlist_price, item_final_price, 
         item_final_price_withtax, item_tax_percent,
         item_disc_code,item_desc2, item_desc3 ;


