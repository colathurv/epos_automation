delete from srcm.srcm_nbks_trans_summary
where store_code = @store_code and trans_month = @trans_month
and primary_id <> 0 ;

delete from srcm.srcm_nbks_trans_detail
where store_code = @store_code and trans_month = @trans_month
and primary_id <> 0 ;
