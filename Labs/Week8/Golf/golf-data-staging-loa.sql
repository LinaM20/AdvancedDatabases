/*Player Dimension*/
drop table stage_player;

--create staging table 
CREATE TABLE stage_player AS SELECT * FROM players1 WHERE 1=0;

--add a field for the source db
alter table stage_player add sourceDB integer;

--insert data from player 1
insert into stage_player(p_id, p_name, p_sname, sourcedb)
select p_id, p_name, p_sname, 2 from players1;

--insert additional players from player 2
insert into stage_player(p_id, p_name, p_sname, sourcedb)
select p_id, p_name, p_sname, 2 from players2;

select * from stage_player;

--add the surrogate key
alter table stage_player add player_sk integer;

--create a sequence to generate the keys
drop sequence if exists player_seq;
create sequence player_seq
start with 1
increment by 1;
--update values of player_sk, make sequence choose the next sequence
update stage_player set player_sk = nextval('player_seq');

--Load into dimplayer
insert into dimplayer (player_sk, p_name, p_sname)
select player_sk, p_name, p_sname from stage_player;

select * from dimplayer;

/*End of Player Dimension*/

/*Tournament Dimension*/
drop table if exists stage_tournament cascade;
--create staging table
create table stage_tournament as select * from tournament1 where 1=0;
alter table stage_tournament add sourcedb integer;

--insert data from tournament 1
insert into stage_tournament(t_id, t_descriprion, t_date, total_prize, sourcedb)
select t_id, t_descriprion, t_date, total_prize, 2 from tournament1;

--insert additional players from player 2
insert into stage_tournament(t_id, t_descriprion, t_date, total_prize, sourcedb)
select t_id, t_descriprion, t_date, total_prize*1.3, 2 from tournament2;

select * from stage_tournament;

--add the surrogate key
alter table stage_tournament add tournament_sk integer;

--add sequence
drop sequence if exists tournament_seq;
create sequence tournament_seq 
start with 1 
increment by 1 ; 

update stage_tournament
set tournament_sk = nextval('tournament_seq');

select * from stage_tournament;

--Load into dimtournament
insert into dimtournament (tournament_sk, total_prize, t_description)
select tournament_sk, total_prize, t_descriprion from stage_tournament;

select * from dimtournament;

/*Date Dimension*/
drop table stage_date;
create table stage_date (t_date date);
--insert the tournament dates from tournament 1
insert into stage_date (t_date)
select t_date from tournament1;
--insert the tournament dates from tournament 2
insert into stage_date (t_date)
select t_date from tournament2;

select * from stage_date;
--add sequence
drop sequence if exists date_seq;
create sequence date_seq 
start with 1 
increment by 1 ; 

alter table stage_date add date_sk integer;
--add surrogate key
update stage_date
set date_sk = nextval ('date_seq');

--separate the dates
insert into dimdate(d_day, d_month, d_week, dayofweek, quarter, d_year, date_sk)
select date_part('day', t_date),
date_part('month', t_date),
date_part('week', t_date),
date_part('dow', t_date),
date_part('quarter', t_date),
date_part('year', t_date), 
date_sk
from stage_date;

select * from dimdate;
select * from stage_date;

/*FactResults Dimension*/
create table stage_result(
    player_id integer,
    tournament_id integer,
    date_id integer,
    rank integer,
    prize float(8)
);
drop table stage_result;

alter table stage_result add sourcedb integer;

--insert data from result 1
insert into stage_result select p_id, t_id, null, rank, prize, 1 
from results1;
--insert data from result 2
insert into stage_result select p_id, t_id, null, rank, prize, 1 
from results2;

--make a view for date ids
drop view stage_date_view;
create view stage_date_view as
select stage_date.t_date, date_sk, player_sk from stage_date
join dimplayer on dimplayer.player_sk = stage_date.date_sk;

update stage_Result set date_id=
(select stage_date_view.date_sk from stage_date_view
where stage_Date_view.player_sk = stage_result.player_id);

select * from stage_Date;
select * from stage_result;
select * from stage_date_view;

--add sk key 
alter table stage_result add player_Sk integer;
alter table stage_result add tournament_sk integer;
alter table stage_result add date_sk integer;

/* assign values to Student_SK using stage_student as lookup*/
/* Join the dimension stage table */
update stage_result
set player_sk=
  (select stage_player.player_Sk from stage_player
where   
  stage_player.p_id = stage_result.player_id LIMIT 1) ;

select * from stage_result;

update stage_result
set tournament_sk=
  (select stage_tournament.tournament_sk from stage_tournament
where   
  stage_tournament.t_id = stage_result.tournament_id LIMIT 1);

  update stage_result
set date_sk=
  (select stage_date.date_sk from stage_Date
where   
  stage_date.date_sk = stage_result.date_id);
  
--Load into factresult
select * from factresults;
select * from stage_result;
insert into factresults select player_id, tournament_id, date_id, rank, prize
from stage_result;





