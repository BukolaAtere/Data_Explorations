## US household income Exploratory Data Analysis

##First Let's take a look at the state with the largest land area. 

select state_name, sum(ALand), sum(AWater)
from us_project.us_household_income
group by state_name
order by 2 desc;    
####I can also look at the states with the most water by ordering by 3 instead of 2


# Next I want to identify the top 10 largest state by land. 
select state_name, sum(ALand), sum(AWater)
from us_project.us_household_income
group by state_name
order by 2 desc
limit 10;

##Next I want to tie the two tables together 

select *
from us_project.us_household_income as u
join us_project.us_household_income_statistics as us
on u.id = us.id;

## When I had initially uploaded the datasets into MySQL not all the data from us_household_income inserted into the table. 
## So there will be some blank rows as a result of this. ## To identify this I add a right join to the syntax

select *
from us_project.us_household_income as u
right join us_project.us_household_income_statistics as us
on u.id = us.id
where u.id is null;

## Next I want to look at the statistics on the us_household_income_statistics table

select u.State_Name, county, type, `primary`, mean, median
from us_project.us_household_income as u
inner join us_project.us_household_income_statistics as us
on u.id = us.id
;

## Next I want to find out what the average income is per state 

select u.State_Name, round(avg(mean),1) as avg_mean_income, round(avg(median),1) as avg_median_income
from us_project.us_household_income as u
inner join us_project.us_household_income_statistics as us
on u.id = us.id
group by u.State_Name;

## Next Let's order this from highest to lowest aeverage income by state

select u.State_Name, round(avg(mean),1) as avg_mean_income, round(avg(median),1) as avg_median_income
from us_project.us_household_income as u
inner join us_project.us_household_income_statistics as us
on u.id = us.id
group by u.State_Name
order by 2 desc; 

### To find the top 10 highest income
select u.State_Name, round(avg(mean),1) as avg_mean_income, round(avg(median),1) as avg_median_income
from us_project.us_household_income as u
inner join us_project.us_household_income_statistics as us
on u.id = us.id
group by u.State_Name
order by 2 desc ### Order by 2 asc to find the top 10 lowest income
limit 10; 

## Next I want to see if the 'type' of area someone lives in affects their income capabalities
select type, count(type), round(avg(mean),1) as avg_mean_income, round(avg(median),1) as avg_median_income
from us_project.us_household_income as u
inner join us_project.us_household_income_statistics as us
on u.id = us.id
group by 1
order by 3 desc;

## When i ran the syntax above we found that there are 'type' such as municipality and county which have only been recorded a handful ot times
## these are outliers so I am going to filter these out as they do not represent the vast majority of areas the general population lives in.

select type, count(type), round(avg(mean),1) as avg_mean_income, round(avg(median),1) as avg_median_income
from us_project.us_household_income as u
inner join us_project.us_household_income_statistics as us
on u.id = us.id
group by 1
having count(type) > 100
order by 3 desc
;

## Next I want to compare the average income at the city level

select u.State_Name, city, round(avg(mean),1) as avg_mean_income, round(avg(median),1) as avg_median_income
from us_project.us_household_income as u
inner join us_project.us_household_income_statistics as us
on u.id = us.id
group by u.State_Name, city
order by 3 desc
limit 10; ## TO find out the top 10 cities with the hightest avg income. 

##END

