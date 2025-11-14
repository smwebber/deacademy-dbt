{{
    config({
        "materialized": 'table',
        "transient": true,
        "alias": 'WORK_PRODUCT_TRANSFORM',
        "pre_hook": macros_copy_csv('WORK_PRODUCT_COPY'),
        "schema": 'SILVER'
    })
}}

WITH transform AS (
    SELECT
        product_id
        , product_name
        , category
        , selling_price 
        , model_number
        , about_product
        , product_specification 
        , technical_details
        , shipping_weight
        , product_dimensions
        , 'EST' AS time_zone
        , 'PRODUCT' AS source_sys_name
        , CURRENT_SESSION() AS process_id
        , 'TRANSFORM_LOAD' AS process_name
        , insert_dts 
        , update_dts
        , source_file_name
        , source_file_row_number
    FROM {{source('source', 'WORK_PRODUCT_COPY')}}
)

SELECT *FROM transform
