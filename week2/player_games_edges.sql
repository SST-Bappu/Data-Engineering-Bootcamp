INSERT
INTO edges
WITH dups as (SELECT *, ROW_NUMBER() OVER (PARTITION BY player_id, game_id) as rn
              FROM games_details)
SELECT player_id              as subject_identifier,
       'player'::vertex_type  as subject_type,
        game_id                as object_identifier,
       'game'::vertex_type    as object_type,
        'played_in'::edge_type as edge_type,
        json_build_object(
                'start_position', start_position,
                'team_id', team_id,
                'team_avvreviation', team_abbreviation,
                'pts', pts
        )                      as properties
FROM dups
where rn = 1