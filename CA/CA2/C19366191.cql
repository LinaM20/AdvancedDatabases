--Q3 part a
--Setting tracing on and then performing a basic query on the factresult table
tracing on;
select * from factresults;

--Q3 part b
--Set tracing on and then performing a query on a non-primary key column that 
--doesnt need an index.
tracing on;
select * from factresults where t_name = 'Irish Open' allow filtering;

--Q3 part c
--Set tracing on and then performing a query using a secondary index on a non-primary key column
--create index on the rank column
create index player_rank on factresults(rank);
--run a query using the index
tracing on;
select * from factresults where t_name = 'Irish Open' allow filtering; 

--Q3 part d
--Creating a SASI index to facilitate pattern matching
--The SASI index was created on the tournament name
CREATE CUSTOM INDEX certain_tname on factresults(t_name) USING 'org.apache.cassandra.index.sasi.SASIIndex';

--Query to test the SASI index 
--This will look for all the details of fact results table where the tournament name starts with I
SELECT * FROM factresults where t_name LIKE 'I%';
--Tracing was set on to check the SASI index
tracing on;

--Q4 part a
--Creating a new table to have column type collection
CREATE TABLE movies(movie_id int, movie_info MAP<text, text>, m_year int, PRIMARY KEY (movie_id));
--Inserting data into this new table
INSERT INTO MOVIES(movieid, movie_info, m_year) VALUES (1, {'Movie Name':'Batman', 'Main Lead': 'Robert Pattinson'}, 2022); 
INSERT INTO MOVIES(movieid, movie_info, m_year) VALUES (2, {'Movie Name':'Dune', 'Main Lead': 'Timothee Chalamet'}, 2021); 
INSERT INTO MOVIES(movieid, movie_info, m_year) VALUES (3, {'Movie Name':'Glass Onion', 'Main Lead': 'Daniel Craig'}, 2022); 
INSERT INTO MOVIES(movieid, movie_info, m_year) VALUES (4, {'Movie Name':'Tenet', 'Main Lead': 'John David Washington'}, 2020); 
INSERT INTO MOVIES(movieid, movie_info, m_year) VALUES (5, {'Movie Name':'Interstellar', 'Main Lead': 'Matthew McConaughey'}, 2014);

--Q4 part b
--Query to get all the data, without an index
SELECT * FROM movies;

--Q4 part c
--Create an index on the movie_info column
CREATE INDEX movie_index ON MOVIES(movie_info);
--Query to test the index
--This get the movie info where the movie name was Batman
SELECT * FROM movies WHERE movie_info CONTAINS 'Batman' ALLOW FILTERING;