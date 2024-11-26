CREATE TABLE user_devices_cumulated (
    user_id integer,
    browser_type character varying,
    device_activity_datelist TIMESTAMP[],
    "date" DATE,
    PRIMARY KEY (user_id, browser_type,"date")
)

select * from user_devices_cumulated where user_id=326

select count(*) from user_devices_cumulated
