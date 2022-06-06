select * from portfolio.coviddeaths;

select date,location,total_cases,total_deaths, (total_deaths/total_cases)*100 as 'death%' from portfolio.coviddeaths order by date;

select location, max(total_cases) from portfolio.coviddeaths  having max(total_cases);

select location, max(total_cases), max((total_deaths/total_cases))*100 from portfolio.coviddeaths  having max((total_deaths/total_cases))*100;
insert into portfolio.coviddeaths(total_deaths) select 0 where 


select location, max(cast(total_deaths as int)) int from portfolio.coviddeaths group by location order by max(cast(total_deaths as int)) desc;

select distinct(continent) from portfolio.coviddeaths;

select continent, max(total_deaths) from portfolio.coviddeaths group by continent having max(total_deaths);

select continent, sum(total_deaths) from portfolio.coviddeaths group by continent;

ALTER TABLE portfolio.coviddeaths   
MODIFY COLUMN total_deaths int; 
select count(*) from portfolio.covidvaccine;
select * from portfolio.covidvaccine;

select * from portfolio.coviddeaths d join portfolio.covidvaccine v on d.location=v.location and d.date=v.date order by d.location, d.date;



use  portfolio;
with popvac (continent, loc,date,population,total_vac,sum_of_vac)
as
(select v.continent ,v.location, v.date, v.population, v.total_vaccinations, sum(v.total_vaccinations)  over (partition by v.location order by v.date, v.location)  as 'rolling_sum' from portfolio.coviddeaths d join portfolio.covidvaccine v on d.location=v.location and d.date=v.date order by d.location, d.date)
select * ,(rolling_sum/population)*100 from popvac;


drop table if exists  portfolio.percent_vac_population;
create table portfolio.percent_vac_population ( continent varchar(255), location varchar(255), date text, population numeric, total_vaccination text, sum_of_vac_by_loc numeric); 
insert into percent_vac_population
select v.continent ,v.location, v.date, v.population, v.total_vaccinations, sum(v.total_vaccinations)  over (partition by v.location order by v.date, v.location)  as 'rolling_sum' from portfolio.coviddeaths d join portfolio.covidvaccine v on d.location=v.location and d.date=v.date order by d.location, d.date;

select *, (rolling_sum/population)*100 from percent_vac_population;


select * from covidvaccine





