DROP VIEW IF EXISTS fact_sales_view

GO

CREATE VIEW fact_sales_view AS

-- Cleansed fact_sales Table --
SELECT p.[ProductID] 
  ,p.[SalesOrderID]
  ,p.[SalesOrderDetailID]
  ,p.[SpecialOfferID]
  ,p.[OrderQty]
  ,p.[UnitPrice]
  ,p.[UnitPriceDiscount]
  ,p.[LineTotal]
  ,p.[rowguid]
  ,p.[ModifiedDate]
  
  ,ps.[CustomerID] -- Joined in from SalesOrderHeader Table
  ,ps.[TerritoryID] -- Joined in from SalesOrderHeader Table
  ,ps.[SalesOrderNumber] -- Joined in from SalesOrderHeader Table
  ,ps.[OrderDate] -- Joined in from SalesOrderHeader Table
	  
      
FROM [AdventureWorks2019].[Sales].[SalesOrderDetail] AS p
INNER JOIN [AdventureWorks2019].[Sales].[SalesOrderHeader] AS ps ON p.[SalesOrderID] = ps.[SalesOrderID]
INNER JOIN dim_customer_view AS dcv ON ps.CustomerID = dcv.CustomerID
ORDER BY
  p.SalesOrderID ASC
