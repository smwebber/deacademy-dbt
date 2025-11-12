{{
    config
    (
        materialized = 'table'
    )
}}

WITH country AS
(
    SELECT 
        data:name:common::STRING AS common_name
        , data:name:official::STRING AS official_name
        , capital.value::STRING AS capital
        , data:region::STRING AS region
        , data:population AS population
        , currency.value:name::STRING AS currency_name
        , currency.value:symbol::STRING AS currency_symbol
        , language.value:eng::STRING AS language
        , data:independent AS independent
    FROM {{source('country', 'COUNTRY_JSON')}} ,
    LATERAL FLATTEN (INPUT => data:currencies) AS currency ,
    LATERAL FLATTEN (INPUT => data:languages) AS language
)


SELECT * FROM country
;