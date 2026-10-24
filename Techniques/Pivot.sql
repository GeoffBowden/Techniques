/*
Why use PIVOT?

Without PIVOT:
Plain Text Results are in rows, one for each month and year
2023 | 1 | 12345
2023 | 2 | 45678

With PIVOT:
Plain Text Results have a row for each year and the months are column headers
2023 | 12345 | 45678 | ...

This format is often better for reports and spreadsheets.
*/
use [AdventureWorks2025]

/*
    PIVOT Example

    Goal:
    Produce a sales report showing total sales for each month,
    with one row per year.

    The source data contains one row per order.

    Example source:

        Year    Month   Due
        ----    -----   ------
        2023      1     100
        2023      1     200
        2023      2     300

    Desired output:

        Year    Jan   Feb   Mar ...
        ----    ---   ---   ---
        2023    300   300
*/

USE AdventureWorks2025;

SELECT
    OrderYear,
    [1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]
FROM
	(
		/*
			Create a simple dataset consisting of:

			- Month number
			- Year number
			- Order value

			Every order becomes one row.
		*/
		SELECT
			MONTH(OrderDate) AS OrderMonth, -- Extract month (1-12)
			YEAR(OrderDate) AS OrderYear,   -- Extract year
			soh.TotalDue AS Due             -- Value of the order
		FROM 
			Sales.SalesOrderHeader soh
		WHERE 
			OrderDate > '2022-01-31'
	) AS MonthTotals

	/*
		PIVOT rotates row values into columns.

		The month numbers 1-12 become column headings.

		SUM(Due) aggregates all orders belonging
		to the same month/year combination.
	*/
	PIVOT
	(
		SUM(Due)
		FOR OrderMonth IN
		(
			[1],[2],[3],[4],[5],[6],
			[7],[8],[9],[10],[11],[12]
		)
	) AS P

ORDER BY 
	OrderYear;

/*
    Alternative implementation of the previous report.

Monthly Sales Report Using Correlated Subqueries

    Goal:
    Produce a report showing total sales for each month,
    with a single row per year.

    Sample output:

    Year      Jan      Feb      Mar ...
    -----  -------- -------- --------
    2022    123456   234567   345678
    2023    456789   567890   678901

    This approach uses one correlated subquery per month.

    A correlated subquery is a query that references a value
    from the outer query.

    In this case:

        Years.OrderYear

    comes from the outer query and is used by each subquery
    to calculate totals for that specific year.

    This works but is less efficient because SQL Server
    may need to repeatedly access SalesOrderHeader.

    Why is this interesting?

    It shows how reports were often written before developers discovered PIVOT.

    The result is identical, but the PIVOT version is:

    Easier to maintain
    Shorter
    Usually easier for SQL Server to optimise
*/

SELECT
    Years.OrderYear,

    /*
        Total sales for January of the current year

        This is a correlated subquery because it references
        Years.OrderYear from the outer query.
    */
    
    (
        SELECT SUM(soh.TotalDue)
        FROM Sales.SalesOrderHeader soh
        WHERE MONTH(soh.OrderDate) = 1
          AND YEAR(soh.OrderDate) = Years.OrderYear
    ) AS [1],

    /* Total sales for February of the current year */
    (
        SELECT SUM(soh.TotalDue)
        FROM Sales.SalesOrderHeader soh
        WHERE MONTH(soh.OrderDate) = 2
          AND YEAR(soh.OrderDate) = Years.OrderYear
    ) AS [2],

    /* Total sales for March of the current year */
    (
        SELECT SUM(soh.TotalDue)
        FROM Sales.SalesOrderHeader soh
        WHERE MONTH(soh.OrderDate) = 3
          AND YEAR(soh.OrderDate) = Years.OrderYear
    ) AS [3],

    /* Total sales for April of the current year */
    (
        SELECT SUM(soh.TotalDue)
        FROM Sales.SalesOrderHeader soh
        WHERE MONTH(soh.OrderDate) = 4
          AND YEAR(soh.OrderDate) = Years.OrderYear
    ) AS [4],

    /* Total sales for May of the current year */
    (
        SELECT SUM(soh.TotalDue)
        FROM Sales.SalesOrderHeader soh
        WHERE MONTH(soh.OrderDate) = 5
          AND YEAR(soh.OrderDate) = Years.OrderYear
    ) AS [5],

    /* Total sales for June of the current year */
    (
        SELECT SUM(soh.TotalDue)
        FROM Sales.SalesOrderHeader soh
        WHERE MONTH(soh.OrderDate) = 6
          AND YEAR(soh.OrderDate) = Years.OrderYear
    ) AS [6],

    /* Total sales for July of the current year */
    (
        SELECT SUM(soh.TotalDue)
        FROM Sales.SalesOrderHeader soh
        WHERE MONTH(soh.OrderDate) = 7
          AND YEAR(soh.OrderDate) = Years.OrderYear
    ) AS [7],

    /* Total sales for August of the current year */
    (
        SELECT SUM(soh.TotalDue)
        FROM Sales.SalesOrderHeader soh
        WHERE MONTH(soh.OrderDate) = 8
          AND YEAR(soh.OrderDate) = Years.OrderYear
    ) AS [8],

    /* Total sales for September of the current year */
    (
        SELECT SUM(soh.TotalDue)
        FROM Sales.SalesOrderHeader soh
        WHERE MONTH(soh.OrderDate) = 9
          AND YEAR(soh.OrderDate) = Years.OrderYear
    ) AS [9],

    /* Total sales for October of the current year */
    (
        SELECT SUM(soh.TotalDue)
        FROM Sales.SalesOrderHeader soh
        WHERE MONTH(soh.OrderDate) = 10
          AND YEAR(soh.OrderDate) = Years.OrderYear
    ) AS [10],

    /* Total sales for November of the current year */
    (
        SELECT SUM(soh.TotalDue)
        FROM Sales.SalesOrderHeader soh
        WHERE MONTH(soh.OrderDate) = 11
          AND YEAR(soh.OrderDate) = Years.OrderYear
    ) AS [11],

    /* Total sales for December of the current year */
    (
        SELECT SUM(soh.TotalDue)
        FROM Sales.SalesOrderHeader soh
        WHERE MONTH(soh.OrderDate) = 12
          AND YEAR(soh.OrderDate) = Years.OrderYear
    ) AS [12]
FROM
    (
        /*
            Build a list of unique years.

            Example:

                2022
                2023
                2024
        */
        SELECT 
            YEAR(OrderDate) AS OrderYear
        FROM 
            Sales.SalesOrderHeader
        GROUP BY 
            YEAR(OrderDate)
    ) AS Years

ORDER BY 
    Years.OrderYear;


/*
    Demonstrates INNER JOINs.

    Goal:
    Find all phone numbers belonging to people
    with the surname 'Abercrombie'.
*/
SELECT
	*
FROM
	Person.Person pers
    /*
        PersonPhone links people to phone numbers.

        BusinessEntityID is the primary key from Person.
    */
	INNER JOIN Person.PersonPhone pp 
        ON pp.BusinessEntityID = pers.BusinessEntityID
    /*
        PhoneNumberType translates the numeric phone type
        into a meaningful description such as:
            Mobile
            Home
            Work
    */
	INNER JOIN Person.PhoneNumberType pnt 
        ON pp.PhoneNumberTypeID = pnt.PhoneNumberTypeID
WHERE
	pers.LastName = 'Abercrombie'
Order by lastname

/*
    Aggregation Example

    Goal:
    Find people who have more than one phone number.
*/
SELECT
	pers.BusinessEntityID
,	pers.FirstName
,	pers.LastName
    /*
        Count the phone numbers belonging to each person.
    */
,	COUNT( pp.PhoneNumber )
FROM
	Person.Person pers
	INNER JOIN Person.PersonPhone pp 
        ON pp.BusinessEntityID = pers.BusinessEntityID
/*
    GROUP BY combines rows into groups.

    A separate group is created for each person.
*/
GROUP BY
	pers.BusinessEntityID
,   pers.FirstName
,   pers.LastName 
/*
    HAVING filters after aggregation.

    WHERE cannot be used here because COUNT()
    does not exist until after the grouping phase.

    Only keep people with more than one number.
*/
HAVING 
	COUNT( pp.PhoneNumber ) > 1
