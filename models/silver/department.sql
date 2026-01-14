{{
    config({
        "materialized": 'incremental',
        "unique-key": 'store_id||department_id||date'
        "incremental-strategy": 'insert',
        "alias": 'DEPARTMENT',
        "schema": 'SILVER'
    })
}}

WITH department_data AS (
    SELECT
        store_id
        , department_id
        , date
        , weekly_sales
        , is_holiday
        , insert_ts
        , update_ts
        , CURRENT_SESSION() AS process_id
        , CURRENT_TIMESTAMP() AS version_start_date
        , LEAD(update_ts, 1) OVER (PARTITION BY store_id, department_id, date ORDER BY update_ts ASC) AS version_end_date
    FROM {{source('bronze', 'DEPARTMENT_SOURCE')}}
    WHERE is_deleted = FALSE
)

SELECT * FROM department_data
