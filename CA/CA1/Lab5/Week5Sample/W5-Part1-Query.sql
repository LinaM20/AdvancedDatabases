
/* Second last query*/
select prod_id, amount
from shops sh,
customers c,
sales s
where s.cust_id = c.cust_id
and c.shop_id = sh.shop_id
and s.amount > 10
order by prod_id;

/* Final Query */
select prod_id, max(amount)
from shops sh,
customers c,
sales s
where s.cust_id = c.cust_id
and c.shop_id = sh.shop_id
and s.amount > 10
group by prod_id;

set enable_seqscan=ON;

