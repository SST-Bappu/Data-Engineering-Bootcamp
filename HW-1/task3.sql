-- actors history DDL, as we store year (and not date) in the actors table,
-- we assume start and end date here to be year
CREATE TABLE actors_history_scd (
    id serial PRIMARY KEY,
    actorid varchar,
    start_date int,
    end_date int,
    quality_class quality_class,
    is_active boolean
);
