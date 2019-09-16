CREATE DATABASE Igor_Shimansky;
GO

USE Igor_Shimansky;
GO

CREATE SCHEMA sales;
GO

CREATE SCHEMA persons;
GO

CREATE TABLE sales.Orders (
	OrderNum INT NULL);
GO

BACKUP DATABASE Igor_Shimansky
TO DISK = 'D://Igor_Shimansky.bak'
WITH
	NAME = 'Igor_Shimansky.bak'; 
GO

USE master;
GO

DROP DATABASE Igor_Shimansky;
GO

RESTORE DATABASE Igor_Shimansky   
FROM DISK = 'D://Igor_Shimansky.bak'   
	WITH 
		FILE=1, 
		RECOVERY; 
GO

USE Igor_Shimansky;
GO

