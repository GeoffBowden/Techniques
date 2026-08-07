/*

*/

SELECT 
	OrderYear, [1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]
FROM
	(
		SELECT
			MONTH( OrderDate ) AS OrderMonth, YEAR( OrderDate ) AS OrderYear, soh.TotalDue AS Due
		FROM
			Sales.SalesOrderHeader soh
		WHERE
			OrderDate > '2022-01-31T00:00:00.000'
	) AS MonthTotals
	PIVOT(sum( Due ) FOR OrderMonth in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])) as P
ORDER BY
	OrderYear 


SELECT
	Years.OrderYear
,	(	SELECT
			SUM( soh.TotalDue ) AS Due
		FROM
			Sales.SalesOrderHeader soh
		WHERE
			MONTH( OrderDate ) = 1
		AND YEAR( OrderDate ) = Years.OrderYear ) AS [1]
,	(	SELECT
			SUM( soh.TotalDue ) AS Due
		FROM
			Sales.SalesOrderHeader soh
		WHERE
			MONTH( OrderDate ) = 2
		AND YEAR( OrderDate ) = Years.OrderYear ) AS [2]
,	(	SELECT
			SUM( soh.TotalDue ) AS Due
		FROM
			Sales.SalesOrderHeader soh
		WHERE
			MONTH( OrderDate ) = 3
		AND YEAR( OrderDate ) = Years.OrderYear ) AS [3]
,	(	SELECT
			SUM( soh.TotalDue ) AS Due
		FROM
			Sales.SalesOrderHeader soh
		WHERE
			MONTH( OrderDate ) = 4
		AND YEAR( OrderDate ) = Years.OrderYear ) AS [4]
,	(	SELECT
			SUM( soh.TotalDue ) AS Due
		FROM
			Sales.SalesOrderHeader soh
		WHERE
			MONTH( OrderDate ) = 5
		AND YEAR( OrderDate ) = Years.OrderYear ) AS [5]
,	(	SELECT
			SUM( soh.TotalDue ) AS Due
		FROM
			Sales.SalesOrderHeader soh
		WHERE
			MONTH( OrderDate ) = 6
		AND YEAR( OrderDate ) = Years.OrderYear ) AS [6]
,	(	SELECT
			SUM( soh.TotalDue ) AS Due
		FROM
			Sales.SalesOrderHeader soh
		WHERE
			MONTH( OrderDate ) = 7
		AND YEAR( OrderDate ) = Years.OrderYear ) AS [7]
,	(	SELECT
			SUM( soh.TotalDue ) AS Due
		FROM
			Sales.SalesOrderHeader soh
		WHERE
			MONTH( OrderDate ) = 8
		AND YEAR( OrderDate ) = Years.OrderYear ) AS [8]
,	(	SELECT
			SUM( soh.TotalDue ) AS Due
		FROM
			Sales.SalesOrderHeader soh
		WHERE
			MONTH( OrderDate ) = 9
		AND YEAR( OrderDate ) = Years.OrderYear ) AS [9]
,	(	SELECT
			SUM( soh.TotalDue ) AS Due
		FROM
			Sales.SalesOrderHeader soh
		WHERE
			MONTH( OrderDate ) = 10
		AND YEAR( OrderDate ) = Years.OrderYear ) AS [10]
,	(	SELECT
			SUM( soh.TotalDue ) AS Due
		FROM
			Sales.SalesOrderHeader soh
		WHERE
			MONTH( OrderDate ) = 11
		AND YEAR( OrderDate ) = Years.OrderYear ) AS [11]
,	(	SELECT
			SUM( soh.TotalDue ) AS Due
		FROM
			Sales.SalesOrderHeader soh
		WHERE
			MONTH( OrderDate ) = 12
		AND YEAR( OrderDate ) = Years.OrderYear ) AS [12]
FROM
	(
		SELECT	
			YEAR( OrderDate ) as OrderYear
		FROM
			Sales.SalesOrderHeader
		GROUP BY 
			YEAR( OrderDate )
	) AS Years
Order By
	Years.OrderYear 



SELECT
	*
FROM
	Person.Person pers
	INNER JOIN Person.PersonPhone pp ON pp.BusinessEntityID = pers.BusinessEntityID
	INNER JOIN Person.PhoneNumberType pnt ON pp.PhoneNumberTypeID = pnt.PhoneNumberTypeID
WHERE
	pers.LastName = 'Abercrombie'
Order by lastname


SELECT
	pers.BusinessEntityID
,	pers.FirstName
,	pers.LastName
,	COUNT( pp.PhoneNumber )
FROM
	Person.Person pers
	INNER JOIN Person.PersonPhone pp ON pp.BusinessEntityID = pers.BusinessEntityID
GROUP BY
	pers.BusinessEntityID, pers.FirstName, pers.LastName 
HAVING 
	COUNT( pp.PhoneNumber ) > 1
