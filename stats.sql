/* combien de coureurs ont participé au tour de france */
SELECT count(DISTINCT cyclist_id)
FROM race_runners
WHERE year >= 1947;

/* combien de dossards ? */
SELECT count(1)
FROM race_runners
WHERE year >= 1947;

/* combien de nationalité */
SELECT count(DISTINCT nationality)
FROM race_runners;

/* combien de coureurs par nationalité ! attention, un coureur peu en changer dans sa carrière, cette stat est donc bordeline */
SELECT
  count(DISTINCT c.id),
  rr.nationality
FROM race_runners rr
  JOIN cyclists c ON c.id = rr.cyclist_id
GROUP BY rr.nationality;

/* nombre de ville-étapes */
SELECT count(1)
FROM stage_locations;

/* nombre d'étapes */
SELECT count(1)
FROM stages;

/* nombre de jour de course */
SELECT count(DISTINCT year, stagenb)
FROM stages;
