CREATE TABLE athlete_performance_by_country AS 
SELECT 
    ae.*, 
    nr.region AS Country
FROM 
    athlete_events ae 
LEFT JOIN 
    noc_regions nr ON ae.NOC = nr.NOC;

-- Medal distribution by Country
SELECT 
    Country,
    COUNT(CASE WHEN Medal = 'Gold' THEN 1 END) AS Gold_Medals,
    COUNT(CASE WHEN Medal = 'Silver' THEN 1 END) AS Silver_Medals,
    COUNT(CASE WHEN Medal = 'Bronze' THEN 1 END) AS Bronze_Medals,
    COUNT(Medal) AS Total_Medals
FROM 
    athlete_performance_by_country
GROUP BY 
    Country
ORDER BY 
    Gold_Medals DESC;

-- Average age trends across different sports
SELECT 
    Sport, 
    ROUND(AVG(Age), 2) AS Avg_Age,
    COUNT(DISTINCT ID) AS Total_Athletes,
    COUNT(CASE WHEN Medal = 'Gold' THEN 1 END) AS Gold_Medals,
    COUNT(CASE WHEN Medal = 'Silver' THEN 1 END) AS Silver_Medals,
    COUNT(CASE WHEN Medal = 'Bronze' THEN 1 END) AS Bronze_Medals
FROM 
    athlete_performance_by_country
GROUP BY 
    Sport
ORDER BY 
    Avg_Age ASC;

-- Medal efficiency by Country (Medals per Athlete)
SELECT 
    Country,
    COUNT(DISTINCT ID) AS Total_Athletes,
    COUNT(CASE WHEN Medal = 'Gold' THEN 1 END) AS Gold_Medals,
    COUNT(CASE WHEN Medal = 'Silver' THEN 1 END) AS Silver_Medals,
    COUNT(CASE WHEN Medal = 'Bronze' THEN 1 END) AS Bronze_Medals,
    COUNT(Medal) AS Total_Medals,
    ROUND(COUNT(Medal) * 1.0 / COUNT(DISTINCT ID), 4) AS Medal_Efficiency
FROM 
    athlete_performance_by_country
GROUP BY 
    Country
HAVING 
    Total_Athletes > 0
ORDER BY 
    Medal_Efficiency DESC;
