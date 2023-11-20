-- look at the datasets
select * from dbo.Year2018
select * from dbo.Year2019
select * from dbo.Year2020

-- is revenue growing by year 
-- add weekday and weeknight stays, multiply by daily rate
-- all have same structure 
-- aggregate 

with agg_hotel as (
select * from dbo.Year2018
union
select * from dbo.Year2019
union
select * from dbo.Year2020)

select 
(stays_in_week_nights + stays_in_weekend_nights)*adr as hotel_revenue, arrival_date_year from agg_hotel


-- sum by year

with agg_hotel as (
select * from dbo.Year2018
union
select * from dbo.Year2019
union
select * from dbo.Year2020)

select 
sum((stays_in_week_nights + stays_in_weekend_nights)*adr) as hotel_revenue, arrival_date_year 
from agg_hotel
group by arrival_date_year


-- break down by hotel type

with agg_hotel as (
select * from dbo.Year2018
union
select * from dbo.Year2019
union
select * from dbo.Year2020)

select 
round(sum((stays_in_week_nights + stays_in_weekend_nights)*adr), 2) as hotel_revenue, arrival_date_year, hotel as hotel_type
from agg_hotel
group by arrival_date_year, hotel


-- market segment discounts 

select * from dbo.segment_of_market


with agg_hotel as (
select * from dbo.Year2018
union
select * from dbo.Year2019
union
select * from dbo.Year2020)

select * from agg_hotel
left join dbo.segment_of_market
on agg_hotel.market_segment = segment_of_market.market_segment
left join dbo.Cost_meals 
on Cost_meals.meal = agg_hotel.meal
