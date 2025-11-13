{{
    config
    ({
        "materialized": 'table',
        "schema": 'MART'
    })
}}

WITH country_details_africa AS (
    SELECT *
    FROM {{ref('country_details_transform')}}
    WHERE UPPER(country_continent_name) = 'AFRICA'
)

SELECT * FROM country_details_africa
