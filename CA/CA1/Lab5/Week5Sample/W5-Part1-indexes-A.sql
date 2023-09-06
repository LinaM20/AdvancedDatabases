/* Create a unique index on the shops table on the shop_id column*/
create unique index shop_index on shops ( shop_id );
/* Create a unique index on the customers table on the cust_id column*/
create unique index cust_index on customers ( cust_id );
/* Create a unique index on the sales table on the sales_id column*/
create unique index sales_index on sales ( sales_id);
