{{
    config({
        "materialized": 'incremental',
        "unique-key": 'store_id||date',
        "incremental-strategy": 'merge',
        "alias": 'FACT',
        "schema": 'SILVER'
    })
}}

WITH fact_data AS (
    SELECT
        store_id
        , date
        , CASE temperature
            WHEN 'NA' THEN NULL
            ELSE CAST(temperature AS DECIMAL(5, 2))
        END AS temperature
        , CASE fuel_price
            WHEN 'NA' THEN NULL
            ELSE CAST(fuel_price AS DECIMAL(5, 3))
        END AS fuel_price
        , CASE mark_down_1
            WHEN 'NA' THEN NULL
            ELSE CAST(mark_down_1 AS DECIMAL(10, 2))
        END AS mark_down_1
        , CASE mark_down_2
            WHEN 'NA' THEN NULL
            ELSE CAST(mark_down_2 AS DECIMAL(10, 2))
        END AS mark_down_2
        , CASE mark_down_3
            WHEN 'NA' THEN NULL
            ELSE CAST(mark_down_3 AS DECIMAL(10, 2))
        END AS mark_down_3
        , CASE mark_down_4
            WHEN 'NA' THEN NULL
            ELSE CAST(mark_down_4 AS DECIMAL(10, 2))
        END AS mark_down_4
        , CASE mark_down_5
            WHEN 'NA' THEN NULL
            ELSE CAST(mark_down_5 AS DECIMAL(10, 2))
        END AS mark_down_5
        , CASE cpi
            WHEN 'NA' THEN NULL
            ELSE CAST(cpi AS DECIMAL(15, 10))
        END AS cpi
        , CASE unemployment
            WHEN 'NA' THEN NULL
            ELSE CAST(unemployment AS DECIMAL(5, 3))
        END AS unemployment
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
    