select * from [dbo].[sales_data]

-- levels for certain categorical vars

select distinct LINE from [dbo].[sales_data]
select distinct COUNTRY from [dbo].[sales_data]
select distinct STATUS from [dbo].[sales_data]

-- sales by year

select sum(sales) as grossrev_y, YEAR_ID from [dbo].[sales_data]
group by YEAR_ID
order by grossrev_y desc

-- did sales run through all of 2005? 
select distinct MONTH_ID from [dbo].[sales_data]
where YEAR_ID = 2005
-- half year of sales in 2005 

-- sales by line of product 

select sum(sales) as grossrev_l, LINE from [dbo].[sales_data]
group by LINE
order by grossrev_l desc


-- sales by size of deal
select sum(sales) as grossrev_s, size from [dbo].[sales_data]
group by size
order by grossrev_s desc

-- sales by month 2003
select sum(sales) as grossrev_m, count(ORDERNUMBER) as num_of_orders, MONTH_ID from [dbo].[sales_data]
where YEAR_ID = 2003
group by MONTH_ID
order by grossrev_m desc

-- sales by month 2004
select sum(sales) as grossrev_m, count(ORDERNUMBER) as num_of_orders, MONTH_ID from [dbo].[sales_data]
where YEAR_ID = 2004
group by MONTH_ID
order by grossrev_m desc


-- november has most sales in both
-- what line of product is selling in this month?
-- 2003
select sum(sales) as nov_revenue_03, line, count(ORDERNUMBER) as num_of_orders, MONTH_ID from [dbo].[sales_data]
where YEAR_ID = 2003 and MONTH_ID = 11
group by MONTH_ID, line
order by nov_revenue_03 desc

-- 2004
select sum(sales) as nov_revenue_04, line, count(ORDERNUMBER) as num_of_orders, MONTH_ID from [dbo].[sales_data]
where YEAR_ID = 2004 and MONTH_ID = 11
group by MONTH_ID, line
order by nov_revenue_04 desc

-- sort customers by sales, order numbers
DROP TABLE IF EXISTS #customertable
;with cust_data as (
select 
	name, avg(sales) as avg_sales, sum(sales) as gross_sales, count(ORDERNUMBER) as num_of_orders, 
	max(ORDERDATE) as customers_last_order
	FROM [dbo].[sales_data]
	group by name 
),
customer_calc as 
(
select *,
	NTILE(4) OVER (order by customers_last_order) as cust_data_recent, 
	NTILE(4) OVER (order by num_of_orders) as cust_data_num, 
	NTILE(4) OVER (order by avg_sales) as cust_data_avg 

from cust_data 
) 

select *, cust_data_recent+cust_data_num+cust_data_avg as customer_measure, 
cast(cust_data_recent as varchar) + cast(cust_data_num as varchar) + cast(cust_data_avg as varchar) as customer_string 
into #customertable
from customer_calc

-- test cte
select * from #customertable


select name, cust_data_recent, cust_data_num, cust_data_avg,
	case 
	when customer_string in (432, 422, 333, 332, 323, 321) then 'current_customer_low' -- customers who bought recently, spend low
	when customer_string in (444, 443, 434, 433) then 'current_customer_high' -- customers who bought recently, spend high
	-- can add more cases
	end as customer_class
	from #customertable

-- find bundled products, which two sell together
-- string of product codes
select DISTINCT ORDERNUMBER, STUFF(
(select ',' + CODE
from [dbo].[sales_data] AS q
where ORDERNUMBER in 
(

select ORDERNUMBER
from ( select count(*) as row_number, ORDERNUMBER
		from [dbo].[sales_data]
		where STATUS = 'Shipped'
		group by ORDERNUMBER) as z
		where row_number = 2
)
and q.ORDERNUMBER = r.ORDERNUMBER
for xml path ('')), 1, 1, '') AS pcode

from [dbo].[sales_data] as r
order by pcode desc