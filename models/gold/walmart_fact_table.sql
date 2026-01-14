{{
    config({
        "materialized": 'incremental',
        "unique-key": 'store_id||department_id||date_id',
        "incremental-strategy": 'insert',
        "alias": 'WALMART_FACT_TABLE',
        "schema": 'GOLD'
    })
}}

WITH store_facts AS (
    SELECT DISTINCT
        s.store_id
        , d.department_id
        , dates.date_id
        , s.size
        , s.type
        , d.weekly_sales
        , f.fuel_price
        , f.temperature
        , f.unemployment
        , f.cpi
        , f.mark_down_1
        , f.mark_down_2
        , f.mark_down_3
        , f.mark_down_4
        , f.mark_down_5
        , f.insert_ts
        , f.update_ts
        , CURRENT_TIMESTAMP() AS version_start_date
        , LEAD(f.update_ts, 1) OVER (PARTITION BY f.store_id, d.department_id, f.date ORDER BY f.update_ts) AS version_end_date
    FROM {{ source('silver', 'DEPARTMENT') }} d
    JOIN {{ source('silver', 'STORE') }} s
        ON d.store_id = s.store_id
    JOIN {{ source ('silver', 'FACT') }} f
        ON d.store_id = f.store_id
            AND d.date = f.date
    JOIN {{ source('gold', 'WALMART_DATE_DIM') }} dates
        ON d.date = dates.date
)

SELECT * FROM store_facts