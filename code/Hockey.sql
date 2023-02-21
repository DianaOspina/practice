--This data set shows:
-- Summer Olympic editions started in 1896 and have been held every 4 years since 
SELECT DISTINCT edition, edition_id 
FROM Olympic_Athlete_Event_Results oaer 
ORDER BY edition

--Sports that participated in first edition
SELECT DISTINCT sport  
FROM Olympic_Athlete_Event_Results oaer 
WHERE edition LIKE '1896%'

	Artistic Gymnastics
	Athletics
	Cycling Road
	Cycling Track
	Fencing
	Swimming
	Shooting
	Weightlifting
	Tennis
	Wrestling

--When was this sport introduced to the Olympics? 

SELECT DISTINCT edition 
FROM Olympic_Athlete_Event_Results oaer 
WHERE sport LIKE '%Hockey%'
ORDER BY edition 

--countries participated in intro edition (5 & 7)

SELECT DISTINCT country_noc AS Country
FROM Olympic_Athlete_Event_Results oaer 
WHERE event = 'Ice Hockey, Men' AND edition_id = 7
ORDER BY edition

-- For Hockey 1908 and held every 4 years except 1912 & 1916, 1924 also skipped 1940 & 1944
SELECT DISTINCT edition 
FROM Olympic_Athlete_Event_Results oaer 
WHERE event = 'Hockey, Men'
ORDER BY edition

--We realized there are several modalities
SELECT DISTINCT event
FROM Olympic_Athlete_Event_Results oaer 
WHERE sport LIKE '%Hockey%'

--Roller Hockey, Men
--Hockey, Men
--Ice Hockey, Men
--Ice Hockey, Women
--Hockey, Women
--Ice Hockey Exhibition, Men

--When was each modality introduced to the Olympics? 
SELECT *
FROM Olympic_Athlete_Event_Results oaer 
WHERE event = 'Hockey, Men'
ORDER BY edition 
--1908

SELECT DISTINCT edition
FROM Olympic_Athlete_Event_Results oaer 
WHERE event = 'Hockey, Women'
ORDER BY edition
--1980

SELECT DISTINCT *
FROM Olympic_Athlete_Event_Results oaer 
WHERE event = 'Ice Hockey, Men'
ORDER BY edition
--1920

SELECT DISTINCT edition 
FROM Olympic_Athlete_Event_Results oaer 
WHERE event = 'Ice Hockey, Women'
ORDER BY edition
--1998

--How many countries typically participate? 

--Number of countries per Edition
SELECT DISTINCT edition,
count (country_noc) OVER (PARTITION BY edition_id) AS number_countries
FROM Olympic_Athlete_Event_Results oaer 
WHERE event = 'Hockey, Men'
ORDER BY edition

--Avg of all Countries for Men =190.58
WITH cte AS 
(
SELECT DISTINCT edition,
count (country_noc) OVER (PARTITION BY edition_id) AS number_countries
FROM Olympic_Athlete_Event_Results oaer 
WHERE event = 'Hockey, Men'
ORDER BY edition
)
SELECT round (AVG(number_countries),2) avg_countries
FROM cte  

--Avg of all countries for Women = 159.91
WITH cte AS 
(
SELECT DISTINCT edition,
count (country_noc) OVER (PARTITION BY edition_id) AS number_countries
FROM Olympic_Athlete_Event_Results oaer 
WHERE event = 'Hockey, Women'
ORDER BY edition
)
SELECT round (AVG(number_countries),2) avg_countries
FROM cte

--Similar to above query number of countries per edition for male (both modalities)
SELECT DISTINCT edition, sport, 
count (country_noc) OVER (PARTITION BY edition_id)
FROM Olympic_Athlete_Event_Results oaer 
WHERE event LIKE '%Hockey, Men'
ORDER BY edition
----Similar to above query number of countries per edition for female (both modalities)
SELECT DISTINCT edition, sport, 
count (country_noc) OVER (PARTITION BY edition_id)
FROM Olympic_Athlete_Event_Results oaer 
WHERE event LIKE '%Hockey, Women'
ORDER BY edition


--How many players are on an Olympic team in your sport? 
SELECT DISTINCT edition, country_noc,  
count (athlete_id) OVER (PARTITION BY country_noc)
FROM Olympic_Athlete_Event_Results oaer 
WHERE event LIKE 'Hockey, Men' --AND edition_id = 1
ORDER BY edition

SELECT DISTINCT edition, sport,country_noc, 
count (athlete_id) OVER (PARTITION BY edition_id)
FROM Olympic_Athlete_Event_Results oaer 
WHERE event LIKE 'Hockey, Women'--and country_noc = 'GBR'
ORDER BY edition

--Which is more pop by country participation men Hockey or Ice Hockey? (42 vs 37)
SELECT DISTINCT country_noc
FROM Olympic_Athlete_Event_Results oaer
WHERE event = 'Hockey, Men'
ORDER BY 1

SELECT DISTINCT country_noc
FROM Olympic_Athlete_Event_Results oaer
WHERE event = 'Ice Hockey, Men'
ORDER BY 1

--Which is more pop (by country participation) women Hockey or Ice Hockey? (22 vs 16)
SELECT DISTINCT country_noc
FROM Olympic_Athlete_Event_Results oaer
WHERE event = 'Hockey, Women'
ORDER BY 1

SELECT DISTINCT country_noc
FROM Olympic_Athlete_Event_Results oaer
WHERE event = 'Ice Hockey, Women'
ORDER BY 1

--countries participated IN Hockey men but NOT Hockey women  (42 vs 22)
-- how can join 2 tables??

WITH men_count AS 
(
SELECT count(DISTINCT country_noc) AS men_count
FROM Olympic_Athlete_Event_Results oaer
WHERE event = 'Hockey, Men'
ORDER BY 1
)

SELECT men_count - women_count
FROM (	SELECT count(DISTINCT country_noc)AS women_count
		FROM Olympic_Athlete_Event_Results oaer
		WHERE event = 'Hockey, Women'
		ORDER BY 1)
JOIN cte

--Who has won the most gold medals in your sport? 
SELECT edition, country_noc--, 
--count(*) OVER (PARTITION BY edition  )
FROM Olympic_Athlete_Event_Results oaer 
WHERE event = 'Hockey, Men' AND medal = 'Gold'
GROUP BY edition 
ORDER BY 1

--Who has won the most gold medals in your sport? 
--Hockey Men

WITH cte AS 
(
SELECT edition, country_noc
FROM Olympic_Athlete_Event_Results oaer 
WHERE event = 'Hockey, Men' AND medal = 'Gold'
GROUP BY edition 
ORDER BY 1
)
SELECT country_noc, count(country_noc) AS number_gold_medal
FROM cte
GROUP BY country_noc 
ORDER BY 2 DESC 

--Ice Hockey Men
WITH cte AS 
(
SELECT edition, country_noc
FROM Olympic_Athlete_Event_Results oaer 
WHERE event = 'Ice Hockey, Men' AND medal = 'Gold'
GROUP BY edition 
ORDER BY 1
)
SELECT country_noc, count(country_noc) AS number_gold_medal
FROM cte
GROUP BY country_noc 
ORDER BY 2 DESC 

--Who won Gold medal each edition Hockey Men
SELECT edition, country_noc
FROM Olympic_Athlete_Event_Results oaer 
WHERE event = 'Hockey, Men' AND medal = 'Gold'
GROUP BY edition 
ORDER BY 1

----Who won Gold medal each edition Ice Hockey Men
SELECT edition, country_noc
FROM Olympic_Athlete_Event_Results oaer 
WHERE event = 'Ice Hockey, Men' AND medal = 'Gold'
GROUP BY edition 
ORDER BY 1


--Who has won the most silver medals in your sport?
--Hockey
WITH cte AS 
(
SELECT edition, country_noc
FROM Olympic_Athlete_Event_Results oaer 
WHERE event = 'Hockey, Men' AND medal = 'Silver'
GROUP BY edition 
ORDER BY 1
)
SELECT country_noc, count(country_noc) AS number_silver_medal
FROM cte
GROUP BY country_noc 
ORDER BY 2 DESC 

--Ice Hockey
WITH cte AS 
(
SELECT edition, country_noc
FROM Olympic_Athlete_Event_Results oaer 
WHERE event = 'Ice Hockey, Men' AND medal = 'Silver'
GROUP BY edition 
ORDER BY 1
)
SELECT country_noc, count(country_noc) AS number_silver_medal
FROM cte
GROUP BY country_noc 
ORDER BY 2 DESC 

--who won Silver medal each edition
SELECT edition, country_noc
FROM Olympic_Athlete_Event_Results oaer 
WHERE event = 'Hockey, Men' AND medal = 'Silver'
GROUP BY edition 
ORDER BY 1

--Who has won the most bronze medals in your sport? 
--Hockey
WITH cte AS 
(
SELECT edition, country_noc
FROM Olympic_Athlete_Event_Results oaer 
WHERE event = 'Hockey, Men' AND medal = 'Bronze'
GROUP BY edition 
ORDER BY 1
)
SELECT country_noc, count(country_noc) AS number_Bronze_medal
FROM cte
GROUP BY country_noc 
ORDER BY 2 DESC 

--Ice Hockey
WITH cte AS 
(
SELECT edition, country_noc
FROM Olympic_Athlete_Event_Results oaer 
WHERE event = 'Ice Hockey, Men' AND medal = 'Bronze'
GROUP BY edition 
ORDER BY 1
)
SELECT country_noc, count(country_noc) AS number_Bronze_medal
FROM cte
GROUP BY country_noc 
ORDER BY 2 DESC 

--who won Bronze medal each edition
SELECT edition, country_noc
FROM Olympic_Athlete_Event_Results oaer 
WHERE event = 'Hockey, Men' AND medal = 'Bronze'
GROUP BY edition 
ORDER BY 1

--Does one team dominate the sport?
--If dominate = country who has won most medals Gold + Silver + Bronze

WITH cte AS 
(
SELECT *,
	count (*) OVER (PARTITION BY edition)
FROM Olympic_Athlete_Event_Results oaer 
WHERE event = 'Hockey, Men' AND medal IN ('Gold','Silver', 'Bronze')
GROUP BY country_noc 
ORDER BY edition 
)

SELECT country_noc, count(country_noc) AS number_gold_medal
FROM cte
GROUP BY country_noc 
ORDER BY 2 DESC 


SELECT *
FROM Olympic_Athlete_Event_Results oaer 
WHERE event = 'Hockey, Men' AND edition_id = 7
GROUP BY country_noc 
ORDER BY medal



--What teams/countries have never won a medal in your sport? 
WITH cte AS 
(
SELECT country_noc, 
	sum (CASE 
		WHEN medal ='na' THEN 0
		ELSE 1
	END) AS any_medal
FROM Olympic_Athlete_Event_Results oaer
WHERE sport LIKE '%Hockey%'
GROUP BY country_noc 
ORDER BY 1
)
SELECT *
FROM cte 
where any_medal = 0

-- My code gives me 49 countries, I did not sum the case WHEN 
WITH cte AS 
(
SELECT country_noc, 
	CASE 
		WHEN medal ='na' THEN 0
		ELSE 1
	END AS any_medal
FROM Olympic_Athlete_Event_Results oaer
WHERE sport LIKE '%Hockey%'
GROUP BY country_noc 
ORDER BY 1
)
SELECT *
FROM cte
WHERE any_medal = 0

-- Table showing edition, countries with gold, silver & bronze medal

SELECT edition, 
	max(CASE WHEN medal = 'Gold' THEN country_noc ELSE 0
		END) AS Gold,
	max(CASE WHEN medal = 'Silver' THEN country_noc ELSE 0
 		END) AS Silver,
	MAX(CASE WHEN medal = 'Bronze' THEN country_noc ELSE 0
 		END) AS Bronze
FROM Olympic_Athlete_Event_Results oaer 
WHERE event = 'Ice Hockey, Men'
GROUP BY edition  
ORDER BY edition 

SELECT edition, 
	max(CASE WHEN medal = 'Gold' THEN country_noc ELSE 0
		END) AS Gold,
	max(CASE WHEN medal = 'Silver' THEN country_noc ELSE 0
 		END) AS Silver,
	MAX(CASE WHEN medal = 'Bronze' THEN country_noc ELSE 0
 		END) AS Bronze
FROM Olympic_Athlete_Event_Results oaer 
WHERE event = 'Ice Hockey, Women'
GROUP BY edition  
ORDER BY edition 

--My original attempt
WITH cte AS
(
SELECT edition, 
	CASE WHEN medal = 'Gold' THEN country_noc ELSE 0
		END AS Gold,
	CASE WHEN medal = 'Silver' THEN country_noc ELSE 0
 		END AS Silver,
	CASE WHEN medal = 'Bronze' THEN country_noc ELSE 0
 		END AS Bronze
FROM Olympic_Athlete_Event_Results oaer 
WHERE event = 'Ice Hockey, Men' AND  edition_id = 7
--GROUP BY edition  
ORDER BY edition 
)
SELECT *
FROM cte
WHERE Gold != 0 OR  Silver !=0 OR Bronze !=0
--GROUP BY edition 
ORDER BY edition 
