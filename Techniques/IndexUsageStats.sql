/*
Brent Ozar is a Genius and this is from his sp_blitzindex

Check out his site.
*/


Select 
	so.object_id, 
    si.index_id, 
    si.type,
    COALESCE(sc.name, 'Unknown') AS [schema_name],
    COALESCE(so.name, 'Unknown') AS [object_name], 
    COALESCE(si.name, 'Unknown') AS [index_name],
	ISNULL(us.user_seeks, 0) As UserSeeks,
    ISNULL(us.user_scans, 0) As UserScans,
    ISNULL(us.user_lookups, 0) As UserLookups,
    ISNULL(us.user_updates, 0) As UserUdates,
    us.last_user_seek,
    us.last_user_scan,
    us.last_user_lookup,
    us.last_user_update,
    so.[type] ,
    CASE WHEN so.[type] = CAST('V' AS CHAR(2)) THEN 1 ELSE 0 END As TypeV, 
    si.is_unique, 
    si.is_primary_key, 
	si.is_unique_constraint,
	CASE when si.type = 3 THEN 1 ELSE 0 END AS is_XML,
    CASE when si.type = 4 THEN 1 ELSE 0 END AS is_spatial,
    CASE when si.type = 6 THEN 1 ELSE 0 END AS is_NC_columnstore,
    CASE when si.type = 5 then 1 else 0 end as is_CX_columnstore,
    CASE when si.type = 9 then 1 else 0 end as is_json,
    CASE when si.data_space_id = 0 then 1 else 0 end as is_in_memory_oltp,
    si.is_disabled,
    si.is_hypothetical, 
    si.is_padded, 
    si.fill_factor,
    CASE WHEN si.filter_definition IS NOT NULL THEN si.filter_definition
            ELSE N''
    END AS filter_definition,
	si.optimize_for_sequential_key,
    so.create_date,
    so.modify_date
from 
	sys.indexes AS si WITH (NOLOCK)
    JOIN sys.objects AS so WITH (NOLOCK) ON 
                            si.[object_id] = so.[object_id]
                            AND so.is_ms_shipped = 0 /*Exclude objects shipped by Microsoft*/
                            AND so.type <> 'TF' /*Exclude table valued functions*/
    JOIN sys.schemas AS sc ON so.schema_id = sc.schema_id
    LEFT JOIN sys.dm_db_index_usage_stats AS us WITH (NOLOCK) ON 
                            si.[object_id] = us.[object_id]
                            AND si.index_id = us.index_id
WHERE    
    si.[type] IN ( 0, 1, 2, 3, 4, 5, 6, 9 ) 
