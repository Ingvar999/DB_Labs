USE AdventureWorks2012;
GO

DROP PROCEDURE dbo.WorkOrdersByMonths
GO

CREATE PROCEDURE dbo.WorkOrdersByMonths
    @months NVARCHAR(100)
AS
	DECLARE @query NVARCHAR(1024);
	SET @query = 'SELECT Year,' + @months + '
	FROM
	(
		SELECT
		    YEAR(WorkOrder.DueDate) AS Year,
		    DATENAME(MONTH, WorkOrder.DueDate) AS MonthName,
			WorkOrder.OrderQty AS Cost
		FROM
		    Production.WorkOrder
	) AS source
	PIVOT
	(
	    SUM(Cost)
	    FOR MonthName
	    IN (' + @months + ')
	) AS PivotTable'

	EXEC sp_executesql @query
GO

EXECUTE dbo.WorkOrdersByMonths '[January],[February],[March],[April],[May],[June]'