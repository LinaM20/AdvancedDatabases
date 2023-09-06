-- ACTOR (id, fname, lname, gender)
-- MOVIE (id, name, year)
-- DIRECTORS (id, fname, lname)
-- CASTS (pid, mid, role)
-- MOVIE_DIRECTORS (did, mid)
-- GENRE (mid, genre)
-- All id fields and year are integers, all other fields are character strings.
-- You can change the names of the fields if you wish.
-- You can use varchar(xx) for the character strings (people's names have maximum 30 characters, roles and genres have maximum 50, and movie titles have maximum 150). You should define the gender field to be one single character long.

--Impose constraints
-- ACTOR.id, MOVIE.id, DIRECTOR.id = a key
-- CASTS.pid = foreign key to ACTOR.id
-- CASTS.mid, MOVIE_DIRECTORS.mid = foreign key to MOVIE.id
-- MOVIE_DIRECTORS.did = foreign key to DIRECTORS.id

CREATE TABLE ACTOR (
    actor_id INT PRIMARY KEY, 
    fname VARCHAR(30),
    lname VARCHAR(30),
    gender CHAR(1)
);

CREATE TABLE MOVIE (
    movie_id INT PRIMARY KEY,
    movie_name VARCHAR(150),
    movie_year INT
);

CREATE TABLE DIRECTORS (
    director_id INT PRIMARY KEY,
    d_fname VARCHAR(30),
    d_lname VARCHAR(30)
);


CREATE TABLE CASTS (
    pid INT,
    movie_id INT,
    crole VARCHAR(50),
    PRIMARY KEY(pid),
    CONSTRAINT fk_actors FOREIGN KEY(pid) REFERENCES ACTOR(actor_id),
    CONSTRAINT fk_movie_cast FOREIGN KEY(movie_id) REFERENCES MOVIE(movie_id)
);

CREATE TABLE MOVIE_DIRECTORS (
    movie_id INT,
    director_id INT,
    CONSTRAINT fk_movie FOREIGN KEY(movie_id) REFERENCES MOVIE(movie_id),
    CONSTRAINT fk_director FOREIGN KEY(director_id) REFERENCES DIRECTORS(director_id)
);

CREATE TABLE GENRE (
    movie_id INT,
    genre VARCHAR(50),
    CONSTRAINT fk_movie_genre FOREIGN KEY(movie_id) REFERENCES MOVIE(movie_id)
);

--Inserting data
INSERT INTO ACTOR (actor_id, fname, lname, gender) VALUES 
(8293, 'Jared', 'Leto', 'M'),
(2938, 'Tom', 'Holland', 'M'),
(1092, 'Tom', 'Cruise', 'M'),
(2213, 'Dwayne', 'Johnson', 'M'),
(6473, 'Zoe', 'Saldana', 'F'),
(2098, 'Natalie', 'Portman', 'F');

INSERT INTO MOVIE (movie_id, movie_name, movie_year) VALUES
(98374, 'Morbius', 2022),
(33425, 'Uncharted', 2022),
(63725, 'Mission: Impossible - Dead Reckoning - Part One', 2023),
(63826, 'Black Adam', 2022),
(74926, 'Avatar: The Way of Water', 2022),
(13948, 'Thor: Love and Thunder', 2022);

INSERT INTO DIRECTORS (director_id, d_fname, d_lname) VALUES
(232, 'Daniel', 'Espinosa'),
(654, 'Ruben', 'Fleischer'),
(253, 'Christopher', 'McQuarrie'),
(676, 'Jaume', 'Collet-Serra'),
(984, 'James', 'Cameron'),
(281, 'Taika', 'Waitit');

INSERT INTO CASTS (pid, movie_id, crole) VALUES 
(8293, 98374, 'Dr. Michael Morbius'),
(2938, 33425, 'Nathan Drake'),
(1092, 63725, 'Ethan Hunt'),
(2213, 63826, 'Black Adam'),
(6473, 74926, 'Neytiri'),
(2098, 13948, 'Jane Foster');

INSERT INTO MOVIE_DIRECTORS (movie_id, director_id) VALUES
(98374, 232),
(33425, 654),
(63725, 253),
(63826, 676),
(74926, 984),
(13948, 281);

INSERT INTO GENRE (movie_id, genre) VALUES
(98374, 'Horror'),
(33425, 'Action'),
(63725, 'Thriller'),
(63826, 'Fantasy'),
(74926, 'Fantasy'),
(13948, 'Adventure');

--Queries
--First and last names of all the actors, including the names of movies
SELECT (fname, lname, movie_name) FROM ACTOR 
JOIN CASTS ON pid=actor_id
JOIN MOVIE USING (movie_id);

--Name of all the directors and the total number of movies they have directed
SELECT COUNT(movie_id), d_fname, d_lname FROM DIRECTORS 
INNER JOIN MOVIE_DIRECTORS USING (director_id)
GROUP BY d_fname, d_lname;

--Name of all the movies that are Fantasy
SELECT movie_name, genre FROM MOVIE
INNER JOIN GENRE USING (movie_id)
WHERE genre = 'Fantasy';

--List the actors and their corresponding roles
SELECT fname, lname, crole FROM ACTOR
INNER JOIN CASTS on pid=actor_id
GROUP BY fname, lname, crole;

--Find the total number of male actors
SELECT COUNT(gender) 
FROM ACTOR
WHERE gender = 'M';


DROP TABLE ACTOR;
DROP TABLE CASTS;
DROP TABLE DIRECTORS;
DROP TABLE GENRE;
DROP TABLE MOVIE;
DROP TABLE MOVIE_DIRECTORS;