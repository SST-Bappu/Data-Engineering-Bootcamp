CREATE TABLE games
(
    GAME_DATE_EST    DATE,
    GAME_ID          INT,
    GAME_STATUS_TEXT CHARACTER VARYING,
    HOME_TEAM_ID     INT,
    VISITOR_TEAM_ID  INT,
    SEASON           INT,
    TEAM_ID_home     INT,
    PTS_home         FLOAT,
    FG_PCT_home      FLOAT,
    FT_PCT_home      FLOAT,
    FG3_PCT_home     FLOAT,
    AST_home         FLOAT,
    REB_home         FLOAT,
    TEAM_ID_awa      INT,
    PTS_away         FLOAT,
    FG_PCT_away      FLOAT,
    FT_PCT_away      FLOAT,
    FG3_PCT_away     FLOAT,
    AST_away         FLOAT,
    REB_away         FLOAT,
    HOME_TEAM_WINS   INT
);

CREATE TABLE games_details
(
    GAME_ID           INT,
    TEAM_ID           INT,
    TEAM_ABBREVIATION CHARACTER VARYING,
    TEAM_CITY         CHARACTER VARYING,
    PLAYER_ID         INT,
    PLAYER_NAME       CHARACTER VARYING,
    NICKNAME          CHARACTER VARYING,
    START_POSITION    CHARACTER VARYING,
    COMMENT           CHARACTER VARYING,
    MIN               CHARACTER VARYING,
    FGM               FLOAT,
    FGA               FLOAT,
    FG_PCT            FLOAT,
    FG3M              FLOAT,
    FG3A              FLOAT,
    FG3_PCT           FLOAT,
    FTM               FLOAT,
    FTA               FLOAT,
    FT_PCT            FLOAT,
    OREB              FLOAT,
    DREB              FLOAT,
    REB               FLOAT,
    AST               FLOAT,
    STL               FLOAT,
    BLK               FLOAT,
    "TO"              FLOAT,
    PF                FLOAT,
    PTS               FLOAT,
    PLUS_MINUS        FLOAT
);
CREATE TABLE teams
(
    LEAGUE_ID         CHARACTER VARYING,
    TEAM_ID          INT,
    MIN_YEAR        INT,
    MAX_YEAR       INT,
    ABBREVIATION   CHARACTER VARYING,
    NICKNAME      CHARACTER VARYING,
    YEARFOUNDED INT,
    CITY        CHARACTER VARYING,
    ARENA      CHARACTER VARYING,
    ARENACAPACITY INT,
    OWNER     CHARACTER VARYING,
    GENERALMANAGER CHARACTER VARYING,
    HEADCOACH CHARACTER VARYING,
    DLEAGUEAFFILIATION CHARACTER VARYING
);
copy teams from '/Volumes/Developement/learning/data_engineering_bootcamp/week2/teams.csv' delimiter ',' csv header;

CREATE TYPE vertex_type AS ENUM ('player', 'team', 'game');

CREATE TABLE vertices
(
    identifier TEXT,
    type       vertex_type,
    properties JSON,
    PRIMARY KEY (identifier, type)
);

CREATE TYPE edge_type AS ENUM ('played_on', 'played_in', 'played_against', 'shared_team');

CREATE TABLE edges
(
    subject_identifier TEXT,
    subject_type       vertex_type,
    object_identifier  TEXT,
    object_type        vertex_type,
    edge_type          edge_type,
    properties         JSON,
    PRIMARY KEY (subject_identifier, subject_type, object_identifier, object_type, edge_type)
);

