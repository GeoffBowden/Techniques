/*
Windowing functions
*/
USE AdventureWorks2025

Select
	LastName
,	ROW_NUMBER() OVER ( PARTITION BY pers.LastName ORDER BY LastName )
FROM
	Person.Person pers
WHERE	
	pers.LastName like 'a%';

