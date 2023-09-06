DROP TABLE IF EXISTS DimPlayer CASCADE;
DROP TABLE IF EXISTS DimTournament CASCADE;
DROP TABLE IF EXISTS DimDate CASCADE;
DROP TABLE IF EXISTS FactResults CASCADE;

CREATE TABLE DimPlayer (
    player_sk integer primary key,
    p_name varchar(50),
    p_sname varchar(50)
);

CREATE TABLE DimTournament (
    tournament_sk integer primary key,
    t_description varchar(100),
    total_prize float(10)
);

CREATE TABLE DimDate (
    date_sk integer primary key,
    d_day integer,
    d_month integer,
    d_week integer,
    dayofweek integer,
    quarter integer,
    d_year varchar(100),
    total_prize float(8)
);

CREATE TABLE FactResults (
    player_sk integer,
    date_sk integer,
    tournament_sk integer,
    frank integer,
    prize float(8),
    CONSTRAINT pk_factresult PRIMARY KEY(player_sk, tournament_sk, date_sk),
    CONSTRAINT player_sk FOREIGN KEY(player_sk) REFERENCES DimPlayer,
    CONSTRAINT tournament_sk FOREIGN KEY(tournament_sk) REFERENCES DimTournament,
    CONSTRAINT date_sk FOREIGN KEY(date_sk) REFERENCES DimPlayer
)


