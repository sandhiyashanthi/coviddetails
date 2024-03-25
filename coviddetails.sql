--to find entire columns in two tables

select * from dbo.covid_19_death order by 3,4 desc
 

select * from dbo.covid_19_vaccination order by 3,4

---to find total cases and total deaths

select location,date,total_cases,new_cases,total_deaths from dbo.covid_19_death order by 1,2


-- to find deathpercentage in particular location

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathpercentage from dbo.covid_19_death
where location like '%nia'order by 1,2


--shows what percentage of population got covid

select location,date,total_cases,population,(total_cases/population)*100 as deathpercentage from dbo.covid_19_vaccination
where location like '%nia'order by 1,2

-- to find  highest infection rate compared to population 


select location,max(total_cases) as highestinfectedplace,population,max((total_cases/population))*100 as percentpopulationinfected 
from dbo.covid_19_vaccination group by location,population
order by 2 desc

-- showing highest death count

select location,max(total_deaths) as totaldeathcount from dbo.covid_19_death group by location
order by totaldeathcount desc



select continent,location,max(total_deaths) as totaldeathcount from dbo.covid_19_death 
where continent is not null
group by location,continent
order by totaldeathcount desc



--showing continents with the highest death count per population

select continent,location,max(total_deaths) as totaldeathcount from dbo.covid_19_death 
where continent is not null
group by location,continent
order by totaldeathcount desc

-- global wise case and death total

select date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathpercentage from dbo.covid_19_death
group by date

select date,sum(new_cases) from dbo.covid_19_death
group by date

-- to find new cases and new deaths

select date,sum(new_cases),sum(new_deaths),(sum(new_deaths)/sum(new_cases))*100 as deathpercentage from dbo.covid_19_death
group by date

-- to compare two tables
select * from dbo.covid_19_vaccination as vacc join dbo.covid_19_death as de on vacc.location = de.location and
vacc.date=de.date
-- to find total vaccinated people
select de.continent,de.location,de.date,vacc.population,vacc.new_vaccinations,sum(vacc.new_vaccinations)
over (partition by de.location order by de.location,de.date ) as peoplevaccinated
from dbo.covid_19_vaccination as vacc join dbo.covid_19_death as de
on vacc.location = de.location and
vacc.date=de.date
where de.continent is not null 
order by 2,3
 -- to create tempoprary table
create table #percentpopulationvaccinatioated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rolingpeoplevaccinated numeric
)
insert into 
select de.continent,de.location,de.date,vacc.population,vacc.new_vaccinations,sum(vacc.new_vaccinations)
over (partition by de.location order by de.location,de.date ) as rollingpeoplevaccinated
--((rollingpeoplevaccinated/vacc.population)*100)
from dbo.covid_19_vaccination as vacc join dbo.covid_19_death as de
on vacc.location = de.location and
vacc.date=de.date
where de.continent is not null 
)

