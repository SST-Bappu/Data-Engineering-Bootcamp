INSERT INTO edges
WITH dups as (SELECT *, ROW_NUMBER() OVER (PARTITION BY player_id, game_id) as rn
              FROM games_details),
     filtered_games as (SELECT * FROM dups WHERE rn = 1),

     aggregated as (SELECT f1.player_id as subject_identifier,
                           f1.player_name as subject_name,
                           f2.player_id as object_identifier,
                           f2.player_name as object_name,
                           COUNT(1)                                 as games_played,
                           SUM(f1.pts)                              as left_points,
                           SUM(f2.pts)                              as right_points,
                           CASE
                               WHEN f1.team_id = f2.team_id THEN 'shared_team'::edge_type
                               ELSE 'played_against'::edge_type END as edge_type
                    FROM filtered_games f1
                             JOIN filtered_games f2 ON f1.game_id = f2.game_id
                    WHERE f1.player_id != f2.player_id
                      AND f1.player_id < f2.player_id
                    GROUP BY f1.player_id, f1.player_name, f2.player_id, f2.player_name, edge_type)

select
    subject_identifier,
    'player'::vertex_type  as subject_type,
    object_identifier,
    'player'::vertex_type  as object_type,
    edge_type,
    json_build_object(
            'subject_name', subject_name,
            'object_name', object_name,
            'games_played', games_played,
            'left_points', left_points,
            'right_points', right_points
    )                      as properties
from aggregated;




