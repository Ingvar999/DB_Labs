USE AdventureWorks2012;
GO

SELECT [BusinessEntityID]
     ,[BirthDate]
     ,[MaritalStatus] 
	 ,[Gender]
	 ,[HireDate]
FROM [AdventureWorks2012].[HumanResources].[Employee] 
WHERE MaritalStatus ='S' 
AND YEAR(BirthDate) <= 1960 
GO

SELECT [BusinessEntityID]
	 ,[JobTitle]
     ,[BirthDate]
	 ,[Gender]
	 ,[HireDate]
FROM [AdventureWorks2012].[HumanResources].[Employee] 
WHERE JobTitle ='Design Engineer' 
ORDER BY HireDate DESC
GO

SELECT [BusinessEntityID]
	 ,[DepartmentID]
     ,[StartDate]
	 ,[EndDate]S
	 ,YEAR(ISNULL(EndDate, GETDATE())) - YEAR(StartDate) AS 'YearsWorked'
FROM [AdventureWorks2012].[HumanResources].[EmployeeDepartmentHistory] 
WHERE DepartmentID = 1
GO
 
  