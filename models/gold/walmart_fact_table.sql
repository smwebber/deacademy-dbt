{{
    config({
        "materialized": 'incremental',
        "unique-key": 'store_id||department_id||date_id||version_end_date',
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
        , CASE
            WHEN COALESCE(s.version_end_date, CURRENT_TIMESTAMP()) < COALESCE(d.version_end_date, CURRENT_TIMESTAMP()) 
                AND COALESCE(s.version_end_date, CURRENT_TIMESTAMP()) < COALESCE(f.version_end_date, CURRENT_TIMESTAMP())
            THEN s.version_end_date
            WHEN COALESCE(d.version_end_date, CURRENT_TIMESTAMP()) < COALESCE(s.version_end_date, CURRENT_TIMESTAMP()) 
                AND COALESCE(d.version_end_date, CURRENT_TIMESTAMP()) < COALESCE(f.version_end_date, CURRENT_TIMESTAMP())
            THEN d.version_end_date
            WHEN COALESCE(f.version_end_date, CURRENT_TIMESTAMP()) < COALESCE(d.version_end_date, CURRENT_TIMESTAMP()) 
                AND COALESCE(f.version_end_date, CURRENT_TIMESTAMP()) < COALESCE(s.version_end_date, CURRENT_TIMESTAMP())
            THEN f.version_end_date
            ELSE NULL
        END AS version_end_date
    FROM {{ source('silver', 'DEPARTMENT') }} d
    JOIN {{ source('silver', 'STORE') }} s
        ON d.store_id = s.store_id
    JOIN {{ source ('silver', 'FACT') }} f
        ON d.store_id = f.store_id
            AND d.date = f.date
    JOIN {{ source('silver', 'DATE') }} dates
        ON d.date = dates.date
)

SELECT * FROM store_facts
{% if is_incremental() %}
WHERE (store_id, department_id, date_id, version_end_date) NOT IN (
    SELECT
        store_id
        , department_id
        , date_id
        , version_end_date
    FROM {{ this }}
)
{% endif %}