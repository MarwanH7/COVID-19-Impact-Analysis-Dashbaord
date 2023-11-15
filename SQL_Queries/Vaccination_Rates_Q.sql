-- Picking some tables for tableau visulaizations from the previous exploratory data analysis


--- 1. Global Numbers 

--Total number of cases and vaccination_rate

SELECT SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as Percent_Vaccinated
FROM covid_deaths
WHERE continent IS NOT NULL AND new_cases IS NOT NULL AND new_deaths IS NOT NULL


-- 1. Global Total cases,deaths, and total_percent_Vaccinated
SELECT 
    SUM(total_cases) AS total_cases,
    SUM(total_deaths) AS total_deaths,
    (SUM(COALESCE(total_vaccinations, 0))/2) / SUM(population) * 100 AS Vaccination_Rate
FROM (
    SELECT 
        MAX(total_deaths) AS total_deaths,
        MAX(total_cases) AS total_cases,
        MAX(COALESCE(total_vaccinations, 0)) AS total_vaccinations,
        MAX(population) AS population
    FROM covid_deaths CD
    LEFT JOIN covid_vaccination CV ON CD.location = CV.location AND CD.date = CV.date
    WHERE CD.continent IS NOT NULL AND CD.total_deaths IS NOT NULL
    GROUP BY CD.location, CD.continent
) AS subquery
ORDER BY total_cases DESC;



---2. Continent Total Vaccinations (Please note vaccination here is defined as double dose)

SELECT 
    CD.continent,
    SUM(CD.total_cases) AS total_cases,
    SUM(CD.total_deaths) AS total_deaths,
    SUM(COALESCE(CV.total_vaccinations, 0))/ SUM(CD.population) * 100 AS Vaccination_Rate
FROM covid_deaths CD
JOIN covid_vaccination CV ON CD.location = CV.location AND CD.date = CV.date
WHERE CV.continent IS not Null --AND CD.total_deaths IS NOT NULL
GROUP BY CD.continent, CV.continent
ORDER BY Vaccination_Rate DESC;



---3 Countries Totals Vaccinations

SELECT 
    CD.location,
    CD.population,
    SUM(CD.total_cases) AS total_cases,
    SUM(CD.total_deaths) AS total_deaths,
    SUM(COALESCE(CV.total_vaccinations, 0)/2) / SUM(CD.population) * 100 AS Vaccination_Rate
FROM covid_deaths CD
LEFT JOIN covid_vaccination CV ON CD.location = CV.location AND CD.date = CV.date
WHERE CV.continent IS NOT NULL and total_cases is not null and total_deaths is not null
GROUP BY CD.location, CD.population
ORDER BY Vaccination_Rate DESC;


---4. Countries Total Infection_Rates over time (Time series) 

SELECT
  CD.location,  -- Selecting the location column
  CD.population,  -- Selecting the population column
  CD.date,  -- Selecting the date column
  COALESCE(MAX(CD.total_cases), 0) as TotalCaseCount,  -- Replacing NULL values with 0 in TotalCaseCount
  SUM(COALESCE(CV.total_vaccinations, 0)/2) / SUM(CD.population) * 100 AS Vaccination_Rate  -- Calculating Death_Percent and handling division by zero
  -- Using PARTITION BY to partition the data by country (location)
FROM covid_deaths CD
LEFT JOIN covid_vaccination CV ON CD.location = CV.location AND CD.date = CV.date
WHERE
  CD.continent IS NOT NULL AND CD.total_cases IS NOT NULL AND CD.total_deaths IS NOT NULL  -- Filtering rows with non-NULL total_cases and non-NULL total_deaths
GROUP BY
  CD.location, CD.population, CD.date, CD.continent   -- Grouping by specific columns
--HAVING MAX(total_deaths) IS NOT NULL AND continent IS NOT NULL  -- Filtering rows with non-NULL total_deaths and non-NULL continent
ORDER BY
  date asc

