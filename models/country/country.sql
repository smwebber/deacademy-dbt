{{
    config
    (
        materialized = 'table'
    )
}}

WITH country_json AS
(
    SELECT
        countries.value:cca3::STRING AS country_id 
        , countries.value:name:common::STRING AS common_name
        , countries.value:name:official::STRING AS official_name
        , capital.value::STRING AS capital
        , countries.value:region::STRING AS region
        , countries.value:population AS population
        , currency.value:name::STRING AS currency_name
        , currency.value:symbol::STRING AS currency_symbol
        , language.value::STRING AS language
        , countries.value:independent AS independent
    FROM {{source('country', 'COUNTRY_JSON')}} ,
    LATERAL FLATTEN (INPUT => data) AS countries ,
    LATERAL FLATTEN (INPUT => countries.value:capital) AS capital ,
    LATERAL FLATTEN (INPUT => countries.value:currencies) AS currency ,
    LATERAL FLATTEN (INPUT => countries.value:languages) AS language
)


SELECT * FROM country_json
