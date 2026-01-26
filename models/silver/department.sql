{{
    config({
        "materialized": 'incremental',
        "unique-key": 'store_id||department_id||date||update_ts',
        "incremental-strategy": 'merge',
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
        {% if is_incremental() %}
        AND (store_id, department_id, date, update_ts) NOT IN (
            SELECT
                store_id
                , department_id
                , date
                , update_ts
            FROM {{ this }}
        )
        {% endif %}
)

SELECT * FROM department_data
