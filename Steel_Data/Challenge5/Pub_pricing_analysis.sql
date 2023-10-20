-- 1.How many pubs are located in each country??

select country, count(pub_id) as no_of_pubs
from pubs 
group by 1;


-- 2.What is the total sales amount for each pub, including the beverage price and quantity sold?

with cte as (
select s.pub_id,p.pub_name, (s.quantity*b.price_per_unit) as total_sales
from pubs p
join sales s on p.pub_id=s.pub_id
join beverages b using(beverage_id)
group by 1,2,3)
select pub_name, sum(total_sales) as total_sales
from cte group by 1;


-- 3.Which pub has the highest average rating?

select p.pub_name, round(avg(r.rating),2) as highest_average_rating
from ratings r
join pubs p using(pub_id)
group by 1
order by 2 desc limit 1;


-- 4.What are the top 5 beverages by sales quantity across all pubs?

select b.beverage_name, sum(s.quantity) as sales_quantity
from sales s
join beverages b using(beverage_id)
group by 1
order by 2 desc;


-- 5.How many sales transactions occurred on each date?

select transaction_date, count(distinct sale_id) as no_of_transactions
from sales group by 1;


-- 6.Find the name of someone that had cocktails and which pub they had it in?

select  r.customer_name, p.pub_name
from ratings r
join pubs p using(pub_id)
join sales s using(pub_id)
join beverages b using(beverage_id)
where b.category='cocktail';


-- 7.What is the average price per unit for each category of beverages, excluding the category 'Spirit'?

select category, round(avg(price_per_unit),2) as average_price
from beverages
where category !='spirit'
group by 1
order by 2 desc;


-- 8.Which pubs have a rating higher than the average rating of all pubs?

select distinct(p.pub_name), round(avg(r.rating),2) as avg_rating
from pubs p
join ratings r using(pub_id)
where r.rating > (select avg(rating)
from ratings)
group by 1;


-- 9.What is the running total of sales amount for each pub, ordered by the transaction date?

with cte1 as(
select pub_name,  transaction_date, sum(price_per_unit*quantity) as total_sales
from pubs p
join sales s using(pub_id)
join beverages b using(beverage_id)
group by 1, 2
order by 1, 2
)
select  pub_name, transaction_date, total_sales,
sum(total_sales) over( partition by pub_name order by transaction_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as running_total
from cte1;


-- 10.	For each country, what is the average price per unit of beverages in each category, and what is the overall average price per unit of beverages across all categories?

with cte1 as
(
select country, category, round(avg(price_per_unit),2) as average_price_per_unit_each_cat
from beverages b
join sales s using(beverage_id)
join pubs p using(pub_id)
group by 1,2
),
cte2 as
(
select country,round(avg(price_per_unit),2) as average_price_per_unit_all_cat
from beverages b
join sales s using(beverage_id)
join pubs p using(pub_id)
group by 1)
select c.country, category, average_price_per_unit_each_cat, average_price_per_unit_all_cat
from cte1 c
join cte2 ct using(country);



















