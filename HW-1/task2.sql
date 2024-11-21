
INSERT INTO actors (actorid, films, quality_class, year, is_active)
WITH yesterday as (
    select * from actors where year = 2010
),
    today as (
    select ARRAY_AGG(ROW(film,votes,rating,filmid)::film_struct) as films,year,actorid,AVG(rating) as rating from actor_films where year = 2011 group by actorid, year
    )

SELECT COALESCE(t.actorid, y.actorid) as actorid,
       CASE WHEN y.films is NULL
                THEN t.films
            WHEN t.year is not null THEN y.films || t.films
            ELSE y.films
           END as films,
       CASE WHEN t.year is not NULL THEN
                CASE WHEN t.rating > 8 THEN 'star'
                     WHEN t.rating > 7 THEN 'good'
                     WHEN t.rating > 6 THEN 'average'
                     ELSE 'bad'
                    END::quality_class
           ELSE y.quality_class
       END as quality_class,
       COALESCE(t.year,y.year+1) as year,
       CASE WHEN t.year is NULL THEN false
        ELSE true
        END as is_active

FROM today t
FULL OUTER JOIN yesterday y ON (t.actorid = y.actorid);


