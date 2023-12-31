-- 1.What are the names of all the countries in the country table?

select country_name from country;


-- 2. What is the total number of customers in the customers table?

select count(customer_id) as no_of_customers from customers;

-- 3. What is the average age of customers who can receive marketing emails (can_email is set to 'yes')?

select avg(age) as avg_age from customers where can_email= 'yes';

-- 4. How many orders were made by customers aged 30 or older?

select count(o.order_id) as total_orders
from customers c join orders o on c.customer_id=o.customer_id
where c.age>=30;


-- 5. What is the total revenue generated by each product category?

 select  p.category,sum(p.price) as total_revenue
from baskets b
join products p on b.product_id=p.product_id
group by 1
order by 1 asc;


-- 6. What is the average price of products in the 'food' category?

select category, avg(price) from products
where category='food'
group by 1;


-- 7. How many orders were made in each sales channel (sales_channel column) in the orders table?

select sales_channel, count(order_id) as total_orders 
from orders
group by 1;


-- 8.What is the date of the latest order made by a customer who can receive marketing emails?

select o.date_shop
from customers c
join orders o on c.customer_id=o.customer_id
where can_email='yes'
order by 1 desc
limit 1;


-- 9. What is the name of the country with the highest number of orders?

select o.country_id,c.country_name, count(o.order_id) as total_orders 
from orders o 
join country c on o.country_id=c.country_id
group by 1,2
order by 3 desc
limit 1;


-- 10. What is the average age of customers who made orders in the 'vitamins' product category?

with cte1 as
(
select c.customer_id, c.age
from products p
join baskets b on p.product_id=b.product_id
join orders o on b.order_id=o.order_id
join customers c on o.customer_id=c.customer_id
where category='vitamins' 
group by 1)
select avg(age) as avg_age_cus from cte1;


