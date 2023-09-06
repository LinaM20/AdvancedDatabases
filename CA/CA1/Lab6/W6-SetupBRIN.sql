
/* The uuid-ossp module provides functions to generate universally unique identifiers (UUIDs) using one of several 
standard algorithms - we are going to use it to create some data so we install it, if not already installed */

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";


/* Create a schema for dbweek6 */
DROP SCHEMA IF EXISTS dbweek6 CASCADE;
CREATE SCHEMA dbweek6;

/* set up a simple group booking system. 
Each record in the booking system will have a unique id (booking_id generated using uuid_generate_v4()),
number of persons for this ticket (count), and timestamp (created_at) when the ticket is brought*/
CREATE TABLE dbweek6.booking_system (
    id BIGSERIAL,
    booking_id UUID not null default uuid_generate_v4(),
    count int,
    created_at timestamptz NOT NULL
);

/* Insert some random data which is incremental in nature ie., increasing timestamp. 
We will insert data from 2019 to the current date an interval of 120 seconds -
this will add in excess of 600000 rows of data.*/

INSERT INTO dbweek6.booking_system (count, created_at)
SELECT floor(random() * 10 + 1)::int, dt
FROM generate_series('2019-01-01 0:00'::timestamptz,
'2021-04-23 23:59:50'::timestamptz, '120 seconds'::interval) dt;




