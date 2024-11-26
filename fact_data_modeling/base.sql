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

copy login_log from '/Volumes/Developement/learning/data_engineering_bootcamp/fact_data_modeling/login_logs.csv' delimiter ',' csv header;

