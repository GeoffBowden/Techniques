USE	AdventureWorks2025;
GO
--SELECT TOP (1000) *
--FROM [AdventureWorks2025].[Production].[ProductInventory]
--WHERE Shelf = 'N/A'

--SELECT -- 395 rows
--    *
--FROM 
--    [AdventureWorks2025].[Production].[ProductInventory]
--Where
--    [LocationID] in ( 45, 50, 60 )
Select * from [Production].[Location]
Insert into [Production].[Location] 
    ( LocationID, Name, CostRate, Availability, ModifiedDate )
values 
    ( 70, 'Final Assembly', 12.25,	120.00, GetDate())
-- BEGIN TRAN
-- BEGIN TRANSACTION 
BEGIN TRANSACTION updateLocationID
BEGIN TRY
    Update 
        [AdventureWorks2025].[Production].[ProductInventory]
    Set 
        LocationID = Case LocationID
            When 45 then 50
            When 50 then 60
            When 60 then 70
            else LocationID
        End
    Where
        [LocationID] in ( 45, 50, 60 )
    Declare @Msg Varchar( 50 ) = CONCAT( 'Invalid Rowcount 395 != #updated: ', @@ROWCOUNT );
    If ( @@ROWCOUNT != -395)-- 395 )
        RAISERROR( @msg, 16, 1 );

    COMMIT TRANSACTION updateLocationID;
END TRY
BEGIN CATCH
    PRINT CONCAT( '  Error Number = ', ERROR_NUMBER() );
    PRINT CONCAT( '  Error Message = ', ERROR_MESSAGE() );
    PRINT CONCAT( '  Error Severity = ', ERROR_SEVERITY() );
    PRINT CONCAT( '  Error State = ', ERROR_STATE() );
    PRINT CONCAT( '  Error Line = ', ERROR_LINE() );
    PRINT CONCAT( '  Error Proc = ', COALESCE( ERROR_PROCEDURE(), 'No Proc' ) );
    ROLLBACK TRANSACTION updateLocationID;
END CATCH