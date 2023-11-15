

--------------------------------------------
-- Exploratory Data Analysis on Covid Data

-- Data Source: https://ourworldindata.org/covid-deaths
-- Basic initial queries to get a feel for the data
--Percentage calculations

----------------------

-- Starting with Covid deaths table

-- Looking at Total cases vs Total Deaths (Basically the % of people who died from Covid = death rate) 
-- Shows the likelihood of dying from Covid if you get it in canada 

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100  as  DeathPercent

FROM covid_deaths
WHERE location like '%States'
ORDER BY 1,2
LIMIT 200000;



SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100  as  DeathPercent

FROM covid_deaths
WHERE location like '%Canada'
ORDER BY 1,2
LIMIT 200000;


-- Looking at Total Cases Vs Population 


SELECT location, date, total_cases,population, (total_cases/population)*100  as CovidPatiencePercent

FROM covid_deaths
WHERE location like '%Canada'
ORDER BY 1,2
LIMIT 100000;


-- Countries with the highest infection rates compare to population 


SELECT location, max(total_cases) as HighestInfectionCount, population, Max((total_cases/population))*100  as CovidPatiencePercent

FROM covid_deaths
GROUP BY  location, population
HAVING Max((total_cases/population))*100 IS NOT NULL
ORDER BY CovidPatiencePercent DESC
LIMIT 100000;


-- Countries with the Highest Death count per population 



SELECT location, max(total_deaths) as TotalDeathcount
FROM covid_deaths
GROUP BY  location, population, continent
HAVING max(total_deaths) IS NOT NULL and continent IS NOT NULL 
ORDER BY TotalDeathcount DESC


-- Breaking Things down by continent

--Method 1 

SELECT continent, max(total_deaths) as TotalDeathcount
FROM covid_deaths
WHERE continent is not NULL

GROUP BY continent
HAVING max(total_deaths) IS NOT NULL 
ORDER BY TotalDeathcount DESC

-- Method 2 


SELECT location, max(total_deaths) as TotalDeathcount
FROM covid_deaths
WHERE continent is NULL

GROUP BY location
HAVING max(total_deaths) IS NOT NULL 
ORDER BY TotalDeathcount DESC


-- These next queries are created with keeping in mind the "drill down effect" when visualising data later in tableau

-- Global Numbers 

--1

Select  SUM(new_cases) as total_cases , SUM(new_deaths) as total_deaths, SUM(new_deaths)/sum(new_cases)*100 as DeathPercent
From covid_deaths
where continent is not NULL and new_cases is not NULL and new_deaths is not NULL


--2

Select  date,SUM(new_cases) as total_cases , total_deaths, SUM(new_deaths) as total_deaths, SUM(new_deaths)/sum(new_cases)*100 as DeathPercent
From covid_deaths
WHERE continent is not NULL and new_cases is not NULL and new_cases <> 0 and new_deaths is not NULL and new_deaths <> 0

GROUP BY date,total_deaths
ORDER BY date ASC


Select date, new_cases, max(new_cases) as total_cases
from covid_deaths
where continent is not NULL and new_cases is not NULL and new_cases <> 0
GROUP BY date, new_cases
ORDER BY date ASC


--- Using Window Function to calculate the rolling sum of cases and deaths and percentage of deaths


--1 
SELECT date,

new_cases, SUM(new_cases) OVER (ORDER BY date) as sum_of_cases,
total_deaths,SUM(total_deaths) OVER (ORDER BY date) as sum_of_deaths,
SUM(total_deaths) OVER (ORDER BY date) / SUM(new_cases) OVER (ORDER BY date) as rolling_death_percent

       
FROM covid_deaths
WHERE continent is not NULL and new_cases is not NULL and new_cases <> 0 
      and new_deaths is not NULL and new_deaths <> 0
GROUP BY date, total_deaths,new_cases
ORDER BY date ASC;


---------------------
SELECT date,

new_cases, SUM(new_cases) OVER (ORDER BY date) as sum_of_cases,
total_deaths,SUM(total_deaths) OVER (ORDER BY date) as sum_of_deaths
-- SUM(total_deaths) / SUM(new_cases) rolling_death_percent

       
FROM covid_deaths
WHERE continent is not NULL 

-- and new_cases is not NULL and new_cases <> 0 
--       and new_deaths is not NULL and new_deaths <> 0
GROUP BY date, total_deaths,new_cases
ORDER BY date ASC;





--2 

SELECT 

SUM(new_cases) OVER (ORDER BY date) as sum_of_cases,
SUM(total_deaths) OVER (ORDER BY date) as sum_of_deaths,
SUM(total_deaths) OVER (ORDER BY date) / SUM(new_cases) OVER (ORDER BY date) as rolling_death_percent

       
FROM covid_deaths
WHERE continent is not NULL and new_cases is not NULL and new_cases <> 0 
      and new_deaths is not NULL and new_deaths <> 0
GROUP BY date, total_deaths,new_cases
ORDER BY date DESC;





--------------------------------------------

-- Joining both tables, covid deaths and covid vaccinations
-- Joining on location and date 

SELECT * 

FROM covid_deaths CD
JOIN covid_vaccination CV
ON CD.location = CV.location AND CD.date = CV.date
LIMIT 10000;



-- Total Population vs Vaccinations 

SELECT CD.continent, CD.location, CD.date, CD.population, CV.new_vaccinations, CV.total_vaccinations

FROM covid_deaths CD
JOIN covid_vaccination CV
ON CD.location = CV.location AND CD.date = CV.date

WHERE CD.continent is not null AND CD.location like '%Canada'
ORDER BY 1,2,3
LIMIT 10000



-- Create the Total vaccination function from the new_vaccinations column using window function and partition by 


SELECT CD.continent, CD.location, CD.date, CD.population, CV.new_vaccinations, CV.total_vaccinations,
SUM(CV.new_vaccinations) OVER (ORDER BY CD.date) as RollingTotalVaccinations
FROM covid_deaths CD
JOIN covid_vaccination CV
ON CD.location = CV.location AND CD.date = CV.date

WHERE CD.continent is not null AND CD.location like '%Canada'
ORDER BY 1,2,3
LIMIT 10000



-- Total number of vaccinations per population

-- Method 1 with rolling sums 

SELECT CD.continent, CD.location, CD.date, CD.population, CV.new_vaccinations, CV.total_vaccinations,
SUM(CV.new_vaccinations) OVER (ORDER BY CD.date) as RollingTotalVaccinations, SUM(CV.new_vaccinations) OVER (ORDER BY CD.date)/CD.population*100 as VaccinationPercent
FROM covid_deaths CD
JOIN covid_vaccination CV
ON CD.location = CV.location AND CD.date = CV.date

WHERE CD.continent is not null AND CD.location like '%Canada'
ORDER BY 1,2,3
LIMIT 10000


-- Method 2 with a CTE 

WITH PopulationvsVaccinations (continent, location, date, population, new_vaccinations, total_vaccinations) AS

(

SELECT CD.continent, CD.location, CD.date, CD.population, CV.new_vaccinations, CV.total_vaccinations,
SUM(CV.new_vaccinations) OVER (ORDER BY CD.date) as RollingTotalVaccinations
FROM covid_deaths CD
JOIN covid_vaccination CV
ON CD.location = CV.location AND CD.date = CV.date

WHERE CD.continent is not null AND CD.location like '%Canada'

)

SELECT *, (RollingTotalVaccinations/population)*100 as VaccinationPercent

FROM PopulationvsVaccinations
ORDER BY 1,2,3
LIMIT 10000;


-- Method 3 temp table

-- Drop the table if it exists
DROP TABLE IF EXISTS PercentVaccinated;

-- Create a temporary table
CREATE TEMPORARY TABLE PercentVaccinated (
  continent VARCHAR(100),
  location VARCHAR(100),
  date DATE,
  population INT,
  new_vaccinations INT,
  total_vaccinations INT,
  RollingTotalVaccinations INT,
  VaccinationPercent FLOAT
);

-- Insert data into the temporary table
INSERT INTO PercentVaccinated
SELECT
  CD.continent,
  CD.location,
  CD.date,
  CD.population,
  CV.new_vaccinations,
  CV.total_vaccinations,
  SUM(CV.new_vaccinations) OVER (ORDER BY CD.date) AS RollingTotalVaccinations,
  SUM(CV.new_vaccinations) OVER (ORDER BY CD.date) / CD.population * 100 AS VaccinationPercent
FROM
  covid_deaths CD
JOIN
  covid_vaccination CV ON CD.location = CV.location AND CD.date = CV.date
WHERE
  CD.continent IS NOT NULL AND CD.location LIKE '%Canada'
ORDER BY
  1, 2, 3
LIMIT
  10000;

-- Select all records from the temporary table
SELECT * FROM PercentVaccinated;






---- Creating views to store data for tableau visualisations


CREATE VIEW PercentPopulationVaccinated AS

SELECT CD.continent, CD.location, CD.date, CD.population, CV.new_vaccinations, CV.total_vaccinations,
SUM(CV.new_vaccinations) OVER (ORDER BY CD.date) as RollingTotalVaccinations, SUM(CV.new_vaccinations) OVER (ORDER BY CD.date)/CD.population*100 as VaccinationPercent
FROM covid_deaths CD
JOIN covid_vaccination CV
ON CD.location = CV.location AND CD.date = CV.date

WHERE CD.continent is not null AND CD.location like '%Canada'




SELECT* FROM PercentPopulationVaccinated
lIMIT 10000;



SELECT table_name
FROM information_schema.views
WHERE table_schema = 'public' AND table_name = 'percentpopulationvaccinated';

