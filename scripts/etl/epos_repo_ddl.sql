#################################################################
# This script will create all DB objects required
# for staging, transforming and reporting EPOS Sales and Inventory data
# for Bookstores in the US.
# Author - Colathur Vijayan [VJN]
#################################################################

-- START ON A CLEAN SLATE AND DROP TABLES IF THEY EXIST 

use srcm ;

-- Staging Tables
drop table IF EXISTS srcm_nbks_epos_trans_staging ; -- MONTHLY
drop table IF EXISTS srcm_nbks_product_markup_staging ; -- MONTHLY
drop table IF EXISTS srcm.srcm_nbks_state_tax_rates ; -- ANY TIME THERE IS A NEW STORE OR WHEN STATE TAX RATE CHANGES
drop table IF EXISTS srcm_nbks_item_init_count_staging  ; -- WHEN A YEAR BEGINS
drop table IF EXISTS srcm_nbks_product_metadata_staging ;

-- Derived Tables
drop table IF EXISTS srcm_nbks_trans_summary ;
drop table IF EXISTS srcm_nbks_trans_detail ;
drop table IF EXISTS srcm_nbks_trans_detail ;
drop table IF EXISTS srcm_nbks_inventory ;
drop table IF EXISTS srcm_nbks_product_metadata ;

--  CREATE EPOS TRANSACTIONS STAGING TABLE
CREATE TABLE `srcm_nbks_epos_trans_staging` (
  `primary_id` int(11) NOT NULL AUTO_INCREMENT,
  `trans_no` varchar(25) DEFAULT NULL,
  `trans_payment1` decimal(12,2) DEFAULT NULL,
  `trans_payment2` decimal(12,2) DEFAULT NULL,
  `trans_payment3` decimal(12,2) DEFAULT NULL,
  `trans_payment4` decimal(12,2) DEFAULT NULL,
  `trans_payment5` decimal(12,2) DEFAULT NULL,
  `trans_paytype1` varchar(25) DEFAULT NULL,
  `trans_paytype2` varchar(25) DEFAULT NULL,
  `trans_paytype3` varchar(25) DEFAULT NULL,
  `trans_paytype4` varchar(25) DEFAULT NULL,
  `trans_paytype5` varchar(25) DEFAULT NULL,
  `trans_total_tax` decimal(12,2) DEFAULT NULL,
  `trans_total_withtax` decimal(12,2) DEFAULT NULL,
  `trans_time` time DEFAULT NULL,
  `trans_memo` varchar(500) DEFAULT NULL,
  `item_tax_class` varchar(25) DEFAULT NULL,
  `trans_date` date DEFAULT NULL,
  `trans_disc_code` varchar(500) DEFAULT NULL,
  `trans_sale_no` int(11) DEFAULT NULL,
  `trans_counter_no` int(11) DEFAULT NULL,
  `trans_cashier_name` varchar(25) DEFAULT NULL,
  `trans_usd_comment` varchar(255) DEFAULT NULL,
  `item_code` varchar(25) DEFAULT NULL,
  `item_desc` varchar(255) DEFAULT NULL,
  `item_qty` int(11) DEFAULT NULL,
  `item_list_price` decimal(12,2) DEFAULT NULL,
  `item_adjlist_price` decimal(12,2) DEFAULT NULL,
  `item_adjlist_price_withtax` decimal(12,2) DEFAULT NULL,
  `item_final_price` decimal(12,2) DEFAULT NULL,
  `item_final_price_withtax` decimal(12,2) DEFAULT NULL,
  `item_disc_code` varchar(255) DEFAULT NULL,
  `item_desc2` varchar(255) DEFAULT NULL,
  `item_desc3` varchar(255) DEFAULT NULL,
  `item_tax_percent` decimal(12,2) DEFAULT NULL, 
  PRIMARY KEY (`primary_id`)
) ENGINE=InnoDB AUTO_INCREMENT=151 DEFAULT CHARSET=utf8 ;


-- CREATE ITEM INIT COUNT STAGING
CREATE TABLE `srcm_nbks_item_init_count_staging` (
  `primary_id` int(11) NOT NULL AUTO_INCREMENT,
  `store_code` varchar(25) DEFAULT NULL,
  `item_code` varchar(25) DEFAULT NULL,
  `item_desc` varchar(255) DEFAULT NULL,
  `qty_delivered` int(11) DEFAULT NULL,
  PRIMARY KEY (`primary_id`)
) ENGINE=InnoDB AUTO_INCREMENT=151 DEFAULT CHARSET=utf8 ;



-- CREATE PRODUCT METADATA STAGING TABLE
CREATE TABLE `srcm_nbks_product_metadata_staging` (
  `primary_id` int(11) NOT NULL AUTO_INCREMENT,
  `item_code` varchar(25) DEFAULT NULL,
  `item_desc` varchar(255) DEFAULT NULL,
  `item_cost_price` decimal(12,2) DEFAULT NULL,
  `item_sale_price` decimal(12,2) DEFAULT NULL,
  `version` int(5) DEFAULT NULL,
  `date_str` varchar(10) DEFAULT NULL,
  `is_tax_free` varchar(1) DEFAULT NULL,
   PRIMARY KEY (`primary_id`)
) ENGINE=InnoDB AUTO_INCREMENT=151 DEFAULT CHARSET=utf8 ;


-- CREATE PRODUCT METADATA TABLE
CREATE TABLE `srcm_nbks_product_metadata` (
  `primary_id` int(11) NOT NULL AUTO_INCREMENT,
  `item_code` varchar(25) DEFAULT NULL,
  `item_desc` varchar(255) DEFAULT NULL,
  `item_cost_price` decimal(12,2) DEFAULT NULL,
  `item_sale_price` decimal(12,2) DEFAULT NULL,
  `version` int(5) DEFAULT NULL,
  `date_str` varchar(10) DEFAULT NULL,
  `is_tax_free` varchar(1) DEFAULT NULL,
   PRIMARY KEY (`primary_id`)
) ENGINE=InnoDB AUTO_INCREMENT=151 DEFAULT CHARSET=utf8 ;

-- CREATE STORE TAX TABLE
CREATE TABLE `srcm_nbks_state_tax_rates` (
  `primary_id` int(11) NOT NULL AUTO_INCREMENT,
  `store_code` varchar(25) DEFAULT NULL,
  `tax_class` varchar(25) DEFAULT NULL,
  `tax_rate` decimal(12,2) DEFAULT NULL,
  `version` int(5) DEFAULT NULL,
  `date_str` varchar(10) DEFAULT NULL,
   PRIMARY KEY (`primary_id`)
) ENGINE=InnoDB AUTO_INCREMENT=151 DEFAULT CHARSET=utf8 ;


-- CREATE DERIVED TABLE - SUMMARY
CREATE TABLE `srcm_nbks_trans_summary` (
  `primary_id` int(11) NOT NULL AUTO_INCREMENT,
  `store_code` varchar(25) DEFAULT NULL,
  `to_store_code` varchar(25) DEFAULT NULL,
  `trans_month` varchar(25) DEFAULT NULL,
  `trans_type` varchar(25) DEFAULT NULL,
  `trans_no` varchar(25) DEFAULT NULL,
  `trans_cashier_name` varchar(25) DEFAULT NULL, 
  `trans_card_payment` decimal(12,2) DEFAULT NULL,
  `trans_cash_payment` decimal(12,2) DEFAULT NULL,
  `trans_check_payment` decimal(12,2) DEFAULT NULL,
  `trans_gift_payment` decimal(12,2) DEFAULT NULL,
  `trans_st_payment` decimal(12,2) DEFAULT NULL,
  `trans_total_withtax` decimal(12,2) DEFAULT NULL,
  `trans_total_tax` decimal(12,2) DEFAULT NULL,
  `trans_disc_code` varchar(255) DEFAULT NULL,
  `trans_date` date DEFAULT NULL,
  `trans_time` time DEFAULT NULL,
  `trans_memo` varchar(500) DEFAULT NULL,
  `trans_usd_comment` varchar(255) DEFAULT NULL,
  `last_updated_date` timestamp,
  PRIMARY KEY (`primary_id`)
) ENGINE=InnoDB AUTO_INCREMENT=151 DEFAULT CHARSET=utf8 ;

-- CREATE DERIVED TABLE - TRANS DETAIL
CREATE TABLE `srcm_nbks_trans_detail` (
  `primary_id` int(11) NOT NULL AUTO_INCREMENT,
  `store_code` varchar(25) DEFAULT NULL,
  `trans_month` varchar(25) DEFAULT NULL,
  `trans_no` varchar(25) DEFAULT NULL,
  `item_code` varchar(25) DEFAULT NULL,
  `item_desc` varchar(255) DEFAULT NULL,
  `item_qty` int(11) DEFAULT NULL,
  `item_list_price` decimal(12,2) DEFAULT NULL,
  `item_adjlist_price` decimal(12,2) DEFAULT NULL,
  `item_tax_percent` decimal(12,2) DEFAULT NULL,
  `item_final_price` decimal(12,2) DEFAULT NULL,
  `item_agg_price` decimal(12,2) DEFAULT NULL,
  `item_agg_price_withtax` decimal(12,2) DEFAULT NULL,
  `item_disc_code` varchar(255) DEFAULT NULL,
  `item_desc2` varchar(255) DEFAULT NULL,
  `item_desc3` varchar(255) DEFAULT NULL,
  `last_updated_date` timestamp,
  PRIMARY KEY (`primary_id`)
) ENGINE=InnoDB AUTO_INCREMENT=151 DEFAULT CHARSET=utf8 ;


--  CREATE DERIVED TABLE - INVENTORY
CREATE TABLE `srcm_nbks_inventory` (
  `primary_id` int(11) NOT NULL AUTO_INCREMENT,
  `store_code` varchar(25) DEFAULT NULL,
  `item_code` varchar(25) DEFAULT NULL,
  `item_desc` varchar(255) DEFAULT NULL,
  `beginning_inventory` int(11) DEFAULT NULL,
  `calc_inventory` int(11) DEFAULT NULL,
  `counted_inventory` int(11) DEFAULT NULL,
  `counted_inventory_date` timestamp,
  `creation_date` timestamp,
  `last_updated_date` timestamp,
  PRIMARY KEY (`primary_id`)
) ENGINE=InnoDB AUTO_INCREMENT=151 DEFAULT CHARSET=utf8 ;


-- CREATION OF INDEXES
CREATE INDEX trans_no_index ON srcm.srcm_nbks_trans_summary(trans_no) USING BTREE;
CREATE INDEX trans_no_index ON srcm.srcm_nbks_trans_detail(trans_no) USING BTREE;
CREATE INDEX item_code_index ON srcm.srcm_nbks_trans_detail(item_code) USING BTREE;
CREATE INDEX item_code_index ON srcm.srcm_nbks_inventory(item_code) USING BTREE;
CREATE INDEX composite_index1 ON srcm.srcm_nbks_inventory(store_code,item_code) USING BTREE;
CREATE FULLTEXT INDEX item_desc_index ON srcm.srcm_nbks_product_metadata(item_desc,item_code);
CREATE INDEX item_code_index ON srcm.srcm_nbks_product_metadata(item_code) USING BTREE;
