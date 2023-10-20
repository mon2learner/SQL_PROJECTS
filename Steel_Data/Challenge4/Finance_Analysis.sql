-- 1.What are the names of all the customers who live in New York?

select firstname, lastname from customers where city='new york';


-- 2.What is the total number of accounts in the Accounts table?

select count(accountid) as total_accounts from accounts;


-- 3.What is the total balance of all checking accounts?

select accounttype, sum(balance) from accounts
where accounttype='checking'
group by accounttype;


-- 4.What is the total balance of all accounts associated with customers who live in Los Angeles?

select c.city, sum(a.balance) as total_balance
from customers c
join accounts a on c.customerid=a.customerid
where city='los angeles' group by 1;


-- 5.Which branch has the highest average account balance?

select b.branchname, avg(a.balance) as avg_balance
from branches b
join accounts a on b.branchid=a.branchid
group by 1
order by 2 desc
limit 1;


-- 6.Which customer has the highest current balance in their accounts?

select  c.firstname, c.lastname, max(a.balance) as balance
from customers c
join accounts a on c.customerid=a.customerid
group by 1,2
order by 3 desc limit 1;


-- 7.Which customer has made the most transactions in the Transactions table?

select a.customerid, c.firstname, c.lastname, count(t.transactionid) as no_of_transactions
from customers c
join accounts a on c.customerid=a.customerid
join transactions t on a.accountid=t.accountid
group by 1,2,3 order by 4 desc limit 1;


-- 8.Which branch has the highest total balance across all of its accounts?

select a.branchid, b.branchname,sum(a.balance) as total_balance
from branches b join accounts a on b.branchid=a.branchid
group by 1,2 order by 3 desc limit 1;


-- 9.Which customer has the highest total balance across all of their accounts, including savings and checking accounts?

select a.customerid, c.firstname, c.lastname, sum(a.balance) as total_balance
from customers c join accounts a on c.customerid=a.customerid
group by 1,2,3 order by 4 desc limit 1;


-- 10.Which branch has the highest number of transactions in the Transactions table?

with cte1 as
(
select a.branchid, b.branchname, count(t.transactionid) as no_of_transactions,
dense_rank() over(order by count(t.transactionid) desc) as rn
from branches b join accounts a on b.branchid=a.branchid
join transactions t on a.accountid=t.accountid
group by 1 )
select branchname, no_of_transactions from cte1
where rn=1;












