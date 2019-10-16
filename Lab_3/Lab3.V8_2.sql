

ALTER TABLE Igor_Shimansky.dbo.Address
ADD
    AccountNumber NVARCHAR(15),
    MaxPrice MONEY,
    AccountID AS 'ID'+AccountNumber
GO

--DROP TABLE #Address

CREATE TABLE #Address (
	ID INT NOT NULL PRIMARY KEY,
	AddressID INT NOT NULL,
	AddressLine1 NVARCHAR(60) NOT NULL,
	AddressLine2 NVARCHAR(60) NULL,
	City NVARCHAR(30) NOT NULL,
	StateProvinceID INT NOT NULL,
	PostalCode NVARCHAR(15) NOT NULL,
	ModifiedDate DATETIME NOT NULL,
	AccountNumber NVARCHAR(15),
    MaxPrice MONEY
)
GO

WITH Price_CTE (BusinessEntityID, MaxPrice)
AS
(
    SELECT
        BusinessEntityID,
        MAX(StandardPrice) AS MaxPrice
    FROM
        AdventureWorks2012.Purchasing.ProductVendor
    GROUP BY
        BusinessEntityID
)
INSERT INTO
    #Address
    (
		ID,
        AddressID,
		AddressLine1,
		AddressLine2,
		City,
		StateProvinceID,
		PostalCode,
		ModifiedDate,
		AccountNumber,
		MaxPrice
    )
SELECT
	addr.ID,
    addr.AddressID,
	addr.AddressLine1,
	addr.AddressLine2,
	addr.City,
	addr.StateProvinceID,
	addr.PostalCode,
	addr.ModifiedDate,
	vendor.AccountNumber,
	Price_CTE.MaxPrice
FROM
	Igor_Shimansky.dbo.Address AS addr
		INNER JOIN AdventureWorks2012.Person.BusinessEntityAddress AS bus
		ON bus.AddressID = addr.AddressID
			INNER JOIN AdventureWorks2012.Purchasing.Vendor AS vendor
			ON vendor.BusinessEntityID = bus.BusinessEntityID
				INNER JOIN Price_CTE
				ON vendor.BusinessEntityID = Price_CTE.BusinessEntityID
GO

DELETE FROM Igor_Shimansky.dbo.Address
WHERE ID = 293
GO

MERGE Igor_Shimansky.dbo.Address AS TARGET
USING #Address AS source
ON (TARGET.ID = source.ID)
WHEN MATCHED THEN
	UPDATE 
	SET AccountNumber  = source.AccountNumber,
		MaxPrice = source.MaxPrice
WHEN NOT MATCHED BY TARGET THEN
	INSERT
    (
        AddressID,
		AddressLine1,
		AddressLine2,
		City,
		StateProvinceID,
		PostalCode,
		ModifiedDate,
		AccountNumber,
		MaxPrice
    )
    VALUES
    (
        AddressID,
		AddressLine1,
		AddressLine2,
		City,
		StateProvinceID,
		PostalCode,
		ModifiedDate,
		AccountNumber,
		MaxPrice
    )
WHEN NOT MATCHED BY SOURCE THEN
	DELETE;
GO