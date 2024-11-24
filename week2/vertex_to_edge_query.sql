
SELECT
    v.properties ->> 'player_name' as player_name,
    e.object_identifier,
    CASE WHEN v.properties ->> 'total_points' = '0' THEN 1 ELSE CAST(v.properties ->> 'total_points' as REAL) END/CAST(v.properties ->> 'games_played' as REAL) as points_per_game,
    e.properties ->>'games_played' as games_played
FROM vertices v
JOIN edges e ON (v.identifier = e.subject_identifier and e.object_type = 'player')
WHERE v.type= 'player'


select * from vertices where type='player' limit 10