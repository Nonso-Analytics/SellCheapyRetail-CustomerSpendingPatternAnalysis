DROP VIEW IF EXISTS dim_sales_territory_view

GO

CREATE VIEW dim_sales_territory_view AS

-- Cleansed dim_sales_territory Table --
SELECT TerritoryID
      ,Name
      ,CountryRegionCode
      ,Group
      ,SalesYTD
      ,SalesLastYear
      ,CostYTD
      ,CostLastYear
      
FROM AdventureWorks2019.Sales.SalesTerritory
