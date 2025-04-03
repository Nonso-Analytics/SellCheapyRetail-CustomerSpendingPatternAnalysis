-- Let's see the products customers often purchase together
WITH ProductPairs AS (
    SELECT 
        f1.ProductID AS ProductA, 
        f2.ProductID AS ProductB, 
        COUNT(*) AS PurchaseCount
    FROM fact_sales_view f1
    JOIN fact_sales_view f2 
        ON f1.SalesOrderID = f2.SalesOrderID -- Ensure products are in the same order
        AND f1.ProductID < f2.ProductID -- Prevent self-joins and duplicates
    GROUP BY f1.ProductID, f2.ProductID
)
SELECT TOP(10)
    p1.Product AS ProductA, 
    p2.Product AS ProductB, 
    pp.PurchaseCount
FROM ProductPairs pp
JOIN dim_products_view p1 ON pp.ProductA = p1.ProductID
JOIN dim_products_view p2 ON pp.ProductB = p2.ProductID
ORDER BY pp.PurchaseCount DESC;

-- what is our customer rentention rate, is it meeting industry standards of at least 70%
WITH FirstPurchase AS (
    SELECT CustomerID, MIN(OrderDate) AS FirstOrder
    FROM fact_sales_view
    GROUP BY CustomerID
),
RepeatCustomers AS (
    SELECT DISTINCT f.CustomerID
    FROM fact_sales_view f
    JOIN FirstPurchase fp ON f.CustomerID = fp.CustomerID
    WHERE f.OrderDate > DATEADD(YEAR, 1, fp.FirstOrder) -- Customers who bought again after 1 year
)
SELECT 
    COUNT(DISTINCT rc.CustomerID) * 100.0 / COUNT(DISTINCT f.CustomerID) AS RetentionRate
FROM fact_sales_view f
LEFT JOIN RepeatCustomers rc ON f.CustomerID = rc.CustomerID;


