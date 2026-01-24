{{
    config({
        "materialized": 'incremental',
        "unique-key": 'store_id',
        "incremental-strategy": 'merge',
        "alias": 'STORE',
        "schema": 'SILVER'
    })
}}

WITH store_data AS (
    SELECT
        store_id
        , type
        , size
        , insert_ts
        , update_ts
        , CURRENT_SESSION() AS process_id
        , CURRENT_TIMESTAMP() AS version_start_date
        , LEAD(update_ts, 1) OVER (PARTITION BY store_id ORDER BY update_ts ASC) AS version_end_date
    FROM {{source('bronze', 'STORE_SOURCE')}}
    WHERE is_deleted = FALSE
)

SELECT * FROM store_data
