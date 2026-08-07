/*
Say "Fizz" for numbers divided by 3 (like 3, 6, 9).
ay "Buzz" for numbers divided by 5 (like 5, 10, 20).
Say "FizzBuzz" for numbers divided by both 3 and 5 (like 15, 30).
Say the number if none of these rules fit.
*/

WITH Digits 
(
	digit 
)
AS
(
	SELECT 0
	UNION 
	SELECT 1
	UNION 
	SELECT 2
	UNION 
	SELECT 3
	UNION 
	SELECT 4
	UNION 
	SELECT 5
	UNION 
	SELECT 6
	UNION 
	SELECT 7
	UNION 
	SELECT 8
	UNION 
	SELECT 9
)
Select
	TestValue
,	CASE 
		WHEN TestValue % 15 = 0 THEN 'FIZZBUZZ'
		WHEN TestValue % 5 = 0 THEN 'BUZZ'
		WHEN TestValue % 3 = 0 THEN 'FIZZ'
		ELSE cast( TestValue as varchar( 8 ) ) 
	END	as Result
From
	(
		SELECT
			( tens.digit * 10 ) + units.digit + 1 AS TestValue
		FROM
			Digits tens, Digits units
	) AS TestValues 
Order by
	TestValue