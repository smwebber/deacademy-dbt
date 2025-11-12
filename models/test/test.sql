{{
    config
    (
        materialized = 'table'
    )
}}

with test as
(
    select * from {{source('test', 'TEST')}}
)


select * from test