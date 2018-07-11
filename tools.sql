-- il y a 10 ans, 20 ans ...
SELECT
  s.year,
  s.start,
  s.finish,
  s.stage_type,
  ig.*
FROM stages s
  JOIN ig_stage_results ig ON ig.stage_id = s.id
WHERE day(s.date) = day(now()) AND month(s.date) = month(now()) AND (year(now()) - s.year) % 5 = 0
-- and ig.previous_leader <> ig.leader_id
;

-- 3 porteurs (ou plus) du maillot jaune dans la meme équipe
SELECT
  count(DISTINCT rr.id) AS cnt,
  r.year,
  rt.label,
  group_concat(DISTINCT rr.lastname)
FROM races r
  JOIN race_runners rr ON rr.race_id = r.id
  JOIN race_teams rt ON rt.id = rr.race_team_id
  JOIN stages s ON s.race_id = r.id
  JOIN ig_stage_results ig ON ig.stage_id = s.id AND ig.leader_id = rr.id
GROUP BY r.id, rt.id
HAVING count(DISTINCT rr.id) > 2;

-- équipe finissant à moins de 4 coureurs
SELECT
  count(DISTINCT rr.id) AS cnt,
  r.year,
  rt.label,
  group_concat(DISTINCT rr.lastname)
FROM races r
  JOIN race_runners rr ON rr.race_id = r.id
  JOIN race_teams rt ON rt.id = rr.race_team_id
  JOIN stages s ON s.race_id = r.id
  -- join ig_stage_results ig on ig.stage_id = s.id and ig.leader_id = rr.id
  JOIN ite_stage_results ite ON ite.stage_id = s.id AND ite.race_runner_id = rr.id
WHERE s.is_last = 1
GROUP BY r.id, rt.id
HAVING count(DISTINCT rr.id) < 4;

-- changement du maillot jaune en dernière semaine
SELECT
  s.year,
  s.stageNb,
  s.start,
  s.finish,
  r0.lastname,
  r.lastname
FROM stages s
  JOIN stages last_stage ON last_stage.year = s.year AND last_stage.is_last
  JOIN ig_stage_results ig ON ig.stage_id = s.id
  JOIN race_runners r ON r.id = ig.leader_id
  JOIN race_runners r0 ON r0.id = ig.previous_leader
WHERE ig.previous_leader <> ig.leader_id
      AND datediff(last_stage.date, s.date) < 8;

SELECT
  sl.name,
  group_concat(DISTINCT (lower(trim(replace(if(s.start_location = sl.id, s.start, s.finish), '-', ' ')))))
FROM
               stage_locations sl
               JOIN stages s ON s.start_location = sl.id OR s.finish_location = sl.id
               GROUP BY sl.id
               HAVING count(1) > 10;

SELECT
  rt.id,
  rr.year,
  rt.label,
  rt.year,
  count(DISTINCT (rr.nationality)) AS dn,
  group_concat(DISTINCT (rr.nationality))
FROM race_runners rr
  JOIN race_teams rt ON rt.id = rr.race_team_id
GROUP BY rt.id, rr.year
HAVING dn > 5;


SELECT rr.*
FROM race_runners rr
  JOIN race_teams rt ON rt.id = rr.race_team_id
-- join ite_stage_results ite on ite.race_runner_id = rr.id
WHERE rt.id = 3368;

-- select * from race_runners where lastname like "CAVENDISH" and year = 2015;

SELECT
  count(*),
  rr.nationality
FROM ig_stage_results ig
  JOIN race_runners rr ON rr.id = ig.stage_winner_id
  JOIN cyclists c ON c.id = rr.cyclist_id
GROUP BY rr.nationality;

SELECT *
FROM race_runners
WHERE nationality IS NULL;

SELECT
  count(DISTINCT cyclist_id),
  rr.nationality
FROM race_runners rr
GROUP BY rr.nationality;

SELECT count(1)
FROM
  stage_locations sl
  JOIN stages s ON s.start_location = sl.id OR s.finish_location = sl.id
GROUP BY sl.id
HAVING cnt > 1;

SELECT count(1)
FROM stage_locations;

/* échappé terminant victorieuse */
SELECT
  s.year,
  s.stageNb,
  s.start,
  s.finish
FROM ite_stage_results ite
  JOIN stages s ON s.id = ite.stage_id
WHERE ite.pos = 5 AND ite.diff_time_sec > 9
      AND (s.stage_type = "plaine" OR s.stage_type = "MM");