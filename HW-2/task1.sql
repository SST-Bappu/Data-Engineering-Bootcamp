WITH dups as (SELECT *,
                     ROW_NUMBER() OVER (PARTITION BY player_id, game_id, team_id) as rn
              FROM games_details)

SELECT *
FROM dups
WHERE rn = 1