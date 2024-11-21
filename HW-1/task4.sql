INSERT INTO actors_history_scd (actorid, start_date, end_date, quality_class, is_active)
WITH changes as (
    SELECT actorid,year,quality_class,is_active,
           year-ROW_NUMBER() OVER (PARTITION BY actorid, quality_class,is_active ORDER BY year) as period
    FROM actors),


 changes_period as (
    SELECT actorid, MIN(year) as start_date, MAX(year) as end_date,
           quality_class, is_active
    FROM changes
 GROUP BY actorid, quality_class, is_active, period)

select * from changes_period
order by actorid, start_date;






