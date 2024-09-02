# World Life Expectancy Project -  Exploratory Data Analysis

select *from	
world_life_expectancy;

#First Let's see what the Minimum and Maximum Life Expenctancy is for each country. 
select country,  min(`Life Expectancy`), max(`Life Expectancy`)
from	
world_life_expectancy
group by country
order by country desc;

#There were some countries where there was no values inputted in the min(`Life Expectancy`), and max(`Life Expectancy`)
# This is probably due to poor data quality, or perhaps the countries don't have or collect data for this, 
# These values will need to be excluded
# To do this I use the syntax below 

select country,  min(`Life Expectancy`), max(`Life Expectancy`)
from	
world_life_expectancy
group by country
having min(`Life Expectancy`) <> 0 
and max(`Life Expectancy`) <>0
order by country desc;

## Next I want to see the cpuntries that have made the biggest jump between the Minimum and Maximum Life Expectancy
## To find this, we calculate the maximum - minimum

select country,  min(`Life Expectancy`), max(`Life Expectancy`), 
round(max(`Life Expectancy`) - min(`Life Expectancy`),2) as life_increase
from	
world_life_expectancy
group by country
having min(`Life Expectancy`) <> 0 
and max(`Life Expectancy`) <>0
order by life_increase desc;

### Next I want to work out the average life expectancy by year

select year, round(avg(`Life Expectancy`),2) as avg_life_expectancy
from
world_life_expectancy
where `Life Expectancy`<> 0
and `Life Expectancy`<> 0
group by year
order by Year;

#life expectancy has grown by about 7 years world wide

select *from	
world_life_expectancy;

#next I want to see some correlations, i.e is there a correlation between G.D.P and life expectancy. 

select Country, 
round(avg(`Life Expectancy`),1) as Life_Exp, 
round(avg(GDP),1) as GDP
from world_life_expectancy
group by country
order by Life_Exp asc;

# I can see that some countries don't have a life expectancy value given, these aere quite small countries so maybe they don't collect these data
#so I decided to filter these out using the syntax below. 

select Country, 
round(avg(`Life Expectancy`),1) as Life_Exp, 
round(avg(GDP),1) as GDP
from world_life_expectancy
group by country
having Life_Exp <> 0
and  GDP >0
order by GDP asc;


## I can see that countires with lower GDPs have lower life expectancy and vice versa - POSITIVE CORRELATION 

#Now we want to comapre GDPs and Life Exp between richer and poorer countries
select
sum(case when GDP >= 1500 THEN 1 ELSE 0 end) High_GDP_COUNT,
avg(case when GDP >= 1500 THEN `Life Expectancy` ELSE null end) High_GDP_Life_Exp,
sum(case when GDP <= 1500 THEN 1 ELSE 0 end) low_GDP_COUNT,
avg(case when GDP <= 1500 THEN `Life Expectancy` ELSE null end) Low_GDP_Life_Exp
from
world_life_expectancy;

#Next I want to Compare countries Statuses verses the average life expectancy

select status, round(avg(`Life Expectancy`),1)
from
world_life_expectancy
group by status
having status <> '';

# next we want to see the count of countries statues 
select status, round(avg(`Life Expectancy`),1), count(distinct country)
from
world_life_expectancy
group by status
having status <> '';

## Next I am going to compare BMI and how this correlates with life expectancy

select Country, round(avg(`Life Expectancy`),1) as Life_Exp, round(avg(BMI),1) as BMI
from world_life_expectancy
group by country
having Life_Exp > 0
and  BMI > 0
order by BMI desc;

## Next I want to see a rolling total 
select country, year, `Life Expectancy`, `Adult Mortality`,
sum(`Adult Mortality`) over(partition by country order by year) as rolling_total
from	
world_life_expectancy;
