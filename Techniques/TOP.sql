SELECT 
	*
FROM
	Person.Person AS pers
ORDER BY
	pers.LastName 
OFFSET 0 ROWS
FETCH NEXT 3 ROWS ONLY ;


SELECT TOP 3
	*
FROM
	Person.Person AS pers;


SELECT TOP 3
	*
FROM
	Person.Person AS pers
ORDER BY
	pers.LastName ;


SELECT TOP 3 WITH TIES
	*
FROM
	Person.Person AS pers
ORDER BY
	pers.LastName ;

