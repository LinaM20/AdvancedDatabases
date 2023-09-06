Drop schema if exists dbweek5 CASCADE;

create schema dbweek5;

drop table if exists dbweek5.sales;
drop table if exists dbweek5.customers;
drop table if exists dbweek5.shops;

create table dbweek5.shops
( shop_id int,
name varchar(20),
address varchar(100),
country varchar(20)
);

create table dbweek5.customers
( cust_id int,
name varchar(100),
signup date,
creditlimit int,
vip varchar(1),
shop_id int
);

create table dbweek5.sales
( sales_id int,
cust_id int,
tstamp timestamp,
amount numeric(10,2),
prod_id int
);

BEGIN;
insert /*+ APPEND */ into dbweek5.shops
select rownum, 'shop'||rownum, 'address'||rownum , 'IRELAND'
from generate_series(1, 100) as rownum;

insert  into dbweek5.customers
select rownum, 'cust'||rownum, current_date-720+mod(rownum,500), mod(rownum,10),
case when mod(rownum,10)=0 then 'Y' else 'N' end, mod(rownum,50)+1
from generate_series(1, 100,1) as rownum;

insert /*+ APPEND */ into dbweek5.sales (sales_id, cust_id, tstamp, amount, prod_id)
select rownum, 1+mod(rownum,100), current_date-720+rownum/(5000/720), rownum/100, 1+mod(rownum,50)
from generate_series(1, 5000,1) as rownum;


commit;