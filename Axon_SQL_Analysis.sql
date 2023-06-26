use classicmodels;

# Q1 Which country has the highest number of orders 

select Country,count(*) as orders_count from orders o
left join customers c
on o.customernumber=c.customernumber
group by country
order by count(*) desc;

# Q.2 What is productline with highest orders

select productline,count(*) orders_count from products p
join orderdetails od
on p.productcode=od.productcode
group by productline
order by count(*) desc;

#Q.3 Total Number of customers 

select distinct(count(*)) as Total_Number_of_customers from customers;

#Q.4 Who all are repeated customers

select p.CustomerNumber,CustomerName,Count(*) as Number_of_payments from payments p
join customers c
on p.CustomerNumber=c.CustomerNumber
group by p.CustomerNUmber
order by Count(*) desc;

#Q.5 Top 5 Customers who Made Higest Payments

select c.customerNumber, customerName,SUM(amount) as total_payments from payments p
join customers c
on c.customerNumber = p.customerNumber
group by c.customerNumber
order by total_payments DESC
LIMIT 5;

# Q.6 What is peak sales month in each year

with cte as 
(select YEAR(orderDate) AS year,MONTH(orderDate) AS month,SUM(quantityOrdered) AS total_orders,
 RANK() over (partition by YEAR(orderDate) order by SUM(quantityOrdered) desc) AS ranks 
 from orders o
 join orderdetails od
 on o.orderNumber = od.orderNumber
 group by year, month
)
select year, month, total_orders
from cte
where ranks = 1;

#Q.7 Which product ordered most

with cte AS 
(select p.productName,count(*) as total_ordered,RANK() over (order by count(*) desc) as ranks
    from orderdetails od
    join orders o ON od.orderNumber = o.orderNumber
    join customers c ON o.customerNumber = c.customerNumber
    join products p ON od.productCode = p.productCode
    group by p.productName
)
select productName, total_ordered
from cte
where ranks = 1;

#Q.8 How many Number of customers each country has

select country, count(*) as num_of_customer
from customers
group by country
order by num_of_customer desc;


#Q.9 Find out the top three employees who have managed the most orders

select employeeNumber, count(*) as total_orders_managed,sum(quantityOrdered) as total_products_ordered_under
from orders o
join customers c
on o.customerNumber = c.customerNumber
join employees e
on c.salesRepEmployeeNumber = e.employeeNumber
join orderdetails o2 
on o.orderNumber = o2.orderNumber
group by employeeNumber
order by total_orders_managed desc
limit 3;




