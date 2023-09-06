--query to find all tiger woods ranks and prizes
select p_name, p_sname, rank, prize
from dimplayer
join factresults using(player_sk)
where p_name = 'Tiger';

--query to find all the prize money won each month
select avg(prize), month
from factresults join dimdate using(date_Sk)
group by month order by month asc;

--average ranking achieved by player each month
select player_Sk, p_sname, rank, month
from dimplayer join factresults using (player_Sk)
join dimdate using(date_sk);

--total prize money on monday
select sum(prize) 
from factresults join dimdate using(date_sk)
where dayofweek = 1;

select fr.player_sk, dp.p_sname as p_lastname, dt.t_descriprion as t_desc, fr.prize, rank, year 
from factresults fr 
join dimplayer dp on fr.player_sk = dp.player_sk 
join dimdate dd on fr.date_sk = dd.date_sk 
join dimtournament dt on fr.tournament_sk = dt.tournament_sk;