--Global total numbers

SELECT  sum(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, (sum(cast(new_deaths as int))/SUM(new_cases)) as DeathPer
FROM [Portifolio].[dbo].[CovidDeaths]
Where continent is not null
---Group by date
Order by 1,2 

--Global total daily numbers 

SELECT date , sum(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, (sum(cast(new_deaths as int))/SUM(new_cases)) as DeathPer
FROM [Portifolio].[dbo].[CovidDeaths]
Where continent is not null
Group by date
Order by 1,2 

--JOINING TABLES
Select*
FROM [Portifolio].[dbo].[CovidDeaths] dea
Join [Portifolio].[dbo].[CovidVaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date

--TOTAL POPULATION VS VACCINATIONS
Select DEA.continent, DEA.location, dea.date, dea.population, vac.new_vaccinations
FROM [Portifolio].[dbo].[CovidDeaths] dea
Join [Portifolio].[dbo].[CovidVaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE DEA.continent IS NOT NULL
ORDER BY 2,3

--TOTAL POPULATION VS VACCINATIONS
Select DEA.continent, DEA.location, dea.date, dea.population, vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) AS  RollingPeople
FROM [Portifolio].[dbo].[CovidDeaths] dea
Join [Portifolio].[dbo].[CovidVaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE DEA.continent IS NOT NULL
ORDER BY 2,3


--use a cte

With Popvacs (Continent,Location,Date,Population,New_Vaccination,RollingPeople)
as
(
Select DEA.continent, DEA.location, dea.date, dea.population, vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) AS  RollingPeople
FROM [Portifolio].[dbo].[CovidDeaths] dea
Join [Portifolio].[dbo].[CovidVaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE DEA.continent IS NOT NULL
--ORDER BY 2,3
)

Select*
From Popvacs


Select* ,(RollingPeople/Population)*100
From Popvacs

--use a cte

With Popvacs (Continent,Location,Date,Population,New_Vaccination,RollingPeople)
as
(
Select DEA.continent, DEA.location, dea.date, dea.population, vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) AS  RollingPeople
FROM [Portifolio].[dbo].[CovidDeaths] dea
Join [Portifolio].[dbo].[CovidVaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE DEA.continent IS NOT NULL
--ORDER BY 2,3
)

 

--use a temp table 

Create Table #percpopulva
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeople numeric
)

Insert into #percpopulva
Select DEA.continent, DEA.location, dea.date, dea.population, vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) AS  RollingPeople
FROM [Portifolio].[dbo].[CovidDeaths] dea
Join [Portifolio].[dbo].[CovidVaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE DEA.continent IS NOT NULL
--ORDER BY 2,3 

Select* ,(RollingPeople/population)*100
From #percpopulva











