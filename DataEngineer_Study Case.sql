-- ## Product Analysis
-- 1. What are the 3 most purchased products with 25% discount ?
SELECT TOP 3 ProductName, Quantity, Discount
FROM [Order Details] AS od
	LEFT JOIN Products AS p ON od.ProductID = p.ProductID
WHERE Discount = 0.25
ORDER BY Quantity DESC

-- 2. How quantity trend of 'Chartreuse verte' products in every year ?
SELECT 
ProductName, 
SUM(Quantity) AS TotalQuantity, 
YEAR(OrderDate) AS Year
FROM [Order Details] AS od
	LEFT JOIN Products AS p ON od.ProductID = p.ProductID
	LEFT JOIN Orders AS o ON o.OrderID = od.OrderID
WHERE ProductName = 'Chartreuse verte'
GROUP BY YEAR(OrderDate), ProductName

-- 3. Top 3 product categories are most purchased
SELECT TOP 3 CategoryName, SUM(Quantity) AS Quantity
FROM [Order Details] AS od
	LEFT JOIN Products AS p ON od.ProductID = p.ProductID
	LEFT JOIN Categories AS c ON c.CategoryID = p.CategoryID
GROUP BY CategoryName
ORDER BY Quantity DESC


-- ## Customer Analysis
-- 1. 5 Most loyal companies customers (highest revenue)
SELECT TOP 5 CompanyName, SUM(UnitPrice * Quantity) AS Revenue
FROM [Order Details] AS od
	LEFT JOIN Orders AS o ON o.OrderID = od.OrderID
	LEFT JOIN Customers AS c ON o.CustomerID = c.CustomerID
GROUP BY CompanyName
ORDER BY SUM(UnitPrice * Quantity) DESC

-- ## Shipper  Analysis
-- 1. TOP 5 Cities with the highest number of shipments
SELECT TOP 5 ShipCity, COUNT(OrderID) AS TotalShipping 
FROM Orders
GROUP BY ShipCity
ORDER BY COUNT(OrderID) DESC