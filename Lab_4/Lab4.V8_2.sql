USE AdventureWorks2012;
GO

CREATE VIEW Person.TerritoryView
WITH SCHEMABINDING
AS
SELECT 
	country.CountryRegionCode,
	country.Name AS CountryName,
	sales.TerritoryID,
	sales.Name AS SalesName,
	sales.[Group],
	sales.SalesYTD,
	sales.SalesLastYear,
	sales.CostYTD,
	sales.CostLastYear
FROM Person.CountryRegion AS country
INNER JOIN Sales.SalesTerritory AS sales
	ON country.CountryRegionCode = sales.CountryRegionCode
GO

CREATE UNIQUE CLUSTERED INDEX IX_TerritoryID
	ON Person.TerritoryView (TerritoryID)
GO

CREATE TRIGGER InsteadTerritoryViewTrigger ON Person.TerritoryView
	INSTEAD OF INSERT, UPDATE, DELETE
AS
BEGIN
	DECLARE @CountryRegionCode NVARCHAR(3);

	IF NOT EXISTS (SELECT * FROM inserted)
		BEGIN --DELETE
			SELECT @CountryRegionCode = deleted.CountryRegionCode FROM deleted;

			DELETE
			FROM Sales.SalesTerritory
			WHERE CountryRegionCode = @CountryRegionCode;
			
			DELETE 
			FROM Person.CountryRegion
			WHERE CountryRegionCode = @CountryRegionCode
		END;
	ELSE IF NOT EXISTS (SELECT * FROM deleted)
		BEGIN --INSERT
			IF NOT EXISTS (
				SELECT * 
				FROM Person.CountryRegion AS country 
				JOIN inserted 
					ON inserted.CountryRegionCode = country.CountryRegionCode)
			BEGIN
				INSERT INTO Person.CountryRegion (
					CountryRegionCode,
					Name,
					ModifiedDate)
				SELECT 
					CountryRegionCode,
					CountryName,
					GETDATE()
				FROM inserted
			END
			ELSE
				UPDATE
				    Person.CountryRegion
				SET
				    Name = inserted.CountryName,
				    ModifiedDate = GETDATE()
				FROM
				    inserted
				WHERE
				    Person.CountryRegion.CountryRegionCode = inserted.CountryRegionCode

			INSERT INTO Sales.SalesTerritory(
				Name,
				CountryRegionCode,
				[Group],
				SalesYTD,
				SalesLastYear,
				CostYTD,
				CostLastYear,
				ModifiedDate)
			SELECT 
				SalesName,
				CountryRegionCode,
				[Group],
				SalesYTD,
				SalesLastYear,
				CostYTD,
				CostLastYear,
				GETDATE()
			FROM inserted
		END;
	ELSE
		BEGIN --UPDATE
			UPDATE Person.CountryRegion
			SET 
				Name = inserted.CountryName,
				ModifiedDate = GETDATE()
			FROM Person.CountryRegion AS country
			JOIN inserted 
				ON inserted.CountryRegionCode = country.CountryRegionCode

			UPDATE Sales.SalesTerritory
			SET 
				Name= inserted.SalesName,
				[Group]= inserted.[Group],
				SalesYTD= inserted.SalesYTD,
				SalesLastYear= inserted.SalesLastYear,
				CostYTD= inserted.CostYTD,
				CostLastYear= inserted.CostLastYear,
				ModifiedDate= GETDATE()
			FROM Sales.SalesTerritory AS sales
			JOIN inserted 
				ON inserted.TerritoryID = sales.TerritoryID
		END;
END;

INSERT INTO Person.TerritoryView(
	CountryRegionCode,
	CountryName,
	TerritoryID,
	SalesName,
	[Group],
	SalesYTD,
	SalesLastYear,
	CostYTD,
	CostLastYear)
VALUES('MOL', 'Molodechno', 123456, 'TEST1', 'TEST1', 1, 1, 1, 1)
GO

UPDATE Person.TerritoryView
SET	
	CountryName= 'MOOOlodechno',
	[Group]='TEST2',
	SalesLastYear = 2
WHERE CountryRegionCode = 'MOL'
GO

DELETE 
FROM Person.TerritoryView
WHERE CountryRegionCode = 'MOL'
GO
