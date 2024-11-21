-- the first part of this task is taken from task4 with slide modifications,
-- to insert the new periods
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



SELECT * FROM changes_period WHERE start_date>2010 ORDER BY actorid, start_date;
-- till this will insert the new periods



-- we also need to update the existing data to recognize the overlaps

WITH changes as (
    SELECT actorid,year,quality_class,is_active,
           year-ROW_NUMBER() OVER (PARTITION BY actorid, quality_class,is_active ORDER BY year) as period
    FROM actors),


     changes_period as (
         SELECT actorid, MIN(year) as start_date, MAX(year) as end_date,
                quality_class, is_active
         FROM changes
         GROUP BY actorid, quality_class, is_active, period)

UPDATE actors_history_scd
SET end_date = cp.end_date
FROM changes_period cp
WHERE actors_history_scd.actorid = cp.actorid
  AND actors_history_scd.quality_class = cp.quality_class
  AND actors_history_scd.is_active = cp.is_active
  AND cp.start_date <= 2010
  AND cp.end_date > 2010
  AND actors_history_scd.start_date = cp.start_date;




