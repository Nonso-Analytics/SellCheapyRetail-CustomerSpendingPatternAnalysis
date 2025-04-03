-- Data Exploratory Analysis

-- What is the total number of customers we have currently
SELECT COUNT(CustomerID) AS NumofCustomers
FROM dim_customer_view

-- What products are we currently offering
SELECT COUNT(ProductID)
FROM dim_products_view

-- Identify the best selling products
SELECT TOP (10)
    p.Product, 
    SUM(f.OrderQty) AS TotalQuantitySold, 
    SUM(f.LineTotal) AS TotalRevenue
FROM fact_sales_view AS f
LEFT JOIN dim_products_view AS p ON f.ProductID = p.ProductID
GROUP BY p.Product
ORDER BY TotalRevenue DESC;

-- Revenue contribution by category
SELECT 
    p.Category, 
    SUM(f.LineTotal) AS TotalRevenue,
    SUM(f.LineTotal) * 100.0 / SUM(SUM(f.LineTotal)) OVER () AS RevenuePercentage
FROM fact_sales_view AS f
LEFT JOIN dim_products_view AS p ON f.ProductID = p.ProductID
GROUP BY p.Category
ORDER BY TotalRevenue DESC;

-- Let's check if revenue has actually been decreasing over the years
SELECT 
    YEAR(OrderDate) AS Year, 
    SUM(LineTotal) AS TotalRevenue,
    COUNT(DISTINCT MONTH(OrderDate)) AS ActiveMonths, -- Count months with sales
    SUM(LineTotal) / COUNT(DISTINCT MONTH(OrderDate)) AS AvgMonthlyRevenue
FROM fact_sales_view
GROUP BY YEAR(OrderDate)
ORDER BY Year;

--Let's take a look at it using the sales territory
SELECT 
    YEAR(f.OrderDate) AS Year, 
    d.TerritoryID, 
    d.[Name] AS TerritoryName,
    SUM(f.LineTotal) AS TotalRevenue,
    COUNT(DISTINCT MONTH(f.OrderDate)) AS ActiveMonths, 
    SUM(f.LineTotal) / NULLIF(COUNT(DISTINCT MONTH(f.OrderDate)), 0) AS AvgMonthlyRevenue
FROM fact_sales_view AS f
LEFT JOIN dim_sales_territory_view AS d ON f.TerritoryID = d.TerritoryID
GROUP BY YEAR(f.OrderDate), d.TerritoryID, d.[Name]
ORDER BY Year, TerritoryName;

-- Sales performance by territory
SELECT 
    dstv.Name AS Territory, 
    COUNT(fs.SalesOrderID) AS TotalOrders, 
    SUM(fs.LineTotal) AS TotalSales
FROM fact_sales_view fs
LEFT JOIN dim_sales_territory_view dstv ON fs.TerritoryID = dstv.TerritoryID
GROUP BY dstv.Name
ORDER BY TotalSales DESC;


--When Do Customers Spend the Most?
SELECT 
    MONTH(OrderDate) AS Month, 
    AVG(LineTotal) AS AvgRevenue
FROM fact_sales_view
GROUP BY MONTH(OrderDate)
ORDER BY AvgRevenue DESC;

--How long do customers stay
SELECT 
    c.CustomerID, 
    DATEDIFF(MONTH, MIN(f.OrderDate), MAX(f.OrderDate)) AS CustomerTenure,
    COUNT(DISTINCT f.SalesOrderID) AS TotalOrders,
    SUM(f.LineTotal) AS TotalRevenue
FROM fact_sales_view AS f
LEFT JOIN dim_customer_view AS c ON f.CustomerID = c.CustomerID
GROUP BY c.CustomerID
ORDER BY CustomerTenure DESC;


-- Identify the top Spending Customers by Total amount spent
WITH CustomerSpending AS (
							SELECT
								dcv.CustomerID,
								dcv.FirstName,
								dcv.LastName,
								dcv.YearlyIncome,
								dcv.Occupation,
								SUM(fsv.LineTotal) AS TotalSpent
							FROM fact_sales_view fsv
							LEFT JOIN dim_customer_view dcv ON fsv.CustomerID = dcv.CustomerID
							GROUP BY dcv.CustomerID, dcv.FirstName, dcv.LastName, dcv.YearlyIncome, dcv.Occupation
						 )
SELECT TOP (10) CustomerID, FirstName, LastName, YearlyIncome, Occupation, TotalSpent
FROM CustomerSpending
ORDER BY TotalSpent DESC


/* How many repeat purchases do customers make within a year, 
  and what is the average time between their orders? */
WITH CustomerOrders AS (
							SELECT
								CustomerID,
								SalesOrderID,
								OrderDate,
								LAG(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS PreviousOrder
							FROM fact_sales_view
						)
SELECT CustomerID,
    COUNT(SalesOrderID) AS TotalOrders,
    AVG(DATEDIFF(DAY, PreviousOrder, OrderDate)) AS AvgDaysBetweenOrders
FROM CustomerOrders
WHERE PreviousOrder IS NOT NULL
GROUP BY CustomerID
ORDER BY TotalOrders DESC;

-- Who are our top buyers?
SELECT c.Occupation, 
    COUNT(DISTINCT c.CustomerID) AS CustomerCount, 
    SUM(f.LineTotal) AS TotalRevenue,
    SUM(f.LineTotal) * 100.0 / SUM(SUM(f.LineTotal)) OVER () AS RevenuePercentage
FROM fact_sales_view AS f
LEFT JOIN dim_customer_view AS c ON f.CustomerID = c.CustomerID
GROUP BY  c.Occupation
ORDER BY TotalRevenue DESC;


