CREATE USER 'replicator' IDENTIFIED BY 'replpass';
CREATE USER 'debezium' IDENTIFIED BY 'dbz';
GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'replicator';
GRANT SELECT, RELOAD, SHOW DATABASES, REPLICATION SLAVE, REPLICATION CLIENT  ON *.* TO 'debezium';
ALTER USER 'debezium'@'%' IDENTIFIED WITH mysql_native_password BY 'dbz';

# Create the database that we'll use to populate data and watch the effect in the binlog
CREATE DATABASE inventory;
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