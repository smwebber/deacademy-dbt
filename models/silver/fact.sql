{{
    config({
        "materialized": 'table',
        "transient": true,
        "alias": 'FACT',
        "pre_hook": create_fact_current('FACT_SOURCE'),
        "schema": 'SILVER'
    })
}}

WITH santitized_fact_data AS (
    SELECT
        store_id
        , date
        , CASE temperature
            WHEN 'NA' THEN NULL
            ELSE CAST(temparature AS DECIMAL(5, 2))
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
        CURRENT_SESSION() AS process_id
        FROM {{source('bronze', 'FACT_CURRENT')}}
    ) 
    
    SELECT * FROM santitized_fact_data
    ;