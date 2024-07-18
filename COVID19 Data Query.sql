/* 

DATA EXPLORATIONS & AGGREGATES FOR COVID DEATHS AND VACCINATIONS

Skills used: Joins, CTEs, Temp Tables, Windows Functions, Aggregate Functions, Converting Data Types

*/


--Checks the databases by order of country then date/time
SELECT *
FROM [PortfolioProject(Covid)].dbo.CovidDeaths$
where continent is not null
ORDER BY 3, 4

SELECT *
FROM [PortfolioProject(Covid)].dbo.CovidVax$
ORDER BY 3, 4

-- Selects the data that we are going to be using

SELECT location, date, total_cases, new_cases, total_deaths
FROM CovidDeaths$
Order by 1,2

--Altering columns to appropriate data types

ALTER TABLE [PortfolioProject(Covid)].dbo.CovidDeaths$
ALTER COLUMN total_cases float

ALTER TABLE [PortfolioProject(Covid)].dbo.CovidDeaths$
ALTER COLUMN new_cases float

ALTER TABLE [PortfolioProject(Covid)].dbo.CovidDeaths$
ALTER COLUMN total_deaths float

ALTER TABLE [PortfolioProject(Covid)].dbo.CovidDeaths$
ALTER COLUMN population float

ALTER TABLE [PortfolioProject(Covid)].dbo.CovidDeaths$
ALTER COLUMN new_cases float

ALTER TABLE [PortfolioProject(Covid)].dbo.CovidDeaths$
ALTER COLUMN new_deaths float



-- Gives death rate in relation to total cases

SELECT location, date, total_cases, new_cases, total_deaths, CONVERT(float,(total_deaths/total_cases)*100) as death_rate
FROM CovidDeaths$
Order by 1,2


-- Gives testing rate in relation to population
SELECT dea.location, dea.date, dea.total_cases, vax.new_tests, vax.total_tests, vax.population, 
CONVERT(float,(vax.total_tests/vax.population)*100) as test_rate
FROM CovidDeaths$ as dea
JOIN CovidVax$ as vax
	on dea.location = vax.location AND dea.date = vax.date 
WHERE dea.continent is not null
Order by 1,2 DESC


-- Gives infection rate in proportion to population

SELECT location, date, total_cases, new_cases, total_deaths, population, CONVERT(float,(total_cases/population)*100) as infection_rate
FROM CovidDeaths$
Order by 1,2
-- For specific countries (exact names not needed)
SELECT location, date, total_cases, new_cases, total_deaths, population, CONVERT(float,(total_cases/population)*100) as infection_rate
FROM CovidDeaths$
Where location like '%philippines%'
Order by 1,2



-- Gives the highest number of cases for each country in proportion to population
SELECT location, population, MAX(total_cases) as highest_infection_count, MAX((total_cases/population)*100) as infection_rate
FROM CovidDeaths$
Group by location, population
Order by 4 DESC

-- Gives the highest number of deaths for each country
SELECT location, population, MAX(total_deaths) as highest_death_count, MAX((total_deaths/population)*100) as deaths_per_cap
FROM CovidDeaths$
WHERE continent is not null
Group by location, population
Order by 3 DESC



-- Gives the total cases, total deaths, and death rate in relation to total infected around the world
SELECT date, (sum(total_cases) + sum(total_deaths)) as total_cases, sum(total_deaths) as total_deaths, 
(SUM(total_deaths)/(sum(total_cases) + sum(total_deaths))*100) as death_rate --total cases get deducted when case dies. it is more accurate to include the cases that died to calculate for death rate.
FROM CovidDeaths$
Where continent is not null --selects only countries, not country groups
Group by date
Order by 1


-- Gives the new daily records of cases and deaths around the world
SELECT date, sum(new_cases) as daily_cases,sum(new_deaths) as daily_deaths, 
(sum(total_cases) + sum(total_deaths)) as total_cases, sum(total_deaths) as total_deaths,
(SUM(total_deaths)/(sum(total_cases) + sum(total_deaths))*100) as death_rate
FROM CovidDeaths$
Where continent is not null --selects only countries, not country groups
Group by date
Order by 1


-- Gives the daily vaccinations recorded and the country's rolling sum of vaccinations overtime

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(float,vac.new_vaccinations)) OVER 
	(Partition by dea.location order by dea.location, dea.date) as rolling_vaccinations
From CovidDeaths$ dea
Join CovidVax$ vac
	On dea.location=vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order by 1,2



-- Compresses the column and use to find ratio of vaccinated to population

With VaxOverPop (continent, location, date, population, new_vaccinations, rolling_vaccinations)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(float,vac.new_vaccinations)) OVER 
	(Partition by dea.location order by dea.location, dea.date) as rolling_vaccinations
From CovidDeaths$ dea
Join CovidVax$ vac
	On dea.location=vac.location
	and dea.date = vac.date
Where dea.continent is not null
)
Select *, (rolling_vaccinations/population)*100 as vaccination_rate
From VaxOverPop

-- in Temp Tables

DROP Table if exists #VaxRate
CREATE Table #VaxRate
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Rolling_vaccinations numeric
)

Insert into #VaxRate
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(float,vac.new_vaccinations)) OVER 
	(Partition by dea.location order by dea.location, dea.date) as rolling_vaccinations
From CovidDeaths$ dea
Join CovidVax$ vac
	On dea.location=vac.location
	and dea.date = vac.date
Where dea.continent is not null

SELECT *, (Rolling_vaccinations/Population) as Vaccination_rate
FROM #VaxRate
Order by Vaccination_rate DESC


-- Gives the highest vaccination rates recorded in each country with their occurring time periods recorded

With #HighestVaxRates as
(
SELECT location, MAX(Rolling_vaccinations) as Highest_vaccinations, 
MAX((Rolling_vaccinations/Population)*100) as Highest_vax_rate
FROM #VaxRate
Group by location
)
SELECT high.Location, MAX(high.Highest_vaccinations) as Highest_vaccinations, MAX(high.Highest_vax_rate) as Highest_vax_rate, 
MIN(rate.Date) as Earliest_date, MAX(rate.Date) as Last_date
FROM #HighestVaxRates as high
JOIN #VaxRate as rate
	on high.Highest_vaccinations = rate.Rolling_vaccinations
	AND high.Location = rate.location
GROUP BY high.Location
ORDER BY high.location 
---Vax rates occurring more than 100% means there is an occurrance of booster vaccinations
---Min_date where the highest rate is earliest recorded, Max_date where the latest recorded
