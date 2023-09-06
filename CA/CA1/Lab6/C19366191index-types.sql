--Question One
--Query to get the average number of people to who tickets were sold
--on an hourly basis
SELECT date_trunc('hour', created_at), avg(count)
FROM dbweek6.booking_system t
WHERE created_at BETWEEN '2021-02-01' AND '2021-02-28'
GROUP BY 1 ORDER BY 1;

--EXPLAIN ANALYSE on the query
EXPLAIN ANALYSE
SELECT date_trunc('hour', created_at), avg(count)
FROM dbweek6.booking_system t
WHERE created_at BETWEEN '2021-02-01' AND '2021-02-28'
GROUP BY 1 ORDER BY 1;

--Index
CREATE INDEX in_booking_system_btree ON dbweek6.booking_system(created_at);

--Index size
SELECT pg_size_pretty(pg_relation_size('dbweek6.in_booking_system_btree'));

--Question Two
--Query to all user messages that contain the pattern aeb (case is important)
SELECT message FROM dbweek6.usermessages 
WHERE message ilike '%aeb%';

--EXPLAIN ANALYSE on the query
EXPLAIN ANALYSE 
SELECT message FROM dbweek6.usermessages
WHERE message ilike '%aeb%';

--Index
CREATE INDEX index_messages_btree on dbweek6.usermessages(message);

--Index size
SELECT pg_size_pretty(pg_relation_size('dbweek6.index_messages_btree'));