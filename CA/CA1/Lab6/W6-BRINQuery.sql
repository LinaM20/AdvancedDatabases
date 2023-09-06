--Query to find the average number of people to whom tickets were sold each day in Feb 2021
--date_trunc to extract the day.
--GROUP BY 1 ORDER BY 1 - indicates that the first
--column in the result set should be used for the group
--and sort operations.
--the dbweek6.booking_system table has been given the
--alias t to make the output easier to read.
SELECT date_trunc('day', created_at), avg(count)
FROM dbweek6.booking_system t
WHERE created_at BETWEEN '2021-02-01' AND '2021-02-28 11:59:59'
GROUP BY 1 ORDER BY 1;

EXPLAIN ANALYSE
SELECT date_trunc('day', created_at), avg(count)
FROM dbweek6.booking_system t
WHERE created_at BETWEEN '2021-02-01' AND '2021-02-28 11:59:59'
GROUP BY 1 ORDER BY 1;

CREATE INDEX in_booking_system_btree ON 
dbweek6.booking_system(created_at);

SELECT pg_size_pretty(pg_relation_size('dbweek6.in_booking_system_btree'));

DROP INDEX dbweek6.in_booking_system_btree;

CREATE INDEX in_booking_system_brin ON dbweek6.booking_system USING brin(created_at);

SELECT pg_size_pretty(pg_relation_size('dbweek6.in_booking_system_brin'));