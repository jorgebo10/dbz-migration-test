CREATE USER 'replicator' IDENTIFIED BY 'replpass';
CREATE USER 'debezium' IDENTIFIED BY 'dbz';
GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'replicator';
GRANT SELECT, RELOAD, SHOW DATABASES, REPLICATION SLAVE, REPLICATION CLIENT  ON *.* TO 'debezium';
#Altering plugging for local test https://stackoverflow.com/questions/50379839/connection-java-mysql-public-key-retrieval-is-not-allowed
ALTER USER 'debezium'@'%' IDENTIFIED WITH mysql_native_password BY 'dbz';
SET character_set_database = 'utf8mb3';

# Create the database that we'll use to populate data and watch the effect in the binlog
CREATE DATABASE inventory CHAR SET utf8mb3 COLLATE utf8mb3_general_ci;
GRANT ALL PRIVILEGES ON inventory.* TO 'mysqluser'@'%';


USE inventory;
CREATE table kafka_books
(
    id             INT unsigned NOT NULL AUTO_INCREMENT,
    title          VARCHAR(150) NOT NULL,
    subtitle       VARCHAR(150) NOT NULL,
    published      DATE NOT NULL,
    PRIMARY KEY    (id)
);

INSERT INTO kafka_books (title, subtitle, published) VALUES
                                                         ('Kafka Connect', 'Build and Run Data Pipelines', '2023-10-01'),
                                                         ('Kafka The Definitive Guide',
                                                          'Real-time Data and Stream Processing at Scale', '2017-07-07');
create table payment_method (
                                id int primary key,
                                name varchar(32),
                                code varchar(6),
                                description varchar(255),
                                created_date datetime,
                                last_modified_date datetime
);
insert into payment_method (id, name, code, description, created_date, last_modified_date)
values (1, 'NetBanking', 'NB', 'Payment via Net Banking', now(), now());
insert into payment_method (id, name, code, description, created_date, last_modified_date)
values (2, 'Debit Card', 'DC', 'Payment via Debit Card', now(), now());
insert into payment_method (id, name, code, description, created_date, last_modified_date)
values (3, 'Credit Card', 'CC', 'Payment via Credit Card', now(), now());

CREATE TABLE `customer` (
                            `id_customer` int NOT NULL AUTO_INCREMENT,
                            `email` varchar(255) NOT NULL,
                            `increment_id` varchar(50) DEFAULT NULL,
                            `prefix` varchar(255) DEFAULT NULL,
                            `first_name` varchar(255) NOT NULL,
                            `middle_name` varchar(255) DEFAULT NULL,
                            `last_name` varchar(255) NOT NULL,
                            `birthday` date DEFAULT NULL,
                            `gender` enum('female','male') DEFAULT NULL,
                            `password` varchar(35) NOT NULL,
                            `restore_password_key` varchar(32) DEFAULT NULL,
                            `is_confirmed` tinyint unsigned DEFAULT '0',
                            `confirmation_key` varchar(40) DEFAULT NULL,
                            `sales_rule_code` varchar(255) NOT NULL,
                            `sales_rule_offline_code` varchar(255) DEFAULT NULL,
                            `created_at` datetime DEFAULT NULL,
                            `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                            `last_login_at` datetime DEFAULT NULL,
                            `deactivated_at` datetime DEFAULT NULL,
                            `shopper_ref` varchar(255) DEFAULT NULL,
                            `check_address` tinyint DEFAULT '0',
                            `is_test` tinyint DEFAULT '0',
                            `loyalty_diff` int DEFAULT '0',
                            `status` varchar(20) DEFAULT NULL,
                            `reference_email` varchar(255) DEFAULT NULL,
                            `reference_email_lock` tinyint(1) DEFAULT '0',
                            `cancellation_step` int DEFAULT '1',
                            `cancellation_date` date DEFAULT NULL,
                            `cancellation_last_email_sent` date DEFAULT NULL,
                            `send_email` tinyint DEFAULT '1',
                            `partner` varchar(30) DEFAULT NULL,
                            `allow_selfreactivation` int DEFAULT '1',
                            `locale` varchar(15) DEFAULT NULL,
                            `blocked_at` datetime DEFAULT NULL,
                            `user_info` text,
                            `uuid` varchar(255) NOT NULL,
                            PRIMARY KEY (`id_customer`),
                            UNIQUE KEY `email_UNIQUE` (`email`),
                            UNIQUE KEY `sales_rule_code` (`sales_rule_code`),
                            UNIQUE KEY `customers_unique_uuid` (`uuid`),
                            UNIQUE KEY `increment_id_UNIQUE` (`increment_id`),
                            UNIQUE KEY `shopper_ref` (`shopper_ref`),
                            UNIQUE KEY `sales_rule_offline_code` (`sales_rule_offline_code`),
                            KEY `restore_password_key_idx` (`restore_password_key`),
                            KEY `reference_email_idx` (`reference_email`),
                            KEY `reference_email_lock_idx` (`reference_email_lock`),
                            KEY `send_email_idx` (`send_email`),
                            KEY `status_idx` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=17594301 DEFAULT CHARSET=utf8mb3;
INSERT INTO `customer` (`id_customer`,`email`,`increment_id`,`prefix`,`first_name`,`middle_name`,`last_name`,`birthday`,`gender`,`password`,`restore_password_key`,`is_confirmed`,`confirmation_key`,`sales_rule_code`,`sales_rule_offline_code`,`created_at`,`updated_at`,`last_login_at`,`deactivated_at`,`shopper_ref`,`check_address`,`is_test`,`loyalty_diff`,`status`,`reference_email`,`reference_email_lock`,`cancellation_step`,`cancellation_date`,`cancellation_last_email_sent`,`send_email`,`partner`,`allow_selfreactivation`,`locale`,`blocked_at`,`user_info`,`uuid`) VALUES (8000,'customer-600@hellofresh.depepe','100000465pepe',NULL,'Julia',NULL,'Moskin','1967-09-14','female','50c7a84bc09d55c2e71f2a5de6f1d7fe70',NULL,1,NULL,'WGVCRHpepe','F-WGVCRHpepe','2012-09-20 15:30:47','2019-07-03 09:11:50',NULL,NULL,'SR-US-pepe',0,0,1,'Casual',NULL,0,1,NULL,NULL,1,NULL,1,NULL,NULL,NULL,'2842287a-8bc6-4eea-ad5c-a7cec5fd2125pepe');

INSERT INTO `customer` (`id_customer`,`email`,`increment_id`,`prefix`,`first_name`,`middle_name`,`last_name`,`birthday`,`gender`,`password`,`restore_password_key`,`is_confirmed`,`confirmation_key`,`sales_rule_code`,`sales_rule_offline_code`,`created_at`,`updated_at`,`last_login_at`,`deactivated_at`,`shopper_ref`,`check_address`,`is_test`,`loyalty_diff`,`status`,`reference_email`,`reference_email_lock`,`cancellation_step`,`cancellation_date`,`cancellation_last_email_sent`,`send_email`,`partner`,`allow_selfreactivation`,`locale`,`blocked_at`,`user_info`,`uuid`) VALUES (1,'customer_with_cancelled_sub@hf.com','100000003',NULL,'customer_with_cancelled_sub',NULL,'customer_with_cancelled_sub',NULL,NULL,'somehash',NULL,0,NULL,'CWCANCELLEDSUB',NULL,NULL,'2023-12-13 07:16:54',NULL,NULL,'SR-US-1',0,0,0,NULL,NULL,0,1,NULL,NULL,1,NULL,1,NULL,NULL,NULL,'b5e51678-587b-485a-b90b-958a59deb4ef');
INSERT INTO `customer` (`id_customer`,`email`,`increment_id`,`prefix`,`first_name`,`middle_name`,`last_name`,`birthday`,`gender`,`password`,`restore_password_key`,`is_confirmed`,`confirmation_key`,`sales_rule_code`,`sales_rule_offline_code`,`created_at`,`updated_at`,`last_login_at`,`deactivated_at`,`shopper_ref`,`check_address`,`is_test`,`loyalty_diff`,`status`,`reference_email`,`reference_email_lock`,`cancellation_step`,`cancellation_date`,`cancellation_last_email_sent`,`send_email`,`partner`,`allow_selfreactivation`,`locale`,`blocked_at`,`user_info`,`uuid`) VALUES (600,'customer-600@hellofresh.de','100000465',NULL,'Julia',NULL,'Moskin','1967-09-14','female','50c7a84bc09d55c2e71f2a5de6f1d7fe',NULL,1,NULL,'WGVCRH','F-WGVCRH','2012-09-20 15:30:47','2019-07-03 09:11:50',NULL,NULL,'SR-US-600',0,0,1,'Casual',NULL,0,1,NULL,NULL,1,NULL,1,NULL,NULL,NULL,'2842287a-8bc6-4eea-ad5c-a7cec5fd2125');

CREATE TABLE `sales_order_item` (
                                    `id_sales_order_item` int unsigned NOT NULL AUTO_INCREMENT,
                                    `shopper_ref_minor` varchar(255) DEFAULT NULL,
                                    `shopper_ref_revision` varchar(255) DEFAULT NULL,
                                    `fk_sales_order` int unsigned NOT NULL,
                                    `fk_sales_merchant_order` int unsigned DEFAULT NULL,
                                    `fk_sales_order_item_status` int unsigned NOT NULL DEFAULT '1',
                                    `fk_sales_order_item_shipment` int unsigned DEFAULT NULL,
                                    `fk_sales_order_item_merchant` int unsigned DEFAULT NULL,
                                    `fk_marketplace_merchant` int DEFAULT NULL,
                                    `fk_sales_order_address_warehouse` int DEFAULT NULL,
                                    `base_unit_price` decimal(10,2) DEFAULT NULL,
                                    `unit_price` decimal(10,2) NOT NULL COMMENT 'Net Merchandise Value (Netto-Warenwert)',
                                    `tax_amount` decimal(10,2) DEFAULT NULL,
                                    `paid_price` decimal(10,2) NOT NULL,
                                    `coupon_money_value` decimal(10,2) DEFAULT NULL COMMENT 'Exists always, if coupon exists',
                                    `coupon_percent` int DEFAULT NULL COMMENT 'Exists only if coupon is a percent coupon\n',
                                    `coupon_refundable` tinyint unsigned DEFAULT NULL,
                                    `coupon_category` int DEFAULT NULL,
                                    `name` varchar(255) NOT NULL,
                                    `sku` varchar(255) NOT NULL,
                                    `target_sku` varchar(255) DEFAULT NULL,
                                    `weight` decimal(12,4) DEFAULT NULL,
                                    `created_at` datetime DEFAULT NULL,
                                    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                    `last_status_change` datetime NOT NULL,
                                    `last_abilita_sync` datetime DEFAULT NULL,
                                    `amount_paid` decimal(10,2) NOT NULL DEFAULT '0.00',
                                    `refunded_money` decimal(10,2) DEFAULT '0.00',
                                    `refunded_voucher` decimal(10,2) DEFAULT '0.00',
                                    `tax_percent` decimal(10,2) DEFAULT '0.00',
                                    `original_unit_price` decimal(10,2) DEFAULT NULL,
                                    `cart_rule_discount` decimal(10,2) DEFAULT NULL,
                                    `cart_rule_display_names` text,
                                    `delivery_date` date NOT NULL,
                                    `is_reserved` tinyint(1) DEFAULT '0',
                                    `delivery_interval` int unsigned NOT NULL,
                                    `delivery_time` varchar(31) DEFAULT NULL,
                                    `delivery_weekday` tinyint DEFAULT NULL,
                                    `delivery_region` varchar(255) DEFAULT NULL,
                                    `fk_subscription` int DEFAULT NULL COMMENT 'sales order items subscription',
                                    `gift_box` tinyint unsigned NOT NULL DEFAULT '0',
                                    `donation_box` tinyint unsigned NOT NULL DEFAULT '0',
                                    `box_category` enum('gift','giftgiver','free','b2b','sub','donation','shop') DEFAULT 'sub',
                                    `extras` varchar(20) DEFAULT NULL,
                                    `last_edit_by` varchar(255) DEFAULT NULL,
                                    `shipped` int NOT NULL DEFAULT '0',
                                    `fk_sales_order_item_address` int DEFAULT NULL,
                                    `exported` int DEFAULT '0',
                                    `region` varchar(255) DEFAULT NULL,
                                    `meals_preset` varchar(255) DEFAULT NULL,
                                    PRIMARY KEY (`id_sales_order_item`),
                                    KEY `fk_order_item_order1` (`fk_sales_order`),
                                    KEY `fk_order_item_order_status1` (`fk_sales_order_item_status`),
                                    KEY `sku` (`sku`),
                                    KEY `fk_sales_order_item_shipment` (`fk_sales_order_item_shipment`),
                                    KEY `fk_sales_order_item_merchant` (`fk_sales_order_item_merchant`),
                                    KEY `fk_marketplace_merchant` (`fk_marketplace_merchant`),
                                    KEY `fk_sales_merchant_order` (`fk_sales_merchant_order`),
                                    KEY `fk_subscription` (`fk_subscription`),
                                    KEY `idx_sales_order_item_shipped` (`shipped`),
                                    KEY `region_idx` (`region`),
                                    KEY `delivery_date_idx` (`delivery_date`)
                            ) ENGINE=InnoDB AUTO_INCREMENT=15489264 DEFAULT CHARSET=utf8mb3;

INSERT INTO `sales_order_item` (`id_sales_order_item`,`shopper_ref_minor`,`shopper_ref_revision`,`fk_sales_order`,`fk_sales_merchant_order`,`fk_sales_order_item_status`,`fk_sales_order_item_shipment`,`fk_sales_order_item_merchant`,`fk_marketplace_merchant`,`fk_sales_order_address_warehouse`,`base_unit_price`,`unit_price`,`tax_amount`,`paid_price`,`coupon_money_value`,`coupon_percent`,`coupon_refundable`,`coupon_category`,`name`,`sku`,`target_sku`,`weight`,`created_at`,`updated_at`,`last_status_change`,`last_abilita_sync`,`amount_paid`,`refunded_money`,`refunded_voucher`,`tax_percent`,`original_unit_price`,`cart_rule_discount`,`cart_rule_display_names`,`delivery_date`,`is_reserved`,`delivery_interval`,`delivery_time`,`delivery_weekday`,`delivery_region`,`fk_subscription`,`gift_box`,`donation_box`,`box_category`,`extras`,`last_edit_by`,`shipped`,`fk_sales_order_item_address`,`exported`,`region`,`meals_preset`) VALUES (15,NULL,NULL,1,NULL,1,NULL,NULL,NULL,NULL,53.00,53.00,0.00,53.00,0.00,NULL,NULL,NULL,'3 Meals (vegetarian) for 2 people','US-VP-3-2-0',NULL,NULL,'2018-12-04 15:54:30','2019-07-11 08:12:54','2018-12-04 15:54:30','2019-07-11 08:12:54',0.00,0.00,0.00,0.00,NULL,NULL,NULL,'2019-01-06',0,1,'US-7-0800-2000',1,NULL,NULL,0,0,NULL,NULL,NULL,0,NULL,0,NULL,NULL);
INSERT INTO `sales_order_item` (`id_sales_order_item`,`shopper_ref_minor`,`shopper_ref_revision`,`fk_sales_order`,`fk_sales_merchant_order`,`fk_sales_order_item_status`,`fk_sales_order_item_shipment`,`fk_sales_order_item_merchant`,`fk_marketplace_merchant`,`fk_sales_order_address_warehouse`,`base_unit_price`,`unit_price`,`tax_amount`,`paid_price`,`coupon_money_value`,`coupon_percent`,`coupon_refundable`,`coupon_category`,`name`,`sku`,`target_sku`,`weight`,`created_at`,`updated_at`,`last_status_change`,`last_abilita_sync`,`amount_paid`,`refunded_money`,`refunded_voucher`,`tax_percent`,`original_unit_price`,`cart_rule_discount`,`cart_rule_display_names`,`delivery_date`,`is_reserved`,`delivery_interval`,`delivery_time`,`delivery_weekday`,`delivery_region`,`fk_subscription`,`gift_box`,`donation_box`,`box_category`,`extras`,`last_edit_by`,`shipped`,`fk_sales_order_item_address`,`exported`,`region`,`meals_preset`) VALUES (25,NULL,NULL,1769,NULL,1024,NULL,NULL,NULL,NULL,129.00,129.00,11.45,129.00,0.00,NULL,NULL,NULL,'3 meals per week','HE001HF98AABINTFOOD-2',NULL,NULL,'2012-09-20 15:30:48','2021-10-22 13:47:18','2017-12-13 13:12:04','2015-01-01 00:00:00',0.00,0.00,0.00,8.88,129.00,0.00,NULL,'2012-09-01',1,0,'12PM - 8PM',NULL,NULL,NULL,0,0,'pepe',NULL,NULL,0,NULL,0,NULL,NULL);
INSERT INTO `sales_order_item` (`id_sales_order_item`,`shopper_ref_minor`,`shopper_ref_revision`,`fk_sales_order`,`fk_sales_merchant_order`,`fk_sales_order_item_status`,`fk_sales_order_item_shipment`,`fk_sales_order_item_merchant`,`fk_marketplace_merchant`,`fk_sales_order_address_warehouse`,`base_unit_price`,`unit_price`,`tax_amount`,`paid_price`,`coupon_money_value`,`coupon_percent`,`coupon_refundable`,`coupon_category`,`name`,`sku`,`target_sku`,`weight`,`created_at`,`updated_at`,`last_status_change`,`last_abilita_sync`,`amount_paid`,`refunded_money`,`refunded_voucher`,`tax_percent`,`original_unit_price`,`cart_rule_discount`,`cart_rule_display_names`,`delivery_date`,`is_reserved`,`delivery_interval`,`delivery_time`,`delivery_weekday`,`delivery_region`,`fk_subscription`,`gift_box`,`donation_box`,`box_category`,`extras`,`last_edit_by`,`shipped`,`fk_sales_order_item_address`,`exported`,`region`,`meals_preset`) VALUES (35,NULL,NULL,2005,NULL,10,NULL,NULL,NULL,NULL,69.00,69.00,0.00,0.00,69.00,0,NULL,1,'3 meals per week','HE001HF98AABINTFOOD-1',NULL,NULL,'2012-10-31 20:31:18','2019-07-11 08:43:41','2017-12-13 13:12:04','2019-07-11 08:43:41',0.00,0.00,0.00,0.00,69.00,0.00,NULL,'2012-11-07',1,1,'12PM - 8PM',NULL,NULL,NULL,0,0,'sub',NULL,NULL,0,NULL,0,NULL,NULL);
INSERT IGNORE INTO `sales_order_item` (`id_sales_order_item`,`shopper_ref_minor`,`shopper_ref_revision`,`fk_sales_order`,`fk_sales_merchant_order`,`fk_sales_order_item_status`,`fk_sales_order_item_shipment`,`fk_sales_order_item_merchant`,`fk_marketplace_merchant`,`fk_sales_order_address_warehouse`,`base_unit_price`,`unit_price`,`tax_amount`,`paid_price`,`coupon_money_value`,`coupon_percent`,`coupon_refundable`,`coupon_category`,`name`,`sku`,`target_sku`,`weight`,`created_at`,`updated_at`,`last_status_change`,`last_abilita_sync`,`amount_paid`,`refunded_money`,`refunded_voucher`,`tax_percent`,`original_unit_price`,`cart_rule_discount`,`cart_rule_display_names`,`delivery_date`,`is_reserved`,`delivery_interval`,`delivery_time`,`delivery_weekday`,`delivery_region`,`fk_subscription`,`gift_box`,`donation_box`,`box_category`,`extras`,`last_edit_by`,`shipped`,`fk_sales_order_item_address`,`exported`,`region`,`meals_preset`) VALUES (45,'460409',NULL,460409,NULL,6,NULL,NULL,NULL,NULL,99.00,99.00,0.00,99.00,0.00,0,0,NULL,'Classic - 5 meals per week for 2 people','US-CB-5-2-0',NULL,NULL,'2016-09-22 01:30:22','2018-01-11 16:55:08','2017-12-13 13:12:04','2018-01-11 08:55:08',0.00,0.00,0.00,0.00,NULL,NULL,NULL,'2016-10-07',0,1,'US-5-0800-2000',5,NULL,107407,0,0,'',NULL,NULL,1,NULL,0,NULL,NULL);

