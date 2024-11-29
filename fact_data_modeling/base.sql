CREATE TABLE login_log
(
    user_id integer,
    login_time timestamp,
    browser character varying,
    device character varying,
    ip_address character varying,
    country character varying,
    PRIMARY KEY (user_id, login_time)
)

CREATE TABLE host_activity
(
    id serial,
    user_id integer,
    host varchar,
    activity_date DATE
)
select max(activity_date), min(host_activity.activity_date)
from host_activity
