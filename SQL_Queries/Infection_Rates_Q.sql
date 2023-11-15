-- Picking some tables for tableau visulaizations from the previous exploratory data analysis


-- 1. Global Total Infection_Rate

SELECT 
    TO_CHAR(SUM(total_cases), '999,999,999') AS total_cases,
    SUM(total_deaths) AS total_deaths,
    SUM(total_cases) / SUM(population) * 100 AS Total_Infection_Rate
FROM (
    SELECT 
        MAX(total_cases) AS total_cases,
        MAX(total_deaths) AS total_deaths,
        MAX(population) AS population
    FROM covid_deaths
    WHERE continent IS NOT NULL AND total_deaths IS NOT NULL
    GROUP BY location, continent
) AS subquery
ORDER BY total_cases DESC;



---2. Continent Total Infection_Rate


SELECT location,TO_CHAR(SUM(new_cases), '999,999,999') AS total_cases, max(total_cases)/max(population)*100 as Infection_Rate
From covid_deaths
WHERE continent is NULL
GROUP BY location
HAVING max(total_deaths) IS NOT NULL 
ORDER BY Infection_Rate DESC






---3 Countries Totals Infection_Rates

SELECT location, population,TO_CHAR(max(total_cases), '999,999,999') AS total_cases,Max((total_cases/population))*100 as Infection_Rate
FROM covid_deaths
GROUP BY  location, population, continent
HAVING max(total_deaths) IS NOT NULL and continent IS NOT NULL 
ORDER BY Infection_Rate DESC



---4. Countries Total Infection_Rates over time (Time series) 

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From covid_deaths
Group by Location, Population, date
HAVING max(total_deaths) IS NOT NULL and continent IS NOT NULL 
order by date asc
limit 2000;


SELECT
  location,  -- Selecting the location column
  population,  -- Selecting the population column
  date,  -- Selecting the date column
  COALESCE(MAX(total_cases), 0) as TotalCaseCount,  -- Replacing NULL values with 0 in TotalCaseCount
  COALESCE(MAX(total_cases), 0) / COALESCE(MAX(population), 1) * 100 as Infection_Rate  -- Calculating Death_Percent and handling division by zero
  -- Using PARTITION BY to partition the data by country (location)
FROM
  covid_deaths
GROUP BY
  location, population, date, continent   -- Grouping by specific columns
HAVING
  MAX(total_deaths) IS NOT NULL AND continent IS NOT NULL  -- Filtering rows with non-NULL total_deaths and non-NULL continent
ORDER BY
  date asc

  limit 2000;


  -- Ordering the result by Death_Percent in descending order
  -- Limiting the result to 2000 rows