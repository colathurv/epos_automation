select distinct(trans_date), store_code, substr(trans_no,instr(trans_no,'-') + 1,8)
from srcm.srcm_nbks_trans_summary
group by store_code , trans_date