
DROP VIEW IF EXISTS dim_products_view;

GO

CREATE VIEW dim_products_view AS

-- Cleansed DIM_Products Table --
SELECT p.[ProductID] 
  ,p.[Name] AS Product
  ,p.[ProductNumber] AS [Product Number]
  ,p.[MakeFlag]
  ,p.[FinishedGoodsFlag]
  ,ISNULL (p.[Color], 'Unknown') AS Color
  ,p.[StandardCost] AS [Standard Cost]
  ,p.[ListPrice] AS [List Price]
  ,ISNULL(p.[Size],'Unknown') AS Size
  ,p.[Weight]
  ,p.[DaysToManufacture]
  ,p.[ProductLine] AS [Product Line]
  ,p.[Class]
  ,p.[Style]
  ,p.[SellStartDate]
  ,p.[SellEndDate]
  ,p.[DiscontinuedDate]
  ,ps.[Name] AS SubCategory -- Joined in from ProductSubCategory Table
  ,pc.[Name] AS Category -- Joined in from ProductCategory Table 
	  
      
FROM [AdventureWorks2019].[Production].[Product] AS p
  LEFT JOIN [AdventureWorks2019].[Production].[ProductSubcategory] AS ps ON ps.ProductSubcategoryID = p.ProductSubcategoryID
  LEFT JOIN [AdventureWorks2019].[Production].[ProductCategory] AS pc ON ps.ProductCategoryID = pc.ProductCategoryID
ORDER BY
  p.ProductID ASC
