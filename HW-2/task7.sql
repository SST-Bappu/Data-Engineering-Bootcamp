-- A monthly, reduced fact table DDL

CREATE TABLE host_activity_reduced (
    month DATE,
    host varchar,
    hit_array  integer[],
    unique_visitors integer[],
    primary key (month, host)
)



