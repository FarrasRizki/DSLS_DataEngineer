## 1.
SELECT 
MONTH(OrderDate) AS Month,
COUNT(CustomerID) AS TotalCustomer
FROM Orders
WHERE YEAR(OrderDate) = 1997
GROUP BY MONTH(OrderDate);


## 2.
SELECT 
FirstName +' '+Lastname AS Name
FROM Employees
WHERE Title = 'Sales Representative';


## 3.
WITH Table1 as
(SELECT 
TOP 5 SUM(od.Quantity) as TotalOrder,
ProductName
FROM [Order Details] od 
	LEFT JOIN Products p ON od.ProductID = p.ProductID
	LEFT JOIN Orders o ON od.OrderID = o.OrderID
WHERE YEAR(OrderDate) = 1997
AND MONTH(OrderDate) = 1
GROUP BY ProductName
ORDER BY 1 DESC)

SELECT ProductName, TotalOrder
FROM Table1


## 4.
SELECT CompanyName
FROM [Order Details] od 
	LEFT JOIN Products p ON od.ProductID = p.ProductID
	LEFT JOIN Orders o ON od.OrderID = o.OrderID
	LEFT JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE YEAR(OrderDate) = 1997 
AND MONTH(OrderDate) = 6
AND ProductName = 'Chai';


## 5.
WITH table1 as
(SELECT o.OrderID, SUM(UnitPrice * Quantity) as TotalSales
FROM Orders o
	LEFT JOIN Customers c ON o.CustomerID = c.CustomerID
	LEFT JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.OrderID)

SELECT 
COUNT(CASE WHEN TotalSales <= 100 then OrderID END) AS '<=100',
COUNT(CASE WHEN TotalSales >100 AND TotalSales <= 250 then OrderID END) AS '101-250',
COUNT(CASE WHEN TotalSales >250 AND TotalSales <= 500 then OrderID END) AS '251-500',
COUNT(CASE WHEN TotalSales >500 then OrderID END) AS '>500'
FROM table1


## 6.
WITH table1 as
(SELECT SUM(UnitPrice * Quantity) as TotalSales, CompanyName
FROM Orders o
	LEFT JOIN Customers c ON o.CustomerID = c.CustomerID
	LEFT JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE YEAR(OrderDate) = 1997
GROUP BY CompanyName)

SELECT  CompanyName
FROM table1
WHERE TotalSales > 500


## 7.
WITH table1 as
(SELECT 
MONTH(OrderDate) as Month,
ProductName,
row_number() over 
 (partition by MONTH(OrderDate)  order by SUM(od.UnitPrice * Quantity) desc) as Ranking
FROM Orders o
	LEFT JOIN [Order Details] od ON o.OrderID = od.OrderID
	LEFT JOIN Products p ON od.ProductID = p.ProductID
WHERE YEAR(OrderDate) = 1997
GROUP BY MONTH(OrderDate), ProductName)

SELECT *
FROM table1
WHERE Ranking <= 5


## 8.
CREATE VIEW [NewTable] AS
SELECT OrderID, od.ProductID, ProductName, od.UnitPrice, Quantity, Discount, 
od.UnitPrice * (1-Discount) as PriceAfterDisc
FROM [Order Details] od 
	LEFT JOIN Products p ON od.ProductID = p.ProductID;

SELECT *
FROM NewTable


## 9.
CREATE PROCEDURE Invoice1 (@CustomerID NCHAR(5)) AS
BEGIN
SET NOCOUNT ON
SELECT O.CustomerID, CompanyName, OrderID, OrderDate, RequiredDate, ShippedDate 
FROM Orders O
INNER JOIN Customers C ON C.CustomerID=O.CustomerID
WHERE O.CustomerID = @CustomerID
END

EXEC Invoice1 ANTON;