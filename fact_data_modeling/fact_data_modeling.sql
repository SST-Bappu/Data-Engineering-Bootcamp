INSERT INTO fct_game_details
WITH dups as (SELECT g.game_date_est,
                     g.season,
                     g.home_team_id,
                     gd.*,
                     ROW_NUMBER() OVER (PARTITION BY gd.game_id,player_id, team_id,g.game_date_est ORDER BY g.game_date_est) as rn
              FROM games_details gd
                       JOIN games g ON (gd.game_id = g.game_id)
              )

SELECT game_date_est as dim_team_date,
       season as dim_season,
       team_id as dim_team_id,
       player_id as dim_player_id,
       player_name as dim_player_name,
       start_position as dim_start_position,
       team_id = home_team_id as dim_is_home_team,
       COALESCE(position('DNP' in comment), 0) > 0 as dim_did_not_play,
       COALESCE(position('DND' in comment), 0) > 0 as dim_did_not_dress,
       COALESCE(position('NWT' in comment), 0) > 0 as dim_not_with_team,
       CASE
           WHEN min is not null THEN
               CAST(split_part(min, ':', 1) as REAL) +
               CASE WHEN split_part(min, ':', 2) <> '' THEN CAST(split_part(min, ':', 2) as REAL) / 60 ELSE 0 END
           ELSE 0 END                            as m_minutes,
       fgm as m_fgm,
       fga as m_fga,
       fg3m as m_fg3m,
       fg3a as m_fg3a,
       ftm as m_ftm,
       fta as m_fta,
       oreb as m_oreb,
       dreb as m_dreb,
       reb as m_reb,
       ast as m_ast,
       stl as m_stl,
       blk as m_blk,
       "TO" as m_turnovers,
       pf as m_pf,
       pts as m_pts,
       plus_minus as m_plus_minus
FROM dups
WHERE rn = 1;


