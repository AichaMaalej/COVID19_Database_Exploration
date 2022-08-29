/*
Queries used for Tableau Project
*/



-- 1. 

Select SUM(cast(new_cases as real)) as Total_cases, SUM(cast(new_deaths as real)) as total_deaths, SUM(cast(new_deaths as real))/SUM(cast(new_cases as real))*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location = 'Tunisia'
where continent is not null 
--Group By date
order by 1,2


-- 2. 

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as real)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc



-- 3.

Select Location, Population, MAX(cast(total_cases as real)) as HighestInfectionCount,  Max((cast(total_cases as real)/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc




-- 4.


Select Location, Population,date, MAX(cast(total_cases as real)) as HighestInfectionCount,  Max((cast(total_cases as real)/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc