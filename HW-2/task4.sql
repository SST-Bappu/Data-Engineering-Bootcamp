-- Here, I am  taking the user date list here,
-- I stored login time as timestamp initially.
-- Consequently, I am converting it into date and generating another array.
WITH date_list as (select user_id,
                          date,
                          ARRAY(SELECT DISTINCT DATE(d) FROM unnest(device_activity_datelist) AS d) AS device_activity_dates
                   from user_devices_cumulated
                   where date = DATE('2022-11-27')),
     series as (SELECT generate_series('2022-11-20',
                                       '2022-11-30', INTERVAL '1 day') as series_date)

-- This is making the comparison with the user date list and the generated series date
SELECT *,
       CASE
           WHEN device_activity_dates @> ARRAY [DATE(series_date)]
               THEN POW(2, 32 - (date - DATE(series_date)))::BIGINT
           ELSE 0
           END::BIT(32) as int_value
FROM date_list
         CROSS JOIN series

