{{
    config
    ({
        "materialized": 'table',
        "schema": 'TRANSFORM'
    })
}}

WITH country_details_transform AS (
    SELECT
        source_data:cca3::STRING AS country_code
        , source_data:name:official::STRING AS country_official_name
        , source_data:name:common::STRING AS country_common_name
        , source_data:latlng[0]::DOUBLE AS country_lat
        , source_data:latlng[1]::DOUBLE AS country_lng
        , con.value::STRING AS country_continent_name
        , source_data:region::STRING AS country_region_name
        , source_data:subregion::STRING AS country_subregion_name
        , cap.value::STRING AS country_capital_name
        , source_data:capitalInfo:latlng[0]::DOUBLE AS country_capital_latlng
        , source_data:capitalInfo:latlng[1]::DOUBLE AS country_capital_lng
        , source_data:area::INTEGER AS country_total_area
        , source_data:population::INTEGER AS country_population
        , cur.key::STRING AS country_currency
        , cur.value:name::STRING AS country_currency_name
        , cur.value:symbol::STRING AS country_currency_symbol
        , source_data:flags:png::STRING AS country_flag
        , source_data:maps:googleMaps::STRING AS country_map
        , lang.key::STRING AS language_code
        , lang.value::STRING AS language
        , source_data:startOfWeek::STRING AS country_start_of_week
        , source_data:unMember::BOOLEAN AS country_un_member_status
        , source_data:car:side::STRING AS country_driving_lane
        , CURRENT_TIMESTAMP(6) AS insert_dts
    FROM {{ref('country_details_raw')}} a
    , LATERAL FLATTEN (a.source_data:continents) con
    , LATERAL FLATTEN (a.source_data:capital) cap
    , LATERAL FLATTEN (a.source_data:currencies) cur
    , LATERAL FLATTEN (a.source_data:languages) lang
)

SELECT * FROM country_details_transform