select * from  [portfolio project].dbo.coviddeath
where continent is not null
order by 3,4

--select *
--from [portfolio project].dbo.covidvaccination
--order  by 3,4

--select data that we are using

select location,date,total_cases,new_cases,total_deaths,population
from  [portfolio project].dbo.coviddeath
order by 1,2

--looking at total cases vs total death

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathRate_percentage
from  [portfolio project].dbo.coviddeath
order by 1,2

--deathrate_percent in specific location using likelihood

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathRate_percentage
from  [portfolio project].dbo.coviddeath
where location like '%india%'
order by 1,2
 

--looking at total_cases vs population

select location,date,total_cases,population,(total_cases/population)*100 as case_percentage
from  [portfolio project].dbo.coviddeath
order by 1,2

--case_percentage in specific location(india)

select location,date,total_cases,population,(total_cases/population)*100 as case_percentage
from  [portfolio project].dbo.coviddeath
where location like '%india%'
order by 1,2

--looking at highest infected rate by population

select location,population,max(total_cases) as high_infectedcount,max((total_cases/population))*100 as infected_rate
from  [portfolio project].dbo.coviddeath
--where location like '%india%'
group by location , population
order by infected_rate desc

--showing the country with highest death per population

select location,population,max(total_deaths) as high_deathcount,max((total_deaths/population))*100 as death_rate
from  [portfolio project].dbo.coviddeath
--where location like '%india%'
group by location , population
order by death_rate desc

--looking death count per location

select location,max(total_deaths) as high_deathcount
from  [portfolio project].dbo.coviddeath
--where location like '%india%'
where continent is not null
group by location 
order by max(total_deaths) desc

--breaking up by continent

select continent,max(total_deaths) as high_deathcount
from  [portfolio project].dbo.coviddeath
--where location like '%india%'
where continent is not null
group by continent 
order by max(total_deaths) desc

--Gobal count 

select date,sum(total_cases)as Totalcase,sum(total_deaths) as Totaldeath, (sum(total_deaths)/sum(total_cases))*100 as death_rate
from  [portfolio project].dbo.coviddeath
--where location like '%india%'
group by date
order by death_rate 

--overall death percentage

select sum(total_cases)as Totalcase,sum(total_deaths) as Totaldeath, (sum(total_deaths)/sum(total_cases))*100 as death_rate
from  [portfolio project].dbo.coviddeath
--where location like '%india%'
order by death_rate 

--joining two data set

select *
from [portfolio project].dbo.CovidDeath dea
join [portfolio project].dbo.CovidVaccination vac
on dea.location=vac.location 
and dea.date=vac.date
order by 3,4

--looking at population vs vaccination

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
from [portfolio project].dbo.CovidDeath dea
join [portfolio project].dbo.CovidVaccination vac
on dea.location=vac.location 
and dea.date=vac.date
where dea.continent is not null
order by 2,3

--use CTE

WITH PopvsVac (continent,location,date ,population,new_vaccinations) AS (
    -- CTE definition
 select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
from [portfolio project].dbo.CovidDeath dea
join [portfolio project].dbo.CovidVaccination vac
on dea.location=vac.location 
and dea.date=vac.date
where dea.continent is not null
)
-- SQL statement that references the CTE

SELECT *,(new_vaccinations/population)*100 as newvaccine_percentage
FROM PopvsVac;

--temp table

 Drop table if exists #newvaccinetable
 create table #newvaccinetable
 (continent nvarchar(255),
 location nvarchar(255),
 date date,
 population numeric,
 new_vaccinations numeric)

 insert into  #newvaccinetable
  select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
from [portfolio project].dbo.CovidDeath dea
join [portfolio project].dbo.CovidVaccination vac
on dea.location=vac.location 
and dea.date=vac.date
order by 2,3

SELECT *,(new_vaccinations/population)*100 as newvaccine_percentage
FROM #newvaccinetable;

--creating view to store data for later visualization

create view newvaccinetable as 
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
from [portfolio project].dbo.CovidDeath dea
join [portfolio project].dbo.CovidVaccination vac
on dea.location=vac.location 
and dea.date=vac.date
where dea.continent is not null
--order by 2,3