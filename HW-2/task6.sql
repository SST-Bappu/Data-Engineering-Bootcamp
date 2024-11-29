-- to write an incremental query,
-- I need to generate the host cumulated data first.
-- here is that cumulated query
INSERT INTO public.hosts_cumulated
WITH yesterday as (
    SELECT user_id, host, host_activity_datelist, date
    FROM hosts_cumulated
    WHERE date = DATE('2024-01-10')
    GROUP BY date,user_id, host,host_activity_datelist
    ORDER BY user_id, host
),
     today as (
         SELECT user_id, host,
                array_agg(activity_date) as date_list,
                DATE('2024-01-11') as date
         from host_activity
         WHERE activity_date=DATE('2024-01-11')
         GROUP BY user_id, host
         ORDER BY user_id, host
     )
SELECT
    COALESCE(y.user_id, t.user_id) as user_id,
    COALESCE(y.host, t.host) as host,
    CASE WHEN y.host_activity_datelist is NULL
             THEN t.date_list
         WHEN t.date_list is not null THEN y.host_activity_datelist || t.date_list
         ELSE y.host_activity_datelist
        END as device_activity_datelist,
    COALESCE(t.date, y.date + INTERVAL '1 day')::DATE as date
from yesterday y
         FULL OUTER JOIN today t ON (y.user_id = t.user_id AND y.host = t.host)



-- as data is already cumulated,
-- I can write the incremental query now.

-- let's create a table first to store the history data
CREATE TABLE hosts_history_scd (
                                    id serial,
                                    host varchar,
                                    users integer[],
                                    "date" DATE,
                                    PRIMARY KEY (id, host)
);

-- In the incremental query, I will try to generate new user to each of the hosts and I will generate new hosts with its users as well

-- Let's update the existing hosts if they get any new user

WITH existing_hosts as (SELECT host, array_agg(DISTINCT (user_id) ) as users
                        FROM hosts_cumulated
                        where date>=DATE('2024-01-11') AND host IN (SELECT host FROM hosts_history_scd)
                        GROUP BY host)

UPDATE hosts_history_scd
SET users = ARRAY(SELECT DISTINCT UNNEST(hosts_history_scd.users || eh.users) ORDER BY 1),
    date = DATE('2024-01-11')
FROM existing_hosts eh
WHERE hosts_history_scd.host = eh.host


-- Now it's time to generate new host into the hosts_history_scd table
INSERT INTO hosts_history_scd(host,users,"date")
WITH new_hosts as (SELECT host, array_agg(DISTINCT (user_id) ) as users
                  FROM hosts_cumulated
                  where date>=DATE('2024-01-11') AND host NOT IN (SELECT host FROM hosts_history_scd)
                GROUP BY host)

SELECT *,DATE('2024-01-10') as "date" FROM new_hosts







