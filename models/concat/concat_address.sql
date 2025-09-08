{{
    config(
        materialized='table'
    )
}}

select {{ concat_macro('123Street', 'Chicago') }} as address