INSERT INTO vertices
SELECT game_id             as identifier,
       'game'::vertex_type as type,
       json_build_object(
               'pts_home', pts_home,
               'pts_away', pts_away,
               'winning_team', CASE WHEN home_team_wins = 1 THEN home_team_id ELSE team_id_awa END
       )                   as properties
FROM games;


insert into vertices
SELECT player_id             as identifier,
       'player'::vertex_type as type,
       json_build_object(
               'player_name', player_name,
               'games_played', COUNT(1),
               'total_points', SUM(pts),
               'teams_played_for', ARRAY_AGG(DISTINCT team_id)
       )                     as properties

FROM games_details
GROUP BY player_id, player_name;

insert into vertices
SELECT team_id             as identifier,
       'team'::vertex_type as type,
       json_build_object(
               'team_name', abbreviation,
               'head_coach', headcoach,
               'city', city,
               'arena', arena
       )                   as properties
FROM teams;





SELECT v.properties ->> 'player_name' as player_name,
       MAX(CAST(e.properties ->> 'pts' as INTEGER)) as max_points
FROM vertices v
         JOIN edges e ON v.identifier = e.subject_identifier
group by 1
ORDER BY 2 DESC
