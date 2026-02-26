-- Identify the 2025 rounds
SELECT raceId, name, round
FROM races
WHERE year = 2025
ORDER BY round;

-- Get Verstappen, Piastri and Norris's Driver IDs
SELECT driverId, forename, surname
FROM drivers
WHERE forename IN ('Max', 'Oscar', 'Lando') AND surname IN ('Verstappen', 'Piastri', 'Norris')

-- Race results for Verstappen, Piastri and Norris in 2025
SELECT DISTINCT
r.year,
r.round,
r.name AS race_name,
d.forename,
d.surname,
res.position,
res.points,
res.laps
FROM results res
JOIN races r ON res.raceId = r.raceId
JOIN drivers d ON res.driverId = d.driverId
WHERE r.year = 2025
  AND res.driverId IN (846, 830, 857)
ORDER BY r.round, d.surname;

-- Number of each finishing position for Verstappen, Piastri and Norris in 2025
SELECT
d.forename,
d.surname,
CAST(res.position AS INT) AS finish_position,
COUNT(*) AS finishes
FROM results res
JOIN races r ON res.raceId = r.raceId
JOIN drivers d ON res.driverId = d.driverId
WHERE r.year = 2025
AND res.driverId IN (846, 830, 857)
AND res.position IS NOT NULL
GROUP BY d.forename, d.surname, CAST(res.position AS INT)
ORDER BY finish_position, finishes DESC;

-- DNFs for Verstappen, Piastri and Norris in 2025
SELECT
d.forename,
d.surname,
COUNT(*) AS dnf_count
FROM results res
JOIN races r ON res.raceId = r.raceId
JOIN drivers d ON res.driverId = d.driverId
JOIN status s ON res.statusId = s.statusId
WHERE r.year = 2025
AND res.driverId IN (846, 830, 857)
AND s.status NOT IN ('"Finished"','"+1 Lap"', '"+2 Laps"', '"+3 Laps"', '"+4 Laps"','"+5 Laps"', '"+6 Laps"', '"+7 Laps"', '"+8 Laps"', '"+9 Laps"')
GROUP BY d.forename, d.surname
ORDER BY dnf_count DESC;

-- Qualifying results for Verstappen, Piastri and Norris in 2025
SELECT
r.round,
r.name AS race_name,
q.position AS qualifying_position,
d.forename,
d.surname,
q.position AS quali_position,
q.q1, q.q2, q.q3
FROM qualifying q
JOIN races r ON q.raceId = r.raceId
JOIN drivers d ON q.driverId = d.driverId
WHERE r.year = 2025
AND q.driverId IN (846, 830, 857)
ORDER BY r.round, q.position;

-- Most Q1, Q2, Q3 exits for Verstappen, Piastri and Norris in 2025
SELECT
d.forename,
d.surname,
SUM(CASE WHEN q.q1 = '\N' THEN 1 ELSE 0 END) AS q1_exits,
SUM(CASE WHEN q.q2 = '\N' THEN 1 ELSE 0 END) AS q2_exits,
SUM(CASE WHEN q.q3 = '\N' THEN 1 ELSE 0 END) AS q3_exits
FROM qualifying q
JOIN drivers d ON q.driverId = d.driverId
JOIN races r ON q.raceId = r.raceId
WHERE q.driverId IN (846, 830, 857) AND r.year = 2025
GROUP BY d.forename, d.surname
ORDER BY q3_exits DESC, q2_exits DESC, q1_exits DESC;

-- Most poles for Verstappen, Piastri and Norris in 2025
SELECT
d.forename,
d.surname,
COUNT(*) AS pole_count
FROM qualifying q
JOIN drivers d ON q.driverId = d.driverId
JOIN races r ON q.raceId = r.raceId
WHERE q.position = 1 AND r.year = 2025 AND q.driverId IN (846, 830, 857)
GROUP BY d.forename, d.surname
ORDER BY pole_count DESC;

-- Average Finishing Position for Verstappen, Piastri and Norris in 2025
SELECT
d.forename,
d.surname,
AVG(CAST(res.position AS FLOAT)) AS avg_finishing_position
FROM results res
JOIN drivers d ON res.driverId = d.driverId
JOIN races r ON res.raceId = r.raceId
WHERE r.year = 2025 AND res.driverId IN (846, 830, 857) AND res.position IS NOT NULL
GROUP BY d.forename, d.surname
ORDER BY avg_finishing_position ASC;

-- Average qualifying position
SELECT
d.forename,
d.surname,
AVG(CAST(q.position AS FLOAT)) AS avg_qualifying_position
FROM qualifying q
JOIN drivers d ON q.driverId = d.driverId
JOIN
races r ON q.raceId = r.raceId
WHERE r.year = 2025 AND q.driverId IN (846, 830, 857) AND q.position IS NOT NULL
GROUP BY d.forename, d.surname
ORDER BY avg_qualifying_position ASC;

-- Position changes (racecraft) for Verstappen, Piastri and Norris in 2025
SELECT
d.forename,
d.surname,
AVG(CAST(res.position AS FLOAT) - CAST(q.position AS FLOAT)) AS avg_position_change
FROM results res
JOIN qualifying q ON res.raceId = q.raceId AND res.driverId = q.driverId
JOIN drivers d ON res.driverId = d.driverId
JOIN races r ON res.raceId = r.raceId
WHERE r.year = 2025 AND res.driverId IN (846, 830, 857) AND res.position IS NOT NULL AND q.position IS NOT NULL
GROUP BY d.forename, d.surname
ORDER BY avg_position_change DESC;

