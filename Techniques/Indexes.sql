/* 
Table name and keys in the database 
*/

SELECT 
	pers.BusinessEntityID
--,	EML.*
FROM
	Person.Person pers
	LEFT JOIN Person.EmailAddress eml ON pers.BusinessEntityID = eml.BusinessEntityID 
WHERE
	EmailAddress is null


SELECT 
	t.parent_object_id, c.*
FROM
	sys.tables t
	INNER JOIN sys.indexes i ON t.object_id = i.object_id 
	INNER JOIN sys.columns c ON t.object_id = c.object_id
WHERE
	t.[type] = 'U'
ORDER BY
	t.[name] 


Select * from sys.columns where object_id = 1653580929
Select * from sys.indexes