select * from netflix_raw;
--------------------------------------------------------------------------
-- Re-designing the structure of the table.
-- First we will drop the table and make clone one with better constraints for memory allocation.

DROP TABLE netflix_raw;

create TABLE netflix_raw(
    show_id varchar(10)PRIMARY KEY,
    type VARCHAR(10),
    title VARCHAR(200),
    director VARCHAR(250),
    cast varchar(1000),
    country VARCHAR(150),
    date_added varchar(20),
    release_year INT,
    rating VARCHAR(10),
    duration VARCHAR(10),
    listed_in varchar(100),
    description varchar(500)
);

------------------------------------------------------------------------------------------------

-- Remove duplicates 

select show_id, count(*)
from netflix_raw
group by show_id 
having count(*) > 1;

select * from netflix_raw
where concat(upper(title),type) in (select concat(upper(title),type)
						from netflix_raw
						group by upper(title),type
						having count(*)>1)
order by title;

with cte as
(select *, row_number() over( partition by upper(title),upper(type) order by show_id) as rn
from netflix_raw 
)
select show_id,type,title,cast(date_added as date)as date_added,release_year,rating,
	   case when duration is null then rating else duration end as duration, description
insert into netflix
from cte 

select * from netflix;

-----------------------------------------------------------------------------------------------------
-- create separate tables for the columns : listed_in, director, country, cast 

Create table netflix_directors as
select show_id, trim(regexp_split_to_table(director, ',')) as director
from netflix_raw;

select * from netflix_directors;

---------------------------------

Create table netflix_listed_in as
select show_id, trim(regexp_split_to_table(listed_in, ',')) as genre
from netflix_raw;

select * from netflix_listed_in ;

---------------------------------

Create table netflix_country as
select show_id, trim(regexp_split_to_table(country, ',')) as country
from netflix_raw;

select * from netflix_country;

---------------------------------

Create table netflix_cast as
select show_id, trim(regexp_split_to_table('cast', ',')) as cast
from netflix_raw;

select * from netflix_cast;

---------------------------------
-- Fill the missing values in country, duration columns 

select * 
from netflix_raw
where country is null;

select director,country
from netflix_country nc inner join netflix_directors nd 
on nc.show_id = nd.show_id
group by director,country

insert into netflix_country(
select show_id,m.country
from netflix_raw nr
inner join (select director,country
from netflix_country nc inner join netflix_directors nd 
on nc.show_id = nd.show_id
group by director,country)m on nr.director = m.director
where nr.country is null);


--------------------------------------------------------

-- Now we will perform the analysis on the data that we have just cleaned.

/* 1. For each director count the no. of movies and TV shows created by them in separate columns 
      for the directors who have created tv shows and movies both */

select nd.director,
	   count(distinct case when n.type = 'Movie' then n.show_id end) as no_of_movies,
	   count(distinct case when n.type = 'TV Show' then n.show_id end) as no_of_tvshows
from netflix n inner join netflix_directors nd 
on n.show_id = nd.show_id 
group by nd.director
having count(distinct n.type) > 1

/* 2. Which country has highest number of comedy shows ? */

select nc.country, count(distinct l.show_id) as no_of_comedy_movies
from netflix_country nc inner join netflix_listed_in l 
on nc.show_id = l.show_id inner join netflix n on l.show_id = n.show_id
where n.type = 'Movie' and l.genre = 'Comedies'
group by nc.country
order by no_of_comedy_movies desc;


/* 3. For each year (as per date added to netflix), which director has maximum number of movies released ? */

with cte as 
(select nd.director, extract(year from n.date_added) as date_year, count(n.show_id) as no_of_movies
from netflix n inner join netflix_directors nd 
on n.show_id = nd.show_id
where n.type = 'Movie'
group by nd.director, extract(year from n.date_added)
)
,cte2 as 
(select *,
		row_number() over(partition by date_year order by no_of_movies desc,director) as rn
from cte
)
select * from cte2
where rn = 1;


-- 4. What is average duration of movies in each genre?

select nl.genre, round(avg(cast(replace(n.duration, ' min','') as int)),0) as avg_duration 
from netflix n inner join netflix_listed_in nl
on n.show_id = nl.show_id
where n.type = 'Movie'
group by nl.genre

/* 5. Find the list of directors who have created  horror and comedy movies both.
      display director names along with number of comedy and horror movies directed by them. */

select nd.director, 
       count(distinct case when nl.genre = 'Comedies' then n.show_id end)as no_of_comedy,
	   count(distinct case when nl.genre = 'Horror Movies' then n.show_id end ) as no_of_horror
from netflix_directors nd inner join netflix_listed_in nl
on nd.show_id = nl.show_id inner join netflix n 
on nd.show_id = n.show_id
where n.type = 'Movie' and nl.genre in ('Comedies','Horror Movies')
group by nd.director
having count(distinct genre) = 2









