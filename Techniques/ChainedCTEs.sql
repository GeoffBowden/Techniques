USE AdventureWorks2025;
GO

;WITH femaleEmployees 
(
	NationalIDNumber ,
	BusinessEntityID, 
	OrganizationNode,
	Gender 
)
AS
(
	SELECT 
		NationalIDNumber, 
		BusinessEntityID, 
		OrganizationNode,
		Gender 
	FROM
		HumanResources.Employee
	WHERE
		Gender = N'F'
),
maleEmployees 
(
	NationalIDNumber,
	BusinessEntityID, 
	OrganizationNode,
	Gender
)
AS
(
	SELECT
		NationalIDNumber,
		BusinessEntityID, 
		OrganizationNode,
		Gender
	FROM	
		HumanResources.Employee
	WHERE
		Gender = 'M'
)
SELECT 
	*
FROM
	femaleEmployees
UNION
SELECT
	*
FROM
	maleEmployees