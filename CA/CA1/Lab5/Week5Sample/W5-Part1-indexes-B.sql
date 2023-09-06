
/* We are going to force the optimizer to consider using our indexes by setting a system parameter to off /*
set enable_seqscan=OFF;
create index sales_index_prod on sales ( prod_id , amount);