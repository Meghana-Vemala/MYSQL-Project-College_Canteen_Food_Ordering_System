-- ==========================================
-- COLLEGE CANTEEN FOOD ORDERING & BILLING SYSTEM
-- END-TO-END MYSQL PROJECT
-- ==========================================

-- Contents:

-- PART 1  : Database & Table Creation
-- PART 2  : Sample Data (INSERT Statements)
-- PART 3  : Indexes
-- PART 4  : Views
-- PART 5  : Stored Procedures
-- PART 6  : Query Bank - Level 1
-- PART 7  : Query Bank - Level 2
-- PART 8  : Query Bank - Level 3
-- PART 9 : Advanced SQL Queries
-- PART 10 : Demo Calls and Final Output

-- RDBMS : MySQL 8.0+

-- PART 1: DATABASE & TABLE CREATION
------------------------------------------------------------

DROP DATABASE IF EXISTS CanteenDB;

CREATE DATABASE CanteenDB;

USE CanteenDB;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) UNIQUE,
    email VARCHAR(100),
    address VARCHAR(200)
);


CREATE TABLE Categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL UNIQUE
);


CREATE TABLE Food_Items (
    food_id INT PRIMARY KEY AUTO_INCREMENT,
    food_name VARCHAR(100) NOT NULL,
    category_id INT,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    FOREIGN KEY (category_id)
    REFERENCES Categories(category_id)
);


CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    order_status VARCHAR(30) DEFAULT 'Pending',
    FOREIGN KEY (customer_id)
    REFERENCES Customers(customer_id)
);


CREATE TABLE Order_Details (
    detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    food_id INT,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id)
    REFERENCES Orders(order_id),
    FOREIGN KEY (food_id)
    REFERENCES Food_Items(food_id)
);

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT UNIQUE,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(30),
    payment_status VARCHAR(30) DEFAULT 'Paid',
    FOREIGN KEY (order_id)
    REFERENCES Orders(order_id)
);

SHOW TABLES;

-- ==========================================
-- PART 2: SAMPLE DATA
-- ==========================================

-- Insert Categories

INSERT INTO Categories (category_name)
VALUES
('Snacks'),
('Drinks'),
('Meals'),
('Fast Food'),
('Desserts');

SELECT * FROM Categories;

-- Insert Customers

INSERT INTO Customers
(customer_name, phone, email, address)
VALUES
('Meghana', '9876543210', 'meghana@gmail.com', 'Hyderabad'),
('Rahul', '9876543211', 'rahul@gmail.com', 'Vijayawada'),
('Priya', '9876543212', 'priya@gmail.com', 'Guntur'),
('Arjun', '9876543213', 'arjun@gmail.com', 'Warangal'),
('Sneha', '9876543214', 'sneha@gmail.com', 'Nellore');

SELECT * FROM Customers;

-- Insert Food Items

INSERT INTO Food_Items
(food_name, category_id, price, stock_quantity)
VALUES
('Idli', 1, 30.00, 50),
('Dosa', 1, 50.00, 40),
('Burger', 4, 80.00, 25),
('Pizza', 4, 120.00, 20),
('Tea', 2, 10.00, 100),
('Coffee', 2, 20.00, 80),
('Veg Meals', 3, 100.00, 30),
('Ice Cream', 5, 40.00, 35),
('Juice', 2, 30.00, 45),
('Samosa', 1, 15.00, 60);

-- Display Food Items

SELECT * FROM Food_Items;

-- Insert Orders

INSERT INTO Orders
(customer_id, order_status)
VALUES
(1, 'Completed'),
(2, 'Completed'),
(3, 'Pending'),
(4, 'Completed'),
(5, 'Pending');

-- Display Orders

SELECT * FROM Orders;


-- Insert Order Details

INSERT INTO Order_Details
(order_id, food_id, quantity, unit_price)
VALUES
(1, 1, 2, 30.00),
(1, 5, 2, 10.00),
(2, 3, 1, 80.00),
(2, 6, 1, 20.00),
(3, 4, 1, 120.00),
(3, 9, 2, 30.00),
(4, 7, 1, 100.00),
(4, 8, 1, 40.00),
(5, 2, 2, 50.00),
(5, 10, 2, 15.00);

-- Display Order Details

SELECT * FROM Order_Details;

-- Insert Payments

INSERT INTO Payments
(order_id, amount, payment_method, payment_status)
VALUES
(1, 80.00, 'Cash', 'Paid'),
(2, 100.00, 'UPI', 'Paid'),
(3, 180.00, 'Cash', 'Pending'),
(4, 140.00, 'UPI', 'Paid'),
(5, 130.00, 'Cash', 'Pending');

-- Display Payments

SELECT * FROM Payments;


-- ==========================================
-- PART 3: INDEXES
-- ==========================================

-- Index on Customer Name

CREATE INDEX idx_customer_name
ON Customers(customer_name);


-- Index on Food Name

CREATE INDEX idx_food_name
ON Food_Items(food_name);


-- Index on Order Date

CREATE INDEX idx_order_date
ON Orders(order_date);


-- Index on Payment Status

CREATE INDEX idx_payment_status
ON Payments(payment_status);

SHOW INDEX FROM Customers;

SHOW INDEX FROM Food_Items;

SHOW INDEX FROM Orders;

SHOW INDEX FROM Payments;

-- ==========================================
-- PART 4: VIEWS
-- ==========================================

-- View 1: Customer Details

CREATE VIEW Customer_View AS
SELECT
customer_id,
customer_name,
phone,
email
FROM Customers;

-- View 2: Food Details

CREATE VIEW Food_View AS
SELECT
food_id,
food_name,
price,
stock_quantity
FROM Food_Items;

-- View 3: Order Details

CREATE VIEW Order_View AS
SELECT
o.order_id,
c.customer_name,
o.order_date,
o.order_status
FROM Orders o
JOIN Customers c
ON o.customer_id = c.customer_id;

SELECT * FROM Customer_View;

SELECT * FROM Food_View;

SELECT * FROM Order_View;


-- ==========================================
-- PART 5: STORED PROCEDURES
-- ==========================================

-- Procedure 1: Display All Customers

DELIMITER //

CREATE PROCEDURE GetAllCustomers()
BEGIN
    SELECT * FROM Customers;
END //

DELIMITER ;

CALL GetAllCustomers();



-- Procedure 2: Display All Food Items

DELIMITER //

CREATE PROCEDURE GetAllFoodItems()
BEGIN
    SELECT * FROM Food_Items;
END //

DELIMITER ;

-- Execute Procedure

CALL GetAllFoodItems();


-- Procedure 3: Display All Orders

DELIMITER //

CREATE PROCEDURE GetAllOrders()
BEGIN
    SELECT * FROM Orders;
END //

DELIMITER ;

-- Execute Procedure

CALL GetAllOrders();


-- Procedure 4: Display All Payments

DELIMITER //

CREATE PROCEDURE GetAllPayments()
BEGIN
    SELECT * FROM Payments;
END //

DELIMITER ;

-- Execute Procedure

CALL GetAllPayments();

SELECT * FROM Payments;

INSERT INTO Payments
(order_id, amount, payment_method, payment_status)
VALUES
(1, 80.00, 'Cash', 'Paid'),
(2, 100.00, 'UPI', 'Paid'),
(3, 180.00, 'Cash', 'Pending'),
(4, 140.00, 'UPI', 'Paid'),
(5, 130.00, 'Cash', 'Pending');

CALL GetAllPayments();

------------  PART 6 Query bank level 1 --------------------

USE CanteenDB;

-- Display all customers --

SELECT * FROM Customers;

-- Display only food names and prices --
SELECT food_name, price
FROM Food_Items;

-- Find food items costing more than ₹50 --
SELECT * FROM Food_Items
WHERE price > 50;

-- Find food items between ₹20 and ₹100 --
SELECT * FROM Food_Items
WHERE price BETWEEN 20 AND 100;

-- Find food names starting with 'D' --
SELECT * FROM Food_Items
WHERE food_name LIKE 'D%';

-- Display food from selected categories --
SELECT * FROM Food_Items
WHERE category_id IN (1, 2, 4);

-- Display different payment methods --
SELECT DISTINCT payment_method
FROM Payments;

-- Display food items in ascending price order --
SELECT * FROM Food_Items
ORDER BY price ASC;

-- Display the first five food items --
SELECT * FROM Food_Items
LIMIT 5;

-- Count the total number of customers --
SELECT COUNT(*) AS Total_Customers
FROM Customers;

-- Find the average food price --
SELECT AVG(price) AS Average_Price
FROM Food_Items;

-- Find the highest and lowest food prices --
SELECT MAX(price) AS Highest_Price,
       MIN(price) AS Lowest_Price
FROM Food_Items;

-- Count food items in each category --
SELECT category_id, COUNT(*) AS Total_Foods
FROM Food_Items
GROUP BY category_id;

-- Display only pending orders --
SELECT * FROM Orders
WHERE order_status = 'Pending';

-- Display orders with customer names --

SELECT Orders.order_id,
       Customers.customer_name,
       Orders.order_status
FROM Orders
JOIN Customers
ON Orders.customer_id = Customers.customer_id;

---- PART 7 Query bank level 2 ----

USE CanteenDB;

-- Display customers whose names contain 'a' --
SELECT * FROM Customers
WHERE customer_name LIKE '%a%';

-- Display food items with stock less than 40 --
SELECT * FROM Food_Items
WHERE stock_quantity < 40;

SET SQL_SAFE_UPDATES = 0;

-- Increase the price of all food items by 10% --

UPDATE Food_Items
SET price = price * 1.10;

SELECT * FROM Food_Items;

-- Display food items with prices in descending order --

SELECT * FROM Food_Items
ORDER BY price DESC;

-- Find the total stock quantity --

SELECT SUM(stock_quantity) AS Total_Stock
FROM Food_Items;

-- Find the total payment amount --
SELECT SUM(amount) AS Total_Amount
FROM Payments;

-- Count orders based on their status --
SELECT order_status, COUNT(*) AS Total_Orders
FROM Orders
GROUP BY order_status;

-- Display categories having more than one food item --
SELECT category_id, COUNT(*) AS Total_Foods
FROM Food_Items
GROUP BY category_id
HAVING COUNT(*) > 1;

-- Display food names with their category names --
SELECT f.food_name, c.category_name
FROM Food_Items f
JOIN Categories c
ON f.category_id = c.category_id;

-- Display customer names with their order details --
SELECT c.customer_name, o.order_id, o.order_status
FROM Customers c
JOIN Orders o
ON c.customer_id = o.customer_id;

-- Display orders and their payment details --
SELECT o.order_id, o.order_status,
       p.amount, p.payment_method
FROM Orders o
LEFT JOIN Payments p
ON o.order_id = p.order_id;

-- Find food items costing more than the average food price --
SELECT * FROM Food_Items
WHERE price > (
    SELECT AVG(price)
    FROM Food_Items
);

-- Find customers who have placed orders --
SELECT * FROM Customers
WHERE customer_id IN (
    SELECT customer_id
    FROM Orders
);

-- Display the second-highest food price --
SELECT MAX(price) AS Second_Highest_Price
FROM Food_Items
WHERE price < (
    SELECT MAX(price)
    FROM Food_Items
);

-- Display total revenue from paid payments --
SELECT SUM(amount) AS Total_Revenue
FROM Payments
WHERE payment_status = 'Paid';

-----  PART 8 Query level - 3 -----

USE CanteenDB;

-- Count total customers --
SELECT COUNT(*) AS Total_Customers
FROM Customers;

-- Find the average price of food items --
SELECT AVG(price) AS Average_Price
FROM Food_Items;

-- Find the highest food price --
SELECT MAX(price) AS Highest_Price
FROM Food_Items;

-- Find the lowest food price --
SELECT MIN(price) AS Lowest_Price
FROM Food_Items;

-- Calculate total available stock --
SELECT SUM(stock_quantity) AS Total_Stock
FROM Food_Items;

-- Count orders by order status --
SELECT order_status, COUNT(*) AS Total_Orders
FROM Orders
GROUP BY order_status;

-- Calculate total payment amount for each payment method --
SELECT payment_method, SUM(amount) AS Total_Amount
FROM Payments
GROUP BY payment_method;

-- Display payment methods with total amount greater than 200 --
SELECT payment_method, SUM(amount) AS Total_Amount
FROM Payments
GROUP BY payment_method
HAVING SUM(amount) > 200;

-- Display customer names with their order details --
SELECT Customers.customer_name,
       Orders.order_id,
       Orders.order_status
FROM Customers
INNER JOIN Orders
ON Customers.customer_id = Orders.customer_id;

-- Display all customers and their orders --
SELECT Customers.customer_name,
       Orders.order_id
FROM Customers
LEFT JOIN Orders
ON Customers.customer_id = Orders.customer_id;

-- Display order details with payment information --
SELECT Orders.order_id,
       Orders.order_status,
       Payments.amount,
       Payments.payment_method
FROM Orders
INNER JOIN Payments
ON Orders.order_id = Payments.order_id;

-- Display food items whose price is above average --
SELECT *
FROM Food_Items
WHERE price > (
    SELECT AVG(price)
    FROM Food_Items
);

-- Display the top 3 expensive food items --
SELECT *
FROM Food_Items
ORDER BY price DESC
LIMIT 3;

-- Display customers whose names start with 'A' --
SELECT *
FROM Customers
WHERE customer_name LIKE 'A%';

-- Display all paid paymentsDisplay all paid payments --
SELECT *
FROM Payments
WHERE payment_status = 'Paid';


-- Delete a customer using customer_id --

DELETE FROM Customers
WHERE customer_id = 5;

-- Delete a food item using food_id --
DELETE FROM Food_Items
WHERE food_id = 10;

-- Delete pending payments --
DELETE FROM Payments
WHERE payment_status = 'Pending';

-- Delete completed orders --
DELETE FROM Orders
WHERE order_status = 'Completed';

-- Delete a payment using payment_id --
DELETE FROM Payments
WHERE payment_id = 5;

START TRANSACTION;

DELETE FROM Food_Items
WHERE food_id = 10;

SELECT * FROM Food_Items;

ROLLBACK;


------- PART 9 Advanced SQL --------

USE CanteenDB;

-- Find the second-highest food price --

SELECT MAX(price) AS Second_Highest
FROM Food_Items
WHERE price < (SELECT MAX(price) FROM Food_Items);

-- Find customers who have not placed orders -- 
SELECT *
FROM Customers
WHERE customer_id NOT IN
(SELECT customer_id FROM Orders);

-- Find total orders for each customer --
SELECT customer_id, COUNT(*) AS Total_Orders
FROM Orders
GROUP BY customer_id;

-- Find total revenue from paid payments --
SELECT SUM(amount) AS Total_Revenue
FROM Payments
WHERE payment_status = 'Paid';

-- Display orders with customer names --
SELECT C.customer_name, O.order_id
FROM Customers C
INNER JOIN Orders O
ON C.customer_id = O.customer_id;

-- Find food items with above-average stock --
SELECT *
FROM Food_Items
WHERE stock_quantity >
(SELECT AVG(stock_quantity) FROM Food_Items);

-- Find categories having more than one food item --
SELECT category_id, COUNT(*) AS Total_Items
FROM Food_Items
GROUP BY category_id
HAVING COUNT(*) > 1;

-- Find the total stock value --
SELECT SUM(price * stock_quantity) AS Stock_Value
FROM Food_Items;

------- PART 10: DEMO CALLS AND FINAL OUTPUT -------

-- Display all customers --
SELECT * FROM Customers;

-- Display all food items --
SELECT * FROM Food_Items;

-- Display all categories --
SELECT * FROM Categories;

-- Display all orders with customer names --
SELECT C.customer_name,
       O.order_id,
       O.order_date,
       O.order_status
FROM Customers C
JOIN Orders O
ON C.customer_id = O.customer_id;

-- Display all order details with food names --
SELECT O.order_id,
       F.food_name,
       D.quantity,
       D.unit_price
FROM Order_Details D
JOIN Orders O ON D.order_id = O.order_id
JOIN Food_Items F ON D.food_id = F.food_id;

-- Display all order details with food names --
SELECT O.order_id,
       F.food_name,
       D.quantity,
       D.unit_price
FROM Order_Details D
JOIN Orders O ON D.order_id = O.order_id
JOIN Food_Items F ON D.food_id = F.food_id;

-- Display all payment details --
SELECT * FROM Payments;

-- Display total paid revenue --
SELECT SUM(amount) AS Total_Revenue
FROM Payments
WHERE payment_status = 'Paid';

-- Display all stored procedures --
SHOW PROCEDURE STATUS
WHERE Db = 'CanteenDB';














