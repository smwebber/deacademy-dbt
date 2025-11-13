{{
    config
    ({
        "materialized": 'table',
        "schema": 'MART'
    })
}}

WITH country_details_north_america AS (
    SELECT *
    FROM {{ref('country_details_transform')}}
    WHERE UPPER(country_continent_name) = 'NORTH AMERICA'
)

SELECT * FROM country_details_north_america
