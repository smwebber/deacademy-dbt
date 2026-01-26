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
        ROW_NUMBER() OVER (ORDER BY date) AS date_id
        , date
        , is_holiday
        , insert_ts
        , update_ts
    FROM {{ source('bronze', 'FACT_SOURCE') }}
    WHERE is_deleted = FALSE
        AND (date, update_ts) IN (
            SELECT 
                date
                , MAX(update_ts)
            FROM {{ source('bronze', 'FACT_SOURCE') }}
            GROUP BY date
        )
    {% if is_incremental() %}
        AND date NOT IN (SELECT date FROM {{ this }})
    {% endif %}
    GROUP BY date, is_holiday, insert_ts, update_ts
)

SELECT * FROM fact_dates