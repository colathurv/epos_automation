delete from srcm.srcm_nbks_trans_summary
where store_code not in 
(
select distinct(store_code) from srcm.srcm_nbks_state_tax_rates
)
and primary_id <> 0

delete from srcm.srcm_nbks_trans_detail
where store_code not in 
(
select distinct(store_code) from srcm.srcm_nbks_state_tax_rates
)
and primary_id <> 0