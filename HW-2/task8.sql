-- Here is the incremental query that loads host_activity_reduced day by day
-- The monthly users CTE aggregate the monthly unique visitors of
WITH monthly_users as (SELECT host, ARRAY_AGG(DISTINCT user_id) as unique_visitors
FROM host_activity
WHERE DATE_TRUNC('month', activity_date)=DATE_TRUNC('month', DATE('2024-01-15'))
GROUP BY host),

--  the hit_count CTE counts the hit for each day of a month
hit_count as (SELECT host, activity_date,COUNT(activity_date) as hits
                 FROM host_activity
                 WHERE DATE_TRUNC('month', activity_date)=DATE_TRUNC('month', DATE('2024-01-15'))
                 GROUP BY host, activity_date
                 order by activity_date),

-- the monthly_hits CTE aggregate the hits of each days of the month in an array
monthly_hits as (SELECT host, ARRAY_AGG(hits) as hit_array
                 FROM hit_count
                 GROUP BY host ),

-- finally I am joining the monthly_hits and monthly_users
-- CTE to generate reduced fact data with hit_array and unique visitors array
reduced_data as (SELECT mh.host, mh.hit_array, mu.unique_visitors, DATE_TRUNC('month', DATE('2024-01-15')) as month
FROM monthly_users mu
JOIN monthly_hits mh ON (mu.host = mh.host))

-- Inserting new host or updating existing host here
-- One thing to be noted here is that, I am not Concatenating exiting array while updating.
-- Because this is monthly reduced fact table,
-- and the query that generate fact data today should include the result of yesterday
INSERT INTO host_activity_reduced (host, hit_array, unique_visitors, month)
SELECT * FROM reduced_data
ON CONFLICT (host, month)
    DO UPDATE SET
               hit_array = EXCLUDED.hit_array,
               unique_visitors = EXCLUDED.unique_visitors



