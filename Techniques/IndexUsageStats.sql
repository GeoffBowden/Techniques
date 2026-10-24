/*
    Based on Brent Ozar's sp_BlitzIndex.

    sys.indexes (si)
    ---------------
    type values:
        0 = Heap (table has no clustered index)
        1 = Clustered index
        2 = Nonclustered index
        3 = XML index
        4 = Spatial index
        5 = Clustered columnstore index
        6 = Nonclustered columnstore index
        7 = Nonclustered hash index (memory-optimised tables)
        9 = JSON index (SQL Server 2025+)

    sys.objects (so)
    ----------------
    Common type values:
        U  = User table
        V  = View
        P  = SQL stored procedure
        FN = SQL scalar function
        IF = SQL inline table-valued function
        TF = SQL table-valued function
        TR = SQL trigger
*/

SELECT
    so.object_id,                        -- Object identifier

    si.index_id,                         -- Index ID within the object
                                         -- 0 = heap
                                         -- 1 = clustered index
                                         -- >1 = nonclustered/XML/etc.

    si.type,                             -- Index type:
                                         -- 0=Heap
                                         -- 1=Clustered
                                         -- 2=Nonclustered
                                         -- 3=XML
                                         -- 4=Spatial
                                         -- 5=Clustered Columnstore
                                         -- 6=Nonclustered Columnstore
                                         -- 7=Nonclustered Hash
                                         -- 9=JSON

    COALESCE(sc.name, 'Unknown') AS schema_name, -- Schema containing object

    COALESCE(so.name, 'Unknown') AS object_name, -- Table/view name

    COALESCE(si.name, 'Unknown') AS index_name,  -- Index name

    ISNULL(us.user_seeks, 0) AS UserSeeks,       -- Number of index seeks
    ISNULL(us.user_scans, 0) AS UserScans,       -- Number of index scans
    ISNULL(us.user_lookups, 0) AS UserLookups,   -- Number of bookmark/key lookups
    ISNULL(us.user_updates, 0) AS UserUpdates,   -- Number of updates affecting index

    us.last_user_seek,           -- Last time a seek used this index
    us.last_user_scan,           -- Last time a scan used this index
    us.last_user_lookup,         -- Last time a lookup used this index
    us.last_user_update,         -- Last update affecting this index

    so.type,                     -- Object type:
                                 -- U=Table
                                 -- V=View
                                 -- P=Stored Procedure
                                 -- FN=Scalar Function
                                 -- IF=Inline TVF
                                 -- TF=Table-valued Function
                                 -- TR=Trigger

    CASE
        WHEN so.type = CAST('V' AS CHAR(2))
        THEN 1 ELSE 0
    END AS TypeV,                -- 1 if object is a View

    si.is_unique,                -- 1 = uniqueness enforced
    si.is_primary_key,           -- 1 = backs a PRIMARY KEY
    si.is_unique_constraint,     -- 1 = backs a UNIQUE constraint

    CASE WHEN si.type = 3 THEN 1 ELSE 0 END AS is_XML,
    CASE WHEN si.type = 4 THEN 1 ELSE 0 END AS is_spatial,
    CASE WHEN si.type = 6 THEN 1 ELSE 0 END AS is_NC_columnstore,
    CASE WHEN si.type = 5 THEN 1 ELSE 0 END AS is_CX_columnstore,
    CASE WHEN si.type = 9 THEN 1 ELSE 0 END AS is_json,

    CASE
        WHEN si.data_space_id = 0
        THEN 1 ELSE 0
    END AS is_in_memory_oltp,    -- Memory-optimised index

    si.is_disabled,              -- 1 = index disabled
    si.is_hypothetical,          -- 1 = hypothetical index (DTA/statistics only)

    si.is_padded,                -- 1 = PAD_INDEX enabled
    si.fill_factor,              -- Page fill factor (0 = default)

    CASE
        WHEN si.filter_definition IS NOT NULL
        THEN si.filter_definition
        ELSE N''
    END AS filter_definition,    -- Filter predicate for filtered indexes

    si.optimize_for_sequential_key, -- 1 = last-page insert optimisation enabled

    so.create_date,              -- Object creation date
    so.modify_date               -- Last object modification date

FROM 
    sys.indexes AS si WITH (NOLOCK)

    JOIN sys.objects AS so WITH (NOLOCK)
        ON si.object_id = so.object_id
        AND so.is_ms_shipped = 0     -- Exclude Microsoft-supplied objects
        AND so.type <> 'TF'          -- Exclude table-valued functions

    JOIN sys.schemas AS sc
        ON so.schema_id = sc.schema_id

    LEFT JOIN sys.dm_db_index_usage_stats AS us WITH (NOLOCK)
        ON si.object_id = us.object_id
        AND si.index_id = us.index_id

WHERE 
    si.type IN (0, 1, 2, 3, 4, 5, 6, 9);