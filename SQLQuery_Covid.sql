Select *
From PortfolioProject..CovidDeaths$
where continent is not null
order by 3, 4

--Select the data to be used in analysis

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths$
where continent is not null
order by 1,2


-- Total Cases vs. Total Deaths
-- Mortality Percentage
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
where continent is not null
Where location like '%Canada%'
order by 1,2

-- Total Cases vs. Population
Select Location, date, total_cases, Population, (total_cases/Population)*100 as IncidencePercentage
From PortfolioProject..CovidDeaths$
where continent is not null
Where location like '%Canada%'
order by 1,2

-- Nations w/ highest infection rate compared to population
Select Location, Population, MAX(total_cases) as MaxInfectionCount, (MAX(total_cases)/Population)*100 as Max_IncidencePercentage
From PortfolioProject..CovidDeaths$
where continent is not null
Group by Location, Population
order by Max_IncidencePercentage desc 


-- Nations w/ highest death count 
Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount 
From PortfolioProject..CovidDeaths$
where continent is not null
Group by Location
order by TotalDeathCount  desc 


-- By Continent
--Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount 
--From PortfolioProject..CovidDeaths$
--where continent is not null
--Group by continent
--order by TotalDeathCount  desc 

-- Visualizations 
Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount 
From PortfolioProject..CovidDeaths$
where continent is null
Group by location
order by TotalDeathCount  desc 

-- Showing continents with the highest death count by population
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount 
From PortfolioProject..CovidDeaths$
where continent is not null
Group by continent 
order by TotalDeathCount  desc 

-- Globally 
Select date, SUM(new_cases) as totalnewcases, SUM(cast(new_deaths as int)) as totalnewdeaths, SUM(cast(new_deaths as int))/SUM(new_cases) * 100 as newDeathPercentage
From PortfolioProject..CovidDeaths$
where continent is not null
Group by date
order by 1,2


-- Total population vs. Vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingVaccinations
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- using common table expression

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingVaccinations)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingVaccinations
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)
Select *, (RollingVaccinations/Population) * 100
From PopvsVac

-- Using temporary table
DROP Table if exists #PercentPopVaccinated
Create Table #PercentPopVaccinated
(Continent nvarchar(255), 
Location nvarchar(255), 
Date datetime, 
Population numeric, 
New_Vaccinations numeric, 
RollingVaccinations numeric)

Insert into #PercentPopVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingVaccinations
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

Select *, (RollingVaccinations/Population) * 100
From #PercentPopVaccinated

-- Create view to store for visualization

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingVaccinations
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

Select * 
From PercentPopulationVaccinated
