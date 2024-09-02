## Exploratory Data Analysis - World Layoffs


select *
from layoff_staging2;

select max(total_laid_off), max(percentage_laid_off)
from layoff_staging2;

select *
from layoff_staging2
where percentage_laid_off = 1
order by fund_raised_millions desc;

## We want to look at the companies that have laid of the most employees
select company, sum(total_laid_off)
from layoff_staging2
group by company
order by 2 desc;

## we want to look at the date ranges
select min(`date`), max(`date`)
from layoff_staging2;


## Next we want to see what indsutry got affected the most
select industry, sum(total_laid_off)
from layoff_staging2
group by industry
order by 2 desc;


## Next we want to see the country with the most amount of layoffs

select country, sum(total_laid_off)
from layoff_staging2
group by country
order by 2 desc;

##Next we want to see the year in which the most amount of layoffs took place

select year(`date`), sum(total_laid_off)
from layoff_staging2
group by 1
order by 2 desc;

## Next we want to see the stage of companies that had the most layoffs

select stage, sum(total_laid_off)
from layoff_staging2
group by 1
order by 2 desc;

## Next we want to do the rolling total of layoffs based on the month

with Rolling_Total as 
(
Select substring(`date`,1,7) as `month`, sum(total_laid_off) as total_off
from layoff_staging2
where substring(`date`,1,7) is not null
group by 1
order by 1 asc
)
select `month`, total_off,
sum(total_off) over(order by `month`) as rolling_total
from Rolling_Total;

## We First created a CTE to work out what the rolling total is by month, then we selected the month, total_laid_off and the rolling_total_laid_off
## Month by month from 2020 to 2023. 

## Next we want to take a look at each company layoffs per year, we want to see the total amount of employees laid off by each company per year
## Then we rank them, to see which company laid off the most
select company, year (`date`), sum(total_laid_off),
dense_rank() over(partition by year (`date`) order by sum(total_laid_off) desc) as ranking
from layoff_staging2
group by 1,2
having sum(total_laid_off) is not null
order by 2 asc;

## Next let's look at the top 5 companies with the most layoffs for each year.
with cte as (
select company, year (`date`), sum(total_laid_off),
dense_rank() over(partition by year (`date`) order by sum(total_laid_off) desc) as ranking
from layoff_staging2
group by 1,2
having sum(total_laid_off) is not null
order by 2 asc
)
select *
from cte
where ranking <=5;

##End - There's a lot more that can be explored from this dataset, depending on the information and insights we want to gain. 


