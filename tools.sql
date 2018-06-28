-- il y a 10 ans, 20 ans ...
SELECT
  s.year,
  s.start,
  s.finish,
  s.stage_type,
  ig.*
FROM stages s
  JOIN ig_stage_results ig ON ig.stage_id = s.id
WHERE day(s.date) = day(now()) AND month(s.date) = month(now());

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
      AND datediff(last_stage.date, s.date) < 8