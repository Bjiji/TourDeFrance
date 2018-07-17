-- il y a 10 ans, 20 ans ...
SELECT
  count(1),
  rr.nationality
FROM stages s
  JOIN ig_stage_results ig ON ig.stage_id = s.id
  JOIN race_runners rr ON rr.id = ig.stage_winner_id
WHERE day(s.date) = day(now()) AND month(s.date) = month(now())
-- AND ((year(now()) - s.year) % 5 = 0 OR (year(now()) - s.year) = 1)


-- AND ig.previous_leader <> ig.leader_id
-- and rr.nationality like "Nether%"
GROUP BY rr.nationality
-- rr.cyclist_id;
;


SELECT
  s.year,
  s.stageNb,
  s.start,
  s.finish,
  s.stage_type,
  ig.stage_winner_s,
  ig.leader_s,
  rr.nationality
FROM stages s
  JOIN ig_stage_results ig ON ig.stage_id = s.id
  JOIN race_runners rr ON rr.id = ig.stage_winner_id
WHERE day(s.date) = day(now()) AND month(s.date) = month(now())
      AND dayofweek(s.date) = 6

-- AND ((year(now()) - s.year) % 5 = 0 or (year(now()) - s.year) = 1)
--       and ig.previous_leader <> ig.leader_id
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

SELECT
  count(1),
  department
FROM stage_locations sl
  JOIN stages s ON s.start_location = sl.id OR s.finish_location = sl.id
GROUP BY sl.code;

SELECT
  count(DISTINCT (s.id)),
  department
FROM stage_locations sl
  JOIN stages s ON s.start_location = sl.id OR s.finish_location = sl.id
GROUP BY sl.code;


SELECT
  s.year,
  s.stageNb,
  s.subStageNb,
  s.start,
  s.finish,
  sl.department
FROM stage_locations sl
  JOIN stages s ON s.start_location = sl.id OR s.finish_location = sl.id
WHERE sl.code = 28;

SELECT
  count(1),
  sl.department,
  sl.code
FROM cyclists c
  JOIN race_runners rr ON rr.cyclist_id = c.id
  JOIN ig_stage_results isr ON isr.stage_winner_id = rr.id
  JOIN stages s ON s.id = isr.stage_id
  JOIN stage_locations sl ON sl.id = s.finish_location
WHERE rr.nationality LIKE "France%" OR c.nationality LIKE "France%"
GROUP BY sl.code;

SELECT
  count(1),
  rr.lastname
FROM race_runners rr
  JOIN ig_stage_results ig ON ig.stage_winner_id = rr.id
WHERE rr.nationality LIKE "Columbia%"
GROUP BY rr.cyclist_id;


SELECT
  max(s0.id) AS exist,
  count(DISTINCT c.id),
  group_concat(DISTINCT (r0.lastname)),
  s.year,
  s.ordinal,
  s.start,
  s.finish
FROM stages s
  JOIN ite_stage_results isr ON isr.stage_id = s.id
  JOIN race_runners rr ON rr.id = isr.race_runner_id
  JOIN cyclists c ON c.id = rr.cyclist_id
  JOIN race_runners r0 ON r0.cyclist_id = c.id
  JOIN ig_stage_results ig ON ig.leader_id = r0.id
  LEFT JOIN stages s0 ON s0.id = ig.stage_id AND (s0.year < s.year OR (s0.year = s.year AND s0.ordinal < s.ordinal))
WHERE rr.nationality LIKE "france" AND s.year > 1947
GROUP BY s.id
HAVING count(DISTINCT c.id) < 5;


SELECT
  s.year,
  s.start,
  s.finish,
  s.stage_type,
  min(ig.pos)
FROM stages s
  JOIN ite_stage_results ig ON ig.stage_id = s.id
  JOIN race_runners rr ON rr.id = ig.race_runner_id
WHERE day(s.date) = day(now()) AND month(s.date) = month(now())
      -- AND ((year(now()) - s.year) % 5 = 0 OR (year(now()) - s.year) = 1)


      -- AND ig.previous_leader <> ig.leader_id
      AND rr.nationality LIKE "France%"
--
GROUP BY s.id
HAVING min(ig.pos) >= 7

