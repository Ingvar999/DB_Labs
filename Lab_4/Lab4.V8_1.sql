USE AdventureWorks2012;
GO

CREATE TABLE Person.CountryRegionHst (
	ID INT IDENTITY(1, 1) PRIMARY KEY,
	Action NVARCHAR(20) CHECK(Action IN ('INSERT', 'UPDATE', 'DELETE')),
	ModifiedDate DATETIME NOT NULL,
	SourceID NVARCHAR(30) NOT NULL,
	UserName NVARCHAR(50)
);
GO

CREATE TRIGGER CountryRegionAfterInsert ON Person.CountryRegion
FOR INSERT
AS
	DECLARE @sourceID NVARCHAR(30);
	SELECT @sourceID = inserted.Name FROM inserted;

	INSERT INTO Person.CountryRegionHst(Action, ModifiedDate, SourceID, UserName)
	VALUES('INSERT', GETDATE(), @sourceID, CURRENT_USER);
GO

CREATE TRIGGER CountryRegionAfterUpdate ON Person.CountryRegion
FOR UPDATE
AS
	DECLARE @sourceID NVARCHAR(30);
	SELECT @sourceID = inserted.Name FROM inserted;

	INSERT INTO Person.CountryRegionHst(Action, ModifiedDate, SourceID, UserName)
	VALUES('UPDATE', GETDATE(), @sourceID, CURRENT_USER);
GO

CREATE TRIGGER CountryRegionAfterDelete ON Person.CountryRegion
FOR DELETE
AS
	DECLARE @sourceID NVARCHAR(30);
	SELECT @sourceID = deleted.Name FROM deleted;

	INSERT INTO Person.CountryRegionHst(Action, ModifiedDate, SourceID, UserName)
	VALUES('DELETE', GETDATE(), @sourceID, CURRENT_USER);
GO

CREATE VIEW Person.ViewCountryRegion
WITH ENCRYPTION 
AS SELECT * FROM Person.CountryRegion;
GO

INSERT INTO Person.ViewCountryRegion(CountryRegionCode, Name, ModifiedDate)
	VALUES('MOL', 'mOLODECHNO', GETDATE())
GO

UPDATE Person.ViewCountryRegion
	SET ModifiedDate= GETDATE(), Name= 'Molodechno'
	WHERE CountryRegionCode='MOL'
GO

DELETE FROM Person.ViewCountryRegion
	WHERE CountryRegionCode='MOL'
GO

SELECT * FROM Person.CountryRegionHst
GO