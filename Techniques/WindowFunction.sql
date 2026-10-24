/*
Windowing functions
*/
USE AdventureWorks2025

/*
    Windowing Functions Demo

    Demonstrates:
    1. ROW_NUMBER()
    2. COUNT() OVER()
    3. PARTITION BY
    4. Counting rows within a group without using GROUP BY
*/

USE AdventureWorks2025;

SELECT
    -- Person's surname
    LastName,
    -- Sequential row number across the entire result set
    ROW_NUMBER() OVER (
        ORDER BY LastName
    ) AS SurnameRowId,
    -- Total rows returned by the query
    COUNT(*) OVER () AS TotalRows,
    -- Row number within each surname group
    ROW_NUMBER() OVER (
        PARTITION BY pers.LastName
        ORDER BY pers.BusinessEntityID
    ) AS SurnameRow,
    /*
        Total number of people with the same surname.
        Unlike GROUP BY this does not collapse rows.
        Example:
            Adams  12
            Adams  12
            Adams  12
            Allen   7
            Allen   7
    */
    COUNT(*) OVER (
        PARTITION BY pers.LastName
    ) AS PeopleWithThisSurname

FROM 
    Person.Person pers
WHERE 
    -- Only surnames beginning with A
    pers.LastName LIKE 'A%';
