-- 1. What are the details of all cars purchased in the year 2022?

select distinct(s.car_id), make, type, style, cost_$
from cars c
join sales s using(car_id)
where year(s.purchase_date) = 2022;


-- 2. What is the total number of cars sold by each salesperson?

select salesman_id, name, count(sale_id) as no_of_cars_sold
from salespersons sp
join sales s
using (salesman_id)
group by 1,2;


-- 3. What is the total revenue generated by each salesperson?

select sales.salesman_id, name, sum(cost_$) as total_revenue
from cars
join sales using(car_id)
join salespersons using(salesman_id)
group by 1,2;


-- 4. What are the details of the cars sold by each salesperson?

select distinct(sales.salesman_id), name, sales.car_id, make, type, style, cost_$
from cars
join sales using(car_id)
join salespersons using(salesman_id);


-- 5. What is the total revenue generated by each car type?

select type, sum(cost_$) as revenue
from cars
join sales using(car_id)
group by 1;


-- 6. What are the details of the cars sold in the year 2021 by salesperson 'Emily Wong'?

select name, cars.car_id, make, type, style, cost_$, year(purchase_date) as year_no
from cars
join sales using(car_id)
join salespersons using(salesman_id)
where name="Emily Wong" and year(purchase_date) = 2021;


-- 7. What is the total revenue generated by the sales of hatchback cars?

select sales.car_id, style, sum(cost_$) as revenue
from cars
join sales using(car_id)
where style="Hatchback"
group by 1,2;


-- 8. What is the total revenue generated by the sales of SUV cars in the year 2022?

select style, sum(cost_$) as revenue, year(purchase_date) as year_no
from cars
join sales using(car_id)
where style = "SUV" and year(purchase_date) = 2022
group by 1,3;


-- 9. What is the name and city of the salesperson who sold the most number of cars in the year 2023?

select year(purchase_date) as year_no, name , city, count(sale_id) as no_of_cars_sold
from sales
join salespersons
using(salesman_id)
where year(purchase_date) = 2023
group by 1,2,3
order by 4 desc
limit 1;

-- 10. What is the name and age of the salesperson who generated the highest revenue in the year 2022?

select salespersons.name, age, sum(cost_$) as revenue
from cars
join sales using(car_id)
join salespersons using(salesman_id)
where year(purchase_date) = 2022
group by 1,2
order by 3 desc
limit 1;

