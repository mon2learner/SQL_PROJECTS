create database  if not exists SalesWalmartData;


create table if not exists sales(
	invoice_id varchar(30) not null primary key,
    branch varchar(5) not null,
    city varchar(30) not null,
    customer_type varchar(30) not null,
    gender varchar(30) not null,
    product_line varchar(100) not null,
    unit_price decimal(10,2) not null,
    quantity int not null,
    tax_pct float(6,4) not null,
    total decimal(12,4),
    date datetime not null,
    time time not null,
    payment varchar(15) not null,
    cogs decimal(15) not null,
    gross_margin_pct float(11,9),
    gross_income decimal (12,4),
    rating float(2,1)

);
-- ------------------------------------ Feature Engineering---------------------------------------
-- -----------------------------------------------------------------------------------------------

-- time of day-------------

select time,  
case when time between "00:00:00" and "12:00:00" then "Morning"
	 when time between "12:00:01"  and "16:00:00" then "Afternoon"
     else "Evening"
     end as day_times
from sales;

alter table sales add column time_of_day varchar(15);

update  sales set time_of_day = (case when time between "00:00:00" and "12:00:00" then "Morning"
	 when time between "12:00:01"  and "16:00:00" then "Afternoon"
     else "Evening"
     end);


-- day_name-----------------

select date, dayname(date) 
from sales;

alter table sales add column day_name varchar(15);

update sales
set day_name = dayname(date);


-- month name------------------

select date , monthname(date)
from sales;

alter table sales add column month_name varchar(15);
update sales 
set month_name = monthname(date);


-- -----------------------------Generic----------------------------------------
-- ----------------------------------------------------------------------------

-- 1.How many unique cities does the data have?

select distinct(city) as unique_cities 
from sales;

-- 2.In which city is each branch?

select distinct(city), branch
from sales;

-- ---------------------------Product------------------------------------------
-- ----------------------------------------------------------------------------

-- 1. How many unique product lines does the data have?

select count(distinct(product_line)) as no_of_product_line 
from sales;

-- 2. What is the most common payment method?

select payment, count(payment) as cnt
from sales
group by 1
order by 2 desc;

-- 3. What is the most selling product line?

select product_line, sum(quantity) as no_of_item_sold
from sales
group by 1
order by 2 desc;

select product_line, count(quantity) as no_of_item_sold
from sales
group by 1
order by 2 desc;


-- 4. What is the total revenue by month?

select month_name, sum(unit_price*quantity) as total_revenue
from sales
group by 1
order by 2 desc;


-- 5. What month had the largest COGS?

select month_name, sum(cogs) as total_cogs
from sales
group by 1
order by 2 desc;


-- 6. What product line had the largest revenue?

select product_line, sum(unit_price*quantity) as total_revenue
from sales
group by 1
order by 2 desc;


-- 7. What is the city with the largest revenue?

select city, sum(unit_price*quantity) as total_revenue
from sales
group by 1
order by 2 desc;


-- 8. What product line had the largest VAT?

select product_line, avg(5/100 * cogs) as VAT
from sales
group by 1
order by 2 desc;


-- 9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

with cte1 as
(
select product_line,round(avg((5/100 * cogs) + cogs),2) as avg_sales_product ,
(select round(avg((5/100 * cogs) + cogs),2) from sales) as average_sales
from sales
group by 1
order by 2 desc
)
select *,
case when avg_sales_product > average_sales then "Good" else "Bad" end as review
from cte1;


-- 10.Which branch sold more products than average product sold?

select branch, sum(quantity) as quantity_sold
from sales
group by 1
having sum(quantity)> (select avg(quantity) from sales)
order by 2 desc;


-- 11. What is the most common product line by gender?

select product_line, gender, count(gender) as total_cnt
from sales
group by 1,2
order by 3 desc;


-- What is the average rating of each product line?

select product_line, round(avg(rating),2) as avg_rating
from sales
group by product_line
order by avg_rating desc;


-- ---------------------------Sales------------------------------------------
-- ----------------------------------------------------------------------------

-- 1.Number of sales made in each time of the day per weekday


select day_name,time_of_day , count(*) as total_sales
from sales
where day_name  not in ("saturday", "sunday")
group by day_name,time_of_day
order by 1,3 desc;


-- 2.Which of the customer types brings the most revenue?


select customer_type, round(sum(total),2) as total_rev
from sales
group by customer_type
order by total_rev desc;


-- 3.Which city has the largest tax percent/ VAT (Value Added Tax)?


select city, round(avg(tax_pct),2) as avg_tax_pcnt
from sales
group by 1
order by 2 desc;


-- 4.Which customer type pays the most in VAT?


select customer_type, round(avg(5/100 * cogs),2) as VAT
from sales
group by 1
order by 2 desc;


-- ---------------------------Customer------------------------------------------
-- ----------------------------------------------------------------------------


-- 1.How many unique customer types does the data have?


select distinct(customer_type) as customer_type, 
(select count(distinct(customer_type) ) from sales) as total_count
from sales
group by 1;


-- 2.How many unique payment methods does the data have?


select distinct(payment) as customer_type, 
(select count(distinct(payment) ) from sales) as total_count
from sales
group by 1;


-- 3.What is the most common customer type?


select customer_type, count(customer_type) as cnt
from sales
group by 1
order by 2 desc 
limit 1;


-- 4.Which customer type buys the most?


select customer_type, count(*) as cnt
from sales
group by 1
order by 2 desc 
limit 1;


-- 5.What is the gender of most of the customers?

select gender, count(*) as gender_cnt
from sales
group by 1
order by 2 desc;


-- 6.What is the gender distribution per branch?


select branch,gender, count(*) as gender_cnt
from sales
group by 1,2
order by 1,3 desc;


-- 7.Which time of the day do customers give most ratings?

select time_of_day, count(rating) as total_rating_cnt
from sales
group by 1
order by 2 desc;


-- 8.Which time of the day do customers give most ratings per branch?


select branch, time_of_day, count(rating) as total_rating_cnt
from sales
group by 1,2
order by 1,3 desc;


-- 9.Which day fo the week has the best avg ratings?


select day_name, avg(rating) as avg_rating
from sales
group by 1
order by 2 desc;


-- 10.Which day of the week has the best average ratings per branch?

select branch, day_name, avg_rating
from(
select branch, day_name, avg(rating) as avg_rating,
rank() over(partition by branch order by  avg(rating) desc ) as rnk
from sales
group by 1,2
order by 1,3 desc) a
where rnk=1
;

