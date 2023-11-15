-- Picking some tables for tableau visulaizations from the previous exploratory data analysis


-- 1. Global Total cases,deaths, and death percentage
SELECT 
    SUM(total_deaths)AS total_deaths,--summing total deaths
    SUM(total_cases) AS total_cases,
    SUM(total_deaths) / SUM(population) * 100 AS Death_Rate
FROM (
    SELECT 
        MAX(total_deaths) AS total_deaths,-- Selecting the total_deaths column
        MAX(total_cases) AS total_cases,  -- Selecting the total_cases column
        MAX(population) AS population -- Selecting the population column
    FROM covid_deaths
    WHERE continent IS NOT NULL AND total_deaths IS NOT NULL
    GROUP BY location, continent
) AS subquery
ORDER BY total_cases DESC;



---2. Total cases, deaths, and death % per location (continent)


SELECT location, max(total_deaths) as TotalDeathcount, max(total_cases) as TotalCaseCount, max(total_deaths)/max(population)*100 as Death_Percent

FROM covid_deaths
WHERE continent is NULL

GROUP BY location
HAVING max(total_deaths) IS NOT NULL 
ORDER BY Death_Percent DESC


---3 Totals locations countires 

SELECT location, population,max(total_deaths) as TotalDeathcount, max(total_cases) as TotalCaseCount, max(total_deaths)/max(population)*100 as Death_Percent
FROM covid_deaths
GROUP BY  location, population, continent
HAVING max(total_deaths) IS NOT NULL and continent IS NOT NULL 
ORDER BY Death_Percent DESC



---4. Totals locations countires with dates(for time series)

SELECT location, population, date ,max(total_deaths) as TotalDeathcount, max(total_cases) as TotalCaseCount, max(total_deaths)/max(total_cases)*100 as Death_Percent
FROM covid_deaths
GROUP BY  location, population, continent,date
HAVING max(total_deaths) IS NOT NULL and continent IS NOT NULL 
ORDER BY Death_Percent DESC
limit 2000;

--- Replacing NULL values with 0 beacuse they are getting read as string values in tableau 

-- Selecting columns and applying COALESCE to handle NULL values
-- Selecting columns and applying COALESCE to handle NULL values

SELECT
  location,  -- Selecting the location column
  population,  -- Selecting the population column
  date,  -- Selecting the date column
  COALESCE(MAX(total_deaths), 0) as TotalDeathcount,  -- Replacing NULL values with 0 in TotalDeathcount
  COALESCE(MAX(total_cases), 0) as TotalCaseCount,  -- Replacing NULL values with 0 in TotalCaseCount
  COALESCE(MAX(total_deaths), 0) / COALESCE(MAX(population), 1) * 100 as Death_Percent  -- Calculating Death_Percent and handling division by zero
  -- Using PARTITION BY to partition the data by country (location)
FROM
  covid_deaths
GROUP BY
  location, population, continent, date, total_deaths, total_cases  -- Grouping by specific columns
HAVING
  MAX(total_deaths) IS NOT NULL AND continent IS NOT NULL  -- Filtering rows with non-NULL total_deaths and non-NULL continent
ORDER BY
  date asc  -- Ordering the result by Death_Percent in descending order
---5.


