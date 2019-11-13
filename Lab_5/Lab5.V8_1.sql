USE AdventureWorks2012;
GO


CREATE FUNCTION Production.getSubcategoryAmount (@subcategoryID INT)
RETURNS INT AS 
BEGIN
	DECLARE @productAmount INT

	SELECT @productAmount = COUNT(*) 
	FROM Production.Product AS product
	WHERE product.ProductSubcategoryID = @subcategoryID

	RETURN @productAmount
END
GO


CREATE FUNCTION
    Production.getSubcategoryList(@subcategoryID INT)
RETURNS
    TABLE
AS
RETURN
	(SELECT
        *
    FROM
        Production.Product AS product
    WHERE
        product.ProductSubcategoryID = @subcategoryID AND product.StandardCost > 1000)
GO


SELECT * FROM Production.ProductSubcategory
CROSS APPLY Production.getSubcategoryList(ProductSubcategory.ProductSubcategoryID)
GO

SELECT * FROM Production.ProductSubcategory
OUTER APPLY Production.getSubcategoryList(ProductSubcategory.ProductSubcategoryID)
GO


DROP FUNCTION
    Production.getSubcategoryList
GO

CREATE FUNCTION
    Production.getSubcategoryList(@subcategoryID INT)
RETURNS
    @SubcategoryList TABLE
    (
        ProductID INT,
		Name NVARCHAR(50),
		ProductNumber NVARCHAR(20),
		MakeFlag BIT,
		FinishedGoodsFlag BIT,
		Color NVARCHAR(15),
		SafetyStockLevel SMALLINT,
		ReorderPoint SMALLINT,
		StandardCost MONEY,
		ListPrice MONEY,
		Size NVARCHAR(5),
		SizeUnitMeasureCode NCHAR(5),
		Weight DECIMAL(8,2),
		DaysToManufacture INT,
		ProductLine NCHAR(2),
		Class NCHAR(2),
		Style NCHAR(2),
		ProductSubcategoryID INT,
		ProductModelID INT,
		SellStartDate DATETIME,
		SellEndDate DATETIME,
		DiscontinuedDate DATETIME,
        ModifiedDate DATETIME
    )
AS
BEGIN
    INSERT INTO
        @SubcategoryList
        (
            ProductID,
			Name,
			ProductNumber,
			MakeFlag,
			FinishedGoodsFlag,
			Color,
			SafetyStockLevel,
			ReorderPoint,
			StandardCost,
			ListPrice,
			Size,
			SizeUnitMeasureCode,
			Weight,
			DaysToManufacture,
			ProductLine,
			Class,
			Style,
			ProductSubcategoryID,
			ProductModelID,
			SellStartDate,
			SellEndDate,
			DiscontinuedDate,
            ModifiedDate
        )
    SELECT
			ProductID,
			Name,
			ProductNumber,
			MakeFlag,
			FinishedGoodsFlag,
			Color,
			SafetyStockLevel,
			ReorderPoint,
			StandardCost,
			ListPrice,
			Size,
			SizeUnitMeasureCode,
			Weight,
			DaysToManufacture,
			ProductLine,
			Class,
			Style,
			ProductSubcategoryID,
			ProductModelID,
			SellStartDate,
			SellEndDate,
			DiscontinuedDate,
            ModifiedDate
    FROM
        Production.Product AS product
    WHERE
        product.ProductSubcategoryID = @subcategoryID AND product.StandardCost > 1000
    RETURN
END
GO