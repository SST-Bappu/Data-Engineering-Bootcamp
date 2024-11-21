-- films struct
CREATE TYPE film_struct AS (
    film VARCHAR,
    votes INT,
    rating FLOAT,
    filmid VARCHAR
    );

-- quality_class struct
CREATE TYPE quality_class AS ENUM ('star', 'good', 'average', 'bad');

-- Creating actor table
CREATE TABLE actors (
    id serial PRIMARY KEY,
    actorid varchar,
    films film_struct[],
    quality_class quality_class,
    year INT,
    is_active BOOLEAN
);

