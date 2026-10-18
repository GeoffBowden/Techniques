USE	AdventureWorks2025;
GO

DECLARE @EmployeeID Integer = 25;

;WITH managers 
AS
(
	SELECT 
		OrganizationLevel, 
		OrganizationNode,
		BusinessEntityID, 
		JobTitle, 
		NationalIDNumber
	FROM
		HumanResources.Employee
	WHERE
		BusinessEntityID = @EmployeeID
	UNION ALL
	SELECT 
		e.OrganizationLevel, 
		e.OrganizationNode,
		e.BusinessEntityID, 
		e.JobTitle, 
		e.NationalIDNumber
	FROM
		managers m
		INNER JOIN HumanResources.Employee e ON e.OrganizationNode.IsDescendantOf(m.OrganizationNode) = 1
	WHERE
		e.OrganizationNode IS NOT NULL
	AND e.BusinessEntityID <> m.BusinessEntityID
)
SELECT TOP 10
	*
FROM
	managers


