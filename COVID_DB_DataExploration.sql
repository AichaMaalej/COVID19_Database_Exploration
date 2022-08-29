select * 
from PortfolioProject..CovidDeaths
order by 3,4

--select * 
--from PortfolioProject..CovidVaccination
--order by 3,4

-- Selecting the Data that we're going to be using

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2



-- Looking at the total cases VS Total Deaths -- Likelihood of dying if you contract covid in each country

select location, date, total_cases, total_deaths, (cast(total_deaths as real)/cast(total_cases as real))*100 as DeathPercentage
from PortfolioProject..CovidDeaths
--where location like '%states%'
order by 1,2


-- Looking at the total cases VS population -- Percentage of population that got infected with covid

select location, date, total_cases, population, (cast(total_cases as real)/cast(population as real))*100 as InfectionPercentage
from PortfolioProject..CovidDeaths
--where location like '%states%'
--where location= 'Tunisia'
order by 1,2

--Looking at countries with the highest infection rate compared to population
select location, population, MAX(total_cases) as HighestInfectionCount, Max((cast(total_cases as real)/cast(population as real)))*100 as InfectionPercentage_pop
from PortfolioProject..CovidDeaths
group by location, population
order by InfectionPercentage_pop desc

-- Looking at the countries with the Highest death count per population

select location, population, MAX(total_deaths) as HighestDeathCount, Max((cast(total_deaths as real)/cast(population as real)))*100 as DeathPercentage_pop
from PortfolioProject..CovidDeaths
group by location, population
order by DeathPercentage_pop desc


-- Looking at the countries with the Highest death by continent

select continent, Max(cast(total_deaths as real)) as TotalDeathByContinent
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by TotalDeathByContinent desc


-- Looking at the global numbers
--ordered by date
select date, SUM(cast(new_cases as real)) as TotalCases, SUM(cast(new_deaths as real)) as TotalDeaths, SUM(cast(new_deaths as real))/SUM(cast(new_cases as real)) as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
group by date
order by 1,2

-- Percentage of total Death 
select SUM(cast(new_cases as real)) as TotalCases, SUM(cast(new_deaths as real)) as TotalDeaths, SUM(cast(new_deaths as real))/SUM(cast(new_cases as real)) as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
--group by date
order by 1,2

-- exploring the vaccination table

select * 
from PortfolioProject..CovidVaccination

--joining both tables

select *
from PortfolioProject..CovidDeaths death
join PortfolioProject..CovidVaccination vaccination
	On death.location = vaccination.location
	And death.date = vaccination.date


--Looking at the total vaccination VS population

select death.continent, death.location, death.date, death.population, vaccination.new_vaccinations
from PortfolioProject..CovidDeaths death
join PortfolioProject..CovidVaccination vaccination
	On death.location = vaccination.location
	And death.date = vaccination.date
where death.continent is not null
order by 2,3

--Looking at the total vaccination VS population

select death.continent, death.location, death.date, death.population, vaccination.new_vaccinations,
 SUM(CONVERT(real,vaccination.new_vaccinations)) OVER (Partition by death.location Order by death.location, death.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths death
join PortfolioProject..CovidVaccination vaccination
	On death.location = vaccination.location
	And death.date = vaccination.date
where death.continent is not null
order by 2,3

--Using the RollingPeopleVaccinated column as CTE or temporary tab

With PopVsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
select death.continent, death.location, death.date, death.population, vaccination.new_vaccinations,
 SUM(CONVERT(real,vaccination.new_vaccinations)) OVER (Partition by death.location Order by death.location, death.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths death
join PortfolioProject..CovidVaccination vaccination
	On death.location = vaccination.location
	And death.date = vaccination.date
where death.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/population)*100
from PopVsVac




--Temp table

DROP table if exists #PercentPopulationVaccinated 

Create Table #PercentPopulationVaccinated
(Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
select death.continent, death.location, death.date, death.population, vaccination.new_vaccinations,
 SUM(CONVERT(real,vaccination.new_vaccinations)) OVER (Partition by death.location Order by death.location, death.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths death
join PortfolioProject..CovidVaccination vaccination
	On death.location = vaccination.location
	And death.date = vaccination.date
where death.continent is not null
	--AND death.location='Tunisia'
--order by 2,3

Select *, (RollingPeopleVaccinated/population)*100 AS Percentage_ofTotVaccinated_People
from #PercentPopulationVaccinated






-- Creating a View to store data dor later visualisations

Create View PercentPopulationVaccinated as 
select death.continent, death.location, death.date, death.population, vaccination.new_vaccinations,
 SUM(CONVERT(real,vaccination.new_vaccinations)) OVER (Partition by death.location Order by death.location, death.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths death
join PortfolioProject..CovidVaccination vaccination
	On death.location = vaccination.location
	And death.date = vaccination.date
where death.continent is not null
	--AND death.location='Tunisia'
--order by 2,3


----
Select * from PercentPopulationVaccinated
----




