/* This will create two tables with text data in them for use with GIN indexes */

DROP TABLE IF EXISTS dbweek6.testusers;
DROP TABLE IF EXISTS dbweek6.usermessages;

CREATE TABLE dbweek6.testusers (
    id int,
    first_name text,
    last_name text
);


CREATE TABLE dbweek6.usermessages(
    from_id int,
    to_id int,
    message text
);

/* Insert data into the tables */
insert into dbweek6.testusers values (generate_series(1,1000000), md5(random()::text), md5(random()::text));

insert into dbweek6.usermessages values (generate_series(1,999000), trunc(random()*10*2+10),md5(random()::text)); 
        




