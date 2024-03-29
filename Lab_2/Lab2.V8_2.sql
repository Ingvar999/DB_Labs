USE Igor_Shimansky
GO

CREATE TABLE Address (
	AddressID INT NOT NULL,
	AddressLine1 NVARCHAR(60) NOT NULL,
	AddressLine2 NVARCHAR(60) NULL,
	City NVARCHAR(30) NOT NULL,
	StateProvinceID INT NOT NULL,
	PostalCode NVARCHAR(15) NOT NULL,
	ModifiedDate DATETIME NOT NULL
)
GO

ALTER TABLE Address
	ADD ID INT IDENTITY(1,1)

ALTER TABLE Address
	ADD CONSTRAINT UC_ID UNIQUE (ID)
GO

ALTER TABLE Address
	ADD CONSTRAINT CH_StateProvinceID CHECK(StateProvinceID % 2 = 1)
GO

ALTER TABLE Address
	ADD CONSTRAINT DF_AddressLine2 DEFAULT 'Unknown' FOR AddressLine2
GO

INSERT INTO Address (
	AddressID,
	AddressLine1,
	City,
	StateProvinceID,
	PostalCode,
	ModifiedDate
)
SELECT 	
		adr.AddressID,
		adr.AddressLine1,
		adr.City,
		adr.StateProvinceID,
		adr.PostalCode,
		adr.ModifiedDate
	FROM AdventureWorks2012.Person.Address AS adr
	INNER JOIN (
		SELECT province.StateProvinceID, region.Name
		FROM AdventureWorks2012.Person.CountryRegion AS region
		INNER JOIN AdventureWorks2012.Person.StateProvince AS province
		ON province.CountryRegionCode = region.CountryRegionCode 
	) AS reg
	ON reg.StateProvinceID = adr.StateProvinceID
	WHERE SUBSTRING(reg.Name, 1, 1) = 'a' AND adr.StateProvinceID % 2 = 1
GO

ALTER TABLE Address
	ALTER COLUMN AddressLine2 NVARCHAR(60) NOT NULL
GO
