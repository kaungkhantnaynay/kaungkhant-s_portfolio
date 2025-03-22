-- Data Cleaning

select *
from top_expensive_leagues;

-- Step 1: Create a temporary table with the minimum `League ID` to delete duplicates for each group
CREATE TEMPORARY TABLE temp_leagues AS
SELECT MIN(`League ID`) AS `League ID`
FROM top_expensive_leagues
GROUP BY `League ID`, `League Name`, `Country`, `Sport`, `Revenue (USD)`, `Average Player Salary (USD)`,
         `Top Team`, `Total Teams`, `Founded Year`, `Viewership`;
         
-- Delete rows from the `top_expensive_leagues` table where `League ID` is not in the temporary table
DELETE FROM top_expensive_leagues
WHERE `League ID` NOT IN (SELECT `League ID` FROM temp_leagues);

-- Drop the temporary table
DROP TEMPORARY TABLE temp_leagues;



-- Step 2: Standardize Data
UPDATE top_expensive_leagues
SET `Country` = CONCAT(UCASE(LEFT(`Country`, 1)), LOWER(SUBSTRING(`Country`, 2))),
    `Sport` = CONCAT(UCASE(LEFT(`Sport`, 1)), LOWER(SUBSTRING(`Sport`, 2)));

UPDATE top_expensive_leagues
SET `League Name` = TRIM(`League Name`),
    `Country` = TRIM(`Country`),
    `Sport` = TRIM(`Sport`),
    `Top Team` = TRIM(`Top Team`);

-- Remove leagues with extremely high or low revenue
DELETE FROM top_expensive_leagues
WHERE `Revenue (USD)` > 1e12 OR `Revenue (USD)` < 1e5;

-- Remove leagues with unrealistic player salaries
DELETE FROM top_expensive_leagues
WHERE `Average Player Salary (USD)` > 1e7;

-- Round revenue and salary to 2 decimal places
UPDATE top_expensive_leagues
SET `Revenue (USD)` = ROUND(`Revenue (USD)`, 2),
    `Average Player Salary (USD)` = ROUND(`Average Player Salary (USD)`, 2);

-- Normalize country names (example for known inconsistencies)
UPDATE top_expensive_leagues
SET `Country` = 'USA' WHERE `Country` IN ('United States', 'U.S.', 'America');

-- Step 3: Validate Numerical Columns
UPDATE top_expensive_leagues
SET `Revenue (USD)` = NULL
WHERE `Revenue (USD)` < 0;

UPDATE top_expensive_leagues
SET `Average Player Salary (USD)` = NULL
WHERE `Average Player Salary (USD)` < 0;

UPDATE top_expensive_leagues
SET `Viewership` = NULL
WHERE `Viewership` < 0;

UPDATE top_expensive_leagues
SET `Founded Year` = NULL
WHERE `Founded Year` < 1800 OR `Founded Year` > 2024;

ALTER TABLE top_expensive_leagues
ADD CONSTRAINT unique_league_id UNIQUE (`League ID`(255));

DELETE t1
FROM top_expensive_leagues t1
INNER JOIN top_expensive_leagues t2
ON t1.`League Name` = t2.`League Name`
   AND t1.`Country` = t2.`Country`
   AND t1.`Sport` = t2.`Sport`
   AND t1.`League ID` > t2.`League ID`;


select *
from top_expensive_leagues;

-- Step 4: Create a view for top-performing leagues
CREATE VIEW top_leagues AS
SELECT `League Name`, `Country`, `Sport`, `Revenue (USD)`, `Revenue per Team`, `Average Player Salary (USD)`, `Salary as % of Revenue`, `Revenue Rank`, `Viewership Rank`
FROM top_expensive_leagues
ORDER BY `Revenue (USD)` DESC
LIMIT 10;



