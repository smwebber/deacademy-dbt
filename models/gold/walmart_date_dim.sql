{{
    config({
        "materialized": 'incremental',
        "unique-key": 'date_id',
        "incremental-strategy": 'merge',
        "alias": 'WALMART_DATE_DIM',
        "schema": 'GOLD'
    })
}}

WITH fact_dates AS (
    SELECT
        ROW_NUMBER() OVER(ORDER BY date ASC) AS date_id
        , date
        , is_holiday
        , insert_ts
        , update_ts
    FROM {{ source('silver', 'FACT') }}
    GROUP BY date, is_holiday, insert_ts, update_ts
)

SELECT * FROM fact_dates