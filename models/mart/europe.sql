{{
    config
    ({
        "materialized": 'table',
        "schema": 'MART'
    })
}}

WITH country_details_europe AS (
    SELECT *
    FROM {{ref('country_details_transform')}}
    WHERE UPPER(country_continent_name) = 'EUROPE'
)

SELECT * FROM country_details_europe
