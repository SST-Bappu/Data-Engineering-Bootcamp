CREATE TABLE hosts_cumulated
(
    user_id                  integer,
    host             character varying,
    host_activity_datelist TIMESTAMP[],
    "date"                   DATE,
    PRIMARY KEY (user_id, host, "date")
)


