{{
    config({
        "materialized": 'view',
        "alias": 'PRODUCT_VIEW',
        "schema": 'GOLD'
    })
}}

WITH view AS (
    SELECT
        product_id
        , dbt_valid_from AS vrsn_strt_dts
        , COALESCE(dbt_valid_to, '9999-12-31 00:00:00.000') AS vrsn_end_dts
        , product_name
        , category
        , selling_price
        , model_number
        , about_product
        , product_specification
        , technical_details
        , shipping_weight
        , product_dimensions
        , time_zone
        , source_sys_name
        , instnc_st_nm
        , process_id
        , process_name
        , insert_dts
        , update_dts
    FROM {{ref('product_snapshot')}}
)

SELECT * FROM view