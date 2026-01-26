{{
    config({
        "materialized": 'incremental',
        "unique-key": 'date_id',
        "incremental-strategy": 'delete+insert',
        "alias": 'WALMART_DATE_DIM',
        "schema": 'GOLD'
    })
}}

WITH dates AS (
    SELECT
        *
    FROM {{ source('silver', 'DATE') }}
    {% if is_incremental() %}
    WHERE date_id NOT IN (SELECT date_id FROM {{ this }})
    {% endif %}
)

SELECT * FROM dates