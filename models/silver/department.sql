{{
    config({
        "materialized": 'table',
        "transient": true,
        "alias": 'DEPARTMENT',
        "pre_hook": create_department_current('DEPARTMENT_SOURCE'),
        "schema": 'SILVER'
    })
}}

WITH sanitized_department_data AS(
    SELECT
        store_id
        , department_id
        , date
        , weekly_sales
        , is_holiday
        , insert_ts
        , update_ts
        , CURRENT_SESSION() AS process_id
    FROM {{source('bronze', 'DEPARTMENT_CURRENT')}}
    WHERE is_deleted = FALSE
)

SELECT * FROM sanitized_department_data
;