{{
    config(
        materialized='table'
    )
}}

select {{ name_format_macro('John', 'Smith')}}  as name
