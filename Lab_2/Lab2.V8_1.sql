USE AdventureWorks2012;
GO

SELECT employ.BusinessEntityID, employ.OrganizationLevel, employ.JobTitle, job.JobCandidateID, job.Resume
FROM HumanResources.Employee AS employ
INNER JOIN HumanResources.JobCandidate AS job ON employ.BusinessEntityID = job.BusinessEntityID
WHERE job.Resume IS NOT NULL 
GO

SELECT depart.DepartmentID, depart.Name, COUNT(*) AS EmpCount
FROM HumanResources.Department AS depart
INNER JOIN HumanResources.EmployeeDepartmentHistory AS hist ON depart.DepartmentID = hist.DepartmentID
WHERE hist.EndDate IS NULL
GROUP BY depart.DepartmentID, depart.Name
HAVING COUNT(*) > 10
GO

SELECT dep.Name, employ.HireDate, employ.SickLeaveHours, 
SUM(employ.SickLeaveHours) OVER (PARTITION BY dep.Name ORDER BY employ.HireDate) AS AccumulativeSum
FROM HumanResources.Employee AS employ
INNER JOIN (
	SELECT hist.BusinessEntityID, depart.Name
	FROM HumanResources.EmployeeDepartmentHistory AS hist
	INNER JOIN HumanResources.Department AS depart ON hist.DepartmentID = depart.DepartmentID
	WHERE hist.EndDate IS NULL
) AS dep ON dep.BusinessEntityID = employ.BusinessEntityID
ORDER BY dep.Name
GO
