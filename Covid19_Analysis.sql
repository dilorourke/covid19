-- Creating the database in MySQL
CREATE DATABASE covid19_data;

USE covid19_data;

-- Creating a table for the covid deaths csv
CREATE TABLE covid_deaths (
    iso_code CHAR(3), continent TINYTEXT, 
    location TEXT, date_ DATE, population INT, total_cases INT, 
    new_cases INT, new_cases_smoothed FLOAT(3), total_deaths INT, 
    new_deaths INT, new_deaths_smoothed FLOAT(3), total_cases_per_million FLOAT(3), 
    new_cases_per_million FLOAT(3), new_cases_smoothed_per_million FLOAT(3), 
    total_deaths_per_million FLOAT(3), new_deaths_per_million FLOAT(3), 
    new_deaths_smoothed_per_million FLOAT(3), reproduction_rate FLOAT(3), 
    icu_patients INT, icu_patients_per_million FLOAT(3), hosp_patients INT, 
    hosp_patients_per_million FLOAT(3), weekly_icu_admissions INT, 
    weekly_icu_admissions_per_million FLOAT(3), weekly_hosp_admissions INT, 
    weekly_hosp_admissions_per_million FLOAT(3)
    );

CREATE TABLE covid_vaccinations (
    iso_code CHAR(3), continent TINYTEXT, location TEXT, date_ DATE, 
    new_tests INT, total_tests INT, 
    total_tests_per_thousand FLOAT(3), 
    new_tests_per_thousand FLOAT(3), 
    new_tests_smoothed INT, 
    new_tests_smoothed_per_thousand FLOAT(3), 
    positive_rate FLOAT(3), tests_per_case FLOAT(3), 
    tests_units TEXT, total_vaccinations INT, 
    people_vaccinated INT, people_fully_vaccinated INT, 
    total_boosters INT, new_vaccinations INT, 
    new_vaccinations_smoothed INT, 
    total_vaccinations_per_hundred FLOAT(3), 
    people_vaccinated_per_hundred FLOAT(3), 
    people_fully_vaccinated_per_hundred FLOAT(3), 
    total_boosters_per_hundred FLOAT(3), 
    new_vaccinations_smoothed_per_million INT, 
    new_people_vaccinated_smoothed INT, 
    new_people_vaccinated_smoothed_per_hundred FLOAT(3), 
    stringency_index FLOAT(3), population_density FLOAT(3), 
    median_age INT, aged_65_older FLOAT(3), aged_70_older FLOAT(3), 
    gdp_per_capita FLOAT(3), extreme_poverty FLOAT(3), 
    cardiovasc_death_rate FLOAT(3), diabetes_prevalence FLOAT(3), 
    female_smokers FLOAT(3), male_smokers FLOAT(3), 
    handwashing_facilities FLOAT(3), 
    hospital_beds_per_thousand FLOAT(3), 
    life_expectancy FLOAT(3), human_development_index FLOAT(3), 
    excess_mortality_cumulative_absolute FLOAT(3), 
    excess_mortality_cumulative FLOAT(3), 
    excess_mortality FLOAT(3), 
    excess_mortality_cumulative_per_million FLOAT(3)
    );
    

-- Loading data from my CSVs in the repository into my MySQL DB
LOAD DATA LOCAL INFILE 'C:/Users/Dillon/Documents/Coding Learning/Projects/covid19/CovidDeaths.csv'
INTO TABLE covid_deaths
COLUMNS TERMINATED BY ','
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/Users/Dillon/Documents/Coding Learning/Projects/covid19/CovidVaccinations.csv'
INTO TABLE covid_vaccinations
COLUMNS TERMINATED BY ','
IGNORE 1 LINES;

-- Checking the table has populated
SELECT *
FROM covid19_data.covid_deaths
LIMIT 100;
-- Checking the table has populated
SELECT *
FROM covid19_data.covid_vaccinations
LIMIT 100;

-- Total Cases vs Total Deaths
-- Shows death rate (Likelihood of death after contraction)
SELECT location, date_, total_cases, total_deaths, (total_deaths/total_cases)*100 AS prop_death
FROM covid19_data.covid_deaths
WHERE  date_ = '2022-02-26'
order by 5 DESC;

-- Finding countries with highest death counts
-- Needed to add the where clause due to data in table for continents and the world. Clause excludes the data to show only countries
-- Change the <> to = to filter by continents & the world instead of countries
SELECT location, MAX(total_deaths) as totaldeathcount
FROM covid19_data.covid_deaths
WHERE continent <> ""
GROUP BY location
ORDER BY totaldeathcount DESC;

-- Running a check on the "World" count, comparing the datas value vs my calculated value

-- Pulling the value from the data
SELECT location, MAX(total_deaths) as totaldeathcount
FROM covid19_data.covid_deaths
WHERE location = "world"
GROUP BY location
ORDER BY totaldeathcount DESC;

-- Calculating it myself
SELECT SUM(totals) 
FROM
    (SELECT MAX(total_deaths) AS totals
    FROM covid_deaths
    WHERE continent <> ""
    GROUP BY location)
AS totalworlddeaths;

-- Joining the vaccinations and deaths table
-- This will inner join all columns (join where both tables match in the equations below) both tables
SELECT *
FROM covid19_data.covid_deaths dea
JOIN covid19_data.covid_vaccinations vac
    ON dea.location = vac.location
    AND dea.date_ = vac.date_
    ;

-- Pulling columnns of interest from the joined table
-- Filtering for Irish data
-- Pulling columnns of interest from the joined table
-- Filtering for Irish data
SELECT dea.location, dea.date_, total_vaccinations, people_vaccinated, people_fully_vaccinated, total_deaths, new_deaths
FROM covid19_data.covid_deaths dea
JOIN covid19_data.covid_vaccinations vac
    ON dea.location = vac.location
    AND dea.date_ = vac.date_
WHERE dea.location = "Ireland" AND (dea.date_ < '2020-12-28' OR (dea.date_ >= 2020-12-28 AND people_fully_vaccinated <>0 ))
;


-- Looking at the effect of vac on death rate in Ireland
SELECT dea.location, population, dea.date_, (people_fully_vaccinated/population)*100 AS PercentageVac, (total_deaths/total_cases)*100 AS PercDeath
FROM covid19_data.covid_deaths dea
JOIN covid19_data.covid_vaccinations vac
    ON dea.location = vac.location
    AND dea.date_ = vac.date_
WHERE dea.location = "Ireland" AND (dea.date_ < '2020-12-28' OR (dea.date_ >= 2020-12-28 AND people_fully_vaccinated <>0 ))
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/%vaccs_vs_%deaths_ireland.csv' 
    FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n'
;

-- Calculating the Cumulative Sum of Vaccinations as days go by
SELECT dea.date_, dea.location, population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (partition by location ORDER BY location, dea.date_) AS cumsum_vac
FROM covid19_data.covid_deaths dea
JOIN covid19_data.covid_vaccinations vac
    ON dea.location = vac.location
    AND dea.date_ = vac.date_
#WHERE dea.location = "Ireland" 
;

USE covid19_data;
-- Calculating the Cumulative Sum of Vaccinations as days go by
-- Common Table Expression
WITH pop_vs_vac (Date, Continent, Location, Population, NewVaccs, CumSumVac)
as
(
-- Calculating the Cumulative Sum of Vaccinations as days go by
SELECT dea.date_, dea.continent, dea.location, population, new_people_vaccinated_smoothed,
SUM(new_people_vaccinated_smoothed) OVER (partition by location ORDER BY location, dea.date_) AS cumsum_vac
FROM covid19_data.covid_deaths dea
JOIN covid19_data.covid_vaccinations vac
    ON dea.location = vac.location
    AND dea.date_ = vac.date_
WHERE dea.continent IS NOT NULL
)
-- Calculating the cumulative % pop vaccinated
SELECT * , (CumSumVac/Population)*100 AS cum_perc_vac
FROM pop_vs_vac;

-- Using a Temp table
DROP TABLE  IF EXISTS PercentPopulationVaccinated;
CREATE TEMPORARY TABLE PercentPopulationVaccinated
(
Date_ date,
Continent nvarchar(255), 
Location nvarchar(255),
Population numeric,
New_Vaccinations numeric,
CumSumVac numeric
);
INSERT INTO PercentPopulationVaccinated
-- Calculating the Cumulative Sum of Vaccinations as days go by
(SELECT dea.date_, dea.continent, dea.location, population, new_people_vaccinated_smoothed,
SUM(new_people_vaccinated_smoothed) OVER (partition by location ORDER BY location, dea.date_) AS cumsum_vac
FROM covid19_data.covid_deaths dea
JOIN covid19_data.covid_vaccinations vac
    ON dea.location = vac.location
    AND dea.date_ = vac.date_
WHERE dea.continent IS NOT NULL
);
-- Calculating the cumulative % pop vaccinated
SELECT * , (CumSumVac/Population)*100 AS cum_perc_vac
FROM PercentPopulationVaccinated
;

-- Creating a VIEW
DROP VIEW IF EXISTS cum_vaccinated;
CREATE VIEW cum_vaccinated AS
-- Calculating the Cumulative Sum of Vaccinations as days go by
SELECT dea.date_, dea.continent, dea.location, population, new_people_vaccinated_smoothed,
SUM(new_people_vaccinated_smoothed) OVER (partition by location ORDER BY location, dea.date_) AS cumsum_vac
FROM covid19_data.covid_deaths dea
JOIN covid19_data.covid_vaccinations vac
    ON dea.location = vac.location
    AND dea.date_ = vac.date_
WHERE dea.location = "Ireland"
;


DROP VIEW IF EXISTS Highest_Deaths;

CREATE VIEW Highest_Deaths AS

WITH max_death (Country, Date_, CaseCount, DeathCount, DeathRate)
AS
(
-- Shows death rate (Likelihood of death after contraction)
SELECT location, date_, total_cases, total_deaths, (total_deaths/total_cases)*100 AS prop_death
FROM covid19_data.covid_deaths
WHERE total_deaths > 10 AND continent <> ""
order by 5 DESC
)
SELECT Country, MAX(DeathRate) AS MaxDeathRate
FROM max_death
GROUP BY Country
ORDER BY 2 DESC
;