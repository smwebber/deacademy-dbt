{{
    config({
        "materialized": 'incremental',
        "unique-key": 'store_id||date'
        "incremental-strategy": 'insert',
        "alias": 'FACT',
        "schema": 'SILVER'
    })
}}

WITH fact_data AS (
    SELECT
        store_id
        , date
        , temperature
        , fuel_price
        , mark_down_1
        , mark_down_2
        , mark_down_3
        , mark_down_4
        , mark_down_5
        , cpi
        , unemployment
        , is_holiday
        , insert_ts
        , update_ts
        , CURRENT_SESSION() AS process_id
        , CURRENT_TIMESTAMP() AS version_start_date
        , LEAD(update_ts, 1) OVER (PARTITION BY store_id, date ORDER BY update_ts ASC) AS version_end_date
        FROM {{source('bronze', 'FACT_SOURCE')}}
        WHERE is_deleted = FALSE
    ) 
    
    SELECT * FROM fact_data
    