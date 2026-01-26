{{
    config({
        "materialized": 'incremental',
        "unique-key": 'date_id',
        "incremental-strategy": 'merge',
        "alias": 'DATE',
        "schema": 'SILVER'
    })
}}

WITH fact_dates AS (
    SELECT
        ROW_NUMBER() OVER(ORDER BY date ASC) AS date_id
        , date
        , is_holiday
        , insert_ts
        , MAX(update_ts)
    FROM {{ source('bronze', 'FACT_SOURCE') }}
    WHERE is_deleted = FALSE
    {% if is_incremental() %}
        AND date_id NOT IN (SELECT date_id FROM {{ this }})
    {% endif %}
    GROUP BY date, is_holiday, insert_ts
)

SELECT * FROM fact_dates