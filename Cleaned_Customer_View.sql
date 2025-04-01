DROP VIEW IF EXISTS dim_customer_view

GO

CREATE VIEW dim_customer_view AS
-- extract (shred) values from XML column nodes using XQuery nodes() method
WITH XMLNAMESPACES ('http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey' AS ns)
SELECT	ps.CustomerID,
   FirstName, 
   MiddleName,
   LastName,
   C.value('ns:Occupation[1]','varchar(50)') AS Occupation,
   C.value('ns:Education[1]','varchar(50)') AS Education,
   C.value('ns:Gender[1]','varchar(50)') AS Gender,
   C.value('ns:YearlyIncome[1]','varchar(50)') AS YearlyIncome,
   C.value('ns:TotalPurchaseYTD[1]','float') AS TotalPurchaseYTD,
   C.value('ns:HomeOwnerFlag[1]','bit') AS HomeOwnerFlag,
   C.value('ns:NumberCarsOwned[1]','int') AS NumberCarsOwned,
   pb.BusinessEntityID,
   pa.AddressID,
   pa.City,
   psp.StateProvinceID,
   psp.Name AS StateProvinceName,---Aliasing to be more descriptive and also because i can't return two columns with same name in SQL
   psp.TerritoryID,
   pcr.CountryRegionCode,
   pcr.Name AS CountryName,
   pea.EmailAddress
FROM [AdventureWorks2019].Person.Person as p
CROSS APPLY Demographics.nodes('/ns:IndividualSurvey') AS T(C)
LEFT JOIN AdventureWorks2019.Sales.Customer AS ps ON p.BusinessEntityID = ps.PersonID
LEFT JOIN AdventureWorks2019.Person.BusinessEntityAddress AS pb ON ps.PersonID  = pb.BusinessEntityID
LEFT JOIN AdventureWorks2019.Person.Address AS pa ON pb.AddressID = pa.AddressID
LEFT JOIN AdventureWorks2019.Person.StateProvince AS psp ON pa.StateProvinceID = psp.StateProvinceID
LEFT JOIN AdventureWorks2019.Person.CountryRegion AS pcr ON psp.CountryRegionCode = pcr.CountryRegionCode
LEFT JOIN AdventureWorks2019.Person.EmailAddress AS pea ON pb.BusinessEntityID = pea.BusinessEntityID
WHERE PersonType = 'IN'
	

GO 
