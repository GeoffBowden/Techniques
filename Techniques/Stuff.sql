USE AdventureWorks2025


SELECT Stuff( 'xyz', 2, 0, 'abc' );
-- xabcyz
SELECT Stuff( 'xyz', 2, 1, 'abc' );
-- xabcz

SELECT TOP 3
	Stuff( ', ', 1, 0, Person.LastName )
FROM 
	Person.Person 

DECLARE @Names Varchar( 1000 );
SET @Names = '';
SELECT TOP 3
	@Names = @Names + Stuff( ', ', 1, 0, Person.LastName )
FROM 
	Person.Person ;
Set @Names = RTRIM( @Names, ', ' );
Select @Names;

