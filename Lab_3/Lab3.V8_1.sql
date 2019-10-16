

ALTER TABLE Igor_Shimansky.dbo.Address
	ADD PersonName NVARCHAR(100);
GO

DECLARE @AddressVariable TABLE
(
	ID INT NOT NULL,
    AddressID INT NOT NULL,
	AddressLine1 NVARCHAR(60) NOT NULL,
	AddressLine2 NVARCHAR(60) NULL,
	City NVARCHAR(30) NOT NULL,
	StateProvinceID INT NOT NULL,
	PostalCode NVARCHAR(15) NOT NULL,
	ModifiedDate DATETIME NOT NULL,
	PersonName NVARCHAR(100)
)

INSERT INTO
    @AddressVariable
    (
		ID,
        AddressID,
		AddressLine1,
		AddressLine2,
		City,
		StateProvinceID,
		PostalCode,
		ModifiedDate
    )
SELECT
	addr.ID,
    addr.AddressID,
	addr.AddressLine1,
	region.CountryRegionCode+','+province.Name+','+addr.City AS [text()],
	addr.City,
	addr.StateProvinceID,
	addr.PostalCode,
	addr.ModifiedDate
FROM
	Igor_Shimansky.dbo.Address AS addr
		INNER JOIN AdventureWorks2012.Person.StateProvince AS province
		ON addr.StateProvinceID = province.StateProvinceID
			INNER JOIN AdventureWorks2012.Person.CountryRegion AS region
			ON province.CountryRegionCode = region.CountryRegionCode
WHERE
	addr.StateProvinceID = 77
	
UPDATE Igor_Shimansky.dbo.Address 
SET 
	Igor_Shimansky.dbo.Address.AddressLine2 = addr.AddressLine2,
	Igor_Shimansky.dbo.Address.PersonName = person.FirstName+person.LastName 
FROM
	@AddressVariable AS addr
		INNER JOIN AdventureWorks2012.Person.BusinessEntityAddress AS bus
		ON bus.AddressID = addr.AddressID
			INNER JOIN AdventureWorks2012.Person.Person AS person
			ON person.BusinessEntityID = bus.BusinessEntityID
GO

DELETE Igor_Shimansky.dbo.Address
FROM
	Igor_Shimansky.dbo.Address AS addr
		INNER JOIN AdventureWorks2012.Person.BusinessEntityAddress AS bus
		ON bus.AddressID = addr.AddressID 
			INNER JOIN AdventureWorks2012.Person.AddressType AS typ
			ON bus.AddressTypeID = typ.AddressTypeID
WHERE typ.Name = 'Main Office'
GO

ALTER TABLE Igor_Shimansky.dbo.Address
DROP COLUMN PersonName

ALTER TABLE Igor_Shimansky.dbo.Address
DROP CONSTRAINT
    UC_ID,
    CH_StateProvinceID,
    DF_AddressLine2
GO

DROP TABLE
    Igor_Shimansky.dbo.Address
GO