 ------------classification of customers-------------
    With customer_revenue AS
(select 
c.customerName,
c.customerNumber,
c.country,
sum(quantityOrdered * priceEach) as revenue,
row_number() over(partition by c.country
order by sum(quantityOrdered * priceEach) DESC ) as rnk
from customers c
join orders o
on    c.customerNumber = o.customerNumber
join orderdetails od
on o.orderNumber = od.orderNumber
group by c.customerNumber)
select *,
case
when revenue > 100000 then "high"
when revenue > 50000 then "medium"
else "low"
end AS category
from customer_revenue
-------------TOP 5 PRODCUTS-----------------
select od.productCode,
p.productName,
od.quantityOrdered,
o.customerNumber,
sum(quantityOrdered * priceEach) as revenue
from 
orderdetails od
join products p
  on p.productCode = od.productCode
  join orders o
  on od.orderNumber = o.orderNumber
group by od.productCode,od.quantityOrdered,p.productName,o.customerNumber
--------------MONTHLY REVENUE TREND----------------------
select o.orderNumber,
o.orderDate,
o.customerNumber,
sum(quantityOrdered * priceEach) as revenue 
from orders o
  join customers c
  on c.customerNumber = o.customerNumber
  join orderdetails od
    on o.orderNumber = od.orderNumber
    group by orderNumber
