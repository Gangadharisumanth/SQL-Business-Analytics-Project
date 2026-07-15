create database E_Commerce;
use E_Commerce;
CREATE TABLE Customers(
customer_id int primary key,
customer_name varchar(99),
city varchar(99));

INSERT INTO Customers VALUES
(1,'Rahul','Hyderabad'),
(2,'Priya','Chennai'),
(3,'Arjun','Bangalore'),
(4,'Sneha','Mumbai'),
(5,'Kiran','Delhi'),
(6,'Anjali','Pune'),
(7,'Vikram','Kolkata'),
(8,'Meera','Jaipur'),
(9,'Rohan','Ahmedabad'),
(10,'Neha','Lucknow');

create table Products(
product_id int primary key,
product_name varchar(89),
category varchar(78),
price decimal(10,2));

INSERT INTO Products VALUES
(101,'Laptop','Electronics',60000),
(102,'Mobile','Electronics',25000),
(103,'Headphones','Accessories',2000),
(104,'Keyboard','Accessories',1500),
(105,'Monitor','Electronics',12000),
(106,'Mouse','Accessories',800),
(107,'Tablet','Electronics',18000),
(108,'Printer','Electronics',10000),
(109,'Speaker','Accessories',3000),
(110,'Webcam','Accessories',2500);
select * from products;
create table orders(
order_id int primary key,
customer_id int,
order_date date,
foreign key(customer_id) references customers(customer_id));

INSERT INTO Orders VALUES
(1001,1,'2025-01-10'),
(1002,2,'2025-01-12'),
(1003,1,'2025-02-05'),
(1004,3,'2025-02-15'),
(1005,4,'2025-03-01'),
(1006,2,'2025-03-10'),
(1007,5,'2025-03-15'),
(1008,6,'2025-04-01'),
(1009,7,'2025-04-12'),
(1010,8,'2025-04-20');

create table order_details(
order_id int,
product_id int,
quantity int,
primary key(order_id,product_id),
foreign key(product_id) references products(product_id));

INSERT INTO Order_Details VALUES
(1001,101,1),
(1001,103,2),
(1002,102,1),
(1002,104,1),
(1003,105,1),
(1004,102,2),
(1004,103,1),
(1005,101,1),
(1006,104,3),
(1007,107,1),
(1008,108,2),
(1009,109,4),
(1010,106,5);

select * from customers;
select * from products;
select * from orders;
select * from order_details;

# 1 : Products with price greater than 10000
SELECT product_name,price FROM products WHERE price>10000;

#2 : Orders between 1st feb and 28 feb
SELECT * FROM orders WHERE order_date BETWEEN '2025-02-01' AND '2025-02-28';

#3 : Unique Product names
SELECT DISTINCT product_name FROM products;

#4 : Total number of customers
SELECT COUNT(*) AS "Total_Customers" FROM customers;

#5 : 
SELECT ROUND(AVG(price),2) AS "AVERAGE_PRICE" FROM products;

#6 : Expensive product
SELECT product_name AS "Name",MAX(price) AS "Expensive_Product" FROM products group by product_name LIMIT 1;

#7 : Total quantities ordered
SELECT SUM(quantity) as"Total_Quantity" from order_details;

#8 : Total Categories
SELECT category,COUNT(category) as "Total_Categories" From PRODUCTS group by Category;

#9 : 
SELECT customer_id,count(order_id) as "Total_Orders" from orders group by customer_id;

#10 : Total spent by each customer
SELECT c.customer_id,c.customer_name,SUM(p.price * od.quantity) AS total_spent FROM Customers c JOIN Orders o ON c.customer_id = o.customer_id
JOIN Order_Details od ON o.order_id = od.order_id JOIN Products p ON od.product_id = p.product_id GROUP BY c.customer_id, c.customer_name;

#11 : 
SELECT P.category,sum(O.quantity) as Total_Quantity from products P join order_details O on P.product_id=O.product_id group by category;

#12 : Customers with more than one order
SELECT C.customer_id,count(*) as "Total_Orders" from Customers C join Orders O on C.customer_id=O.customer_id group by C.customer_id having count(*)>1; 

#13 : Products whose total quantity sold is greater than 2
SELECT P.PRODUCT_ID,SUM(O.quantity)"Total_Sold_Quantity" FROM products P join Order_Details O on p.product_id=O.product_id group by P.product_id having Total_Sold_Quantity>2;

#14 : customer names along with their order IDs
SELECT C.customer_name,O.order_id FROM customers C join Orders O on c.Customer_id=O.customer_id;

#15 : order details with product names
SELECT OD.order_id,P.product_name,O.order_date FROM products P join Order_details OD on P.product_id=OD.product_id join Orders O on O.order_id=OD.order_id; 

#16 : customer names and products they purchased
SELECT C.customer_name,P.product_name from Customers C join Orders O ON C.customer_id=O.customer_id join order_details OD ON O.order_id=OD.order_id
join Products P on P.product_id=OD.product_id; 

#17 : order date, customer name, and product name
SELECT C.customer_name,P.product_name,O.order_date from Customers C join Orders O ON C.customer_id=O.customer_id join order_details OD ON O.order_id=OD.order_id
join Products P on P.product_id=OD.product_id; 

#18 : customers who never placed an order
SELECT C.customer_name,O.order_id from customers C left outer join orders O on C.customer_id=O.customer_id where order_id is NULL;

#19 : products that were never sold
SELECT P.product_id,O.order_id from Products P LEFT JOIN order_details O on P.product_id=O.product_id where O.product_id is NULL;

#20 : products priced above the average price
SELECT product_id,product_name from products where price>(select avg(price) from products);

#21 : the customer who placed the maximum number of orders
SELECT C.customer_id,C.customer_name,count(O.order_id) as "Max_Orders" from Customers C join orders O on C.customer_id=O.customer_id group by C.customer_id,C.customer_name order by Max_Orders desc limit 1 ;

#22 : the best-selling product
SELECT p.product_id,
       p.product_name,
       SUM(oi.quantity) AS total_sold
FROM Products p
JOIN Order_Items oi
ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_sold DESC
LIMIT 1; 

#23 : total revenue generated by each category
SELECT p.product_name,p.category,sum(od.quantity*p.price) as "Total_Revenue" from products p join order_details od 
on p.product_id=od.product_id group by p.product_name,p.category; 

#24 : the top 3 customers by spending
SELECT c.customer_id,c.customer_name,SUM(oi.quantity * p.price) AS total_spent FROM Customers c JOIN Orders o
ON c.customer_id = o.customer_id JOIN Order_details oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC
LIMIT 3;