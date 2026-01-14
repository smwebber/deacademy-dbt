{{
    config({
        "materialized": 'incremental',
        "unique-key": 'store_id||department_id',
        "incremental-strategy": 'merge',
        "alias": 'WALMART_STORE_DIM',
        "schema": 'GOLD'
    })
}}

WITH stores AS (
    SELECT DISTINCT
        s.store_id
        , d.department_id
        , s.type
        , s.size
        , s.insert_ts
        , s.update_ts
    FROM {{ source('silver', 'STORE') }} s
    JOIN {{ source('silver', 'DEPARTMENT') }} d
        ON s.store_id = d.store_id
)

SELECT * FROM stores