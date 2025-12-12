{% macro create_fact_current(table_name) %}

USE ROLE ACCOUNTADMIN
;

CREATE OR REPLACE TABLE {{var('db-name')}}.{{var('work-schema')}}.FACT_CURRENT (
    store_id INT
    , date DATE
    , temperature DECIMAL(10, 3)
    , fuel_price DECIMAL(10, 4)
    , mark_down_1 DECIMAL(10, 2)
    , mark_down_2 DECIMAL(10, 2)
    , mark_down_3 DECIMAL(10, 2)
    , mark_down_4 DECIMAL(10, 2)
    , mark_down_5 DECIMAL(10, 2)
    , cpi DECIMAL(15, 10)
    , unemployment DECIMAL(10, 4)
    , is_holiday BOOLEAN
    , insert_ts TIMESTAMP(6)
    , update_ts TIMESTAMP(6)
    , filename VARCHAR(50)
    , is_deleted BOOLEAN
) ;

INSERT INTO {{var('db-name')}}.{{var('work-schema')}}.FACT_CURRENT
SELECT
    a.*
FROM {{source('bronze', table_name)}} a
JOIN (
    SELECT
        store_id
        , date
        , MAX(update_ts) AS max_update_ts 
    FROM {{source('bronze', table_name)}}
    GROUP BY store_id, date
) b
    ON a.store_id = b.store_id 
        AND a.date = b.date
        AND a.update_ts = b.max_update_ts
;

{% endmacro %}