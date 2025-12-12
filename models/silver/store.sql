{{
    config({
        "materialized": 'table',
        "transient": true,
        "alias": 'STORE',
        "pre_hook": create_store_current('STORE_SOURCE'),
        "schema": 'SILVER'
    })
}}

WITH sanitized_store_data AS (
    SELECT
        store_id
        , type
        , size
        , insert_ts
        , update_ts
        , CURRENT_SESSION() AS process_id
    FROM {{source('bronze', 'STORE_CURRENT')}}
    WHERE is_deleted = FALSE
)

SELECT * FROM sanitized_store_data
;