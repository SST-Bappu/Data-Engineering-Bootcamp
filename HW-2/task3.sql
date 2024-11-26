INSERT INTO public.user_devices_cumulated
WITH yesterday as (
    SELECT user_id, browser_type, device_activity_datelist, date
    FROM user_devices_cumulated
    WHERE date = DATE('2022-11-26')
    GROUP BY date,user_id, browser_type,device_activity_datelist
    ORDER BY user_id, browser_type
),
today as (
    SELECT user_id, browser as browser_type,
           array_agg(login_time) as date_list,
           DATE('2022-11-27') as date
    from login_log
    WHERE login_time::DATE='2022-11-27'
    GROUP BY user_id, browser
    ORDER BY user_id, browser
)
SELECT
    COALESCE(y.user_id, t.user_id) as user_id,
    COALESCE(y.browser_type, t.browser_type) as browser_type,
    CASE WHEN y.device_activity_datelist is NULL
        THEN t.date_list
        WHEN t.date_list is not null THEN y.device_activity_datelist || t.date_list
        ELSE y.device_activity_datelist
    END as device_activity_datelist,
    COALESCE(t.date, y.date + INTERVAL '1 day')::DATE as date
from yesterday y
FULL OUTER JOIN today t ON (y.user_id = t.user_id AND y.browser_type = t.browser_type)





