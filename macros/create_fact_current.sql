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
    a.store_id
    , a.date
    , CASE temperature
        WHEN 'NA' THEN NULL
        ELSE CAST(temperature AS DECIMAL(5, 2))
    END AS temperature
    , CASE fuel_price
        WHEN 'NA' THEN NULL
        ELSE CAST(fuel_price AS DECIMAL(5, 3))
    END AS fuel_price
    , CASE mark_down_1
        WHEN 'NA' THEN NULL
        ELSE CAST(mark_down_1 AS DECIMAL(10, 2))
    END AS mark_down_1
    , CASE mark_down_2
        WHEN 'NA' THEN NULL
        ELSE CAST(mark_down_2 AS DECIMAL(10, 2))
    END AS mark_down_2
    , CASE mark_down_3
        WHEN 'NA' THEN NULL
        ELSE CAST(mark_down_3 AS DECIMAL(10, 2))
    END AS mark_down_3
    , CASE mark_down_4
        WHEN 'NA' THEN NULL
        ELSE CAST(mark_down_4 AS DECIMAL(10, 2))
    END AS mark_down_4
    , CASE mark_down_5
        WHEN 'NA' THEN NULL
        ELSE CAST(mark_down_5 AS DECIMAL(10, 2))
    END AS mark_down_5
    , CASE cpi
        WHEN 'NA' THEN NULL
        ELSE CAST(cpi AS DECIMAL(15, 10))
    END AS cpi
    , CASE unemployment
        WHEN 'NA' THEN NULL
        ELSE CAST(unemployment AS DECIMAL(5, 3))
    END AS unemployment
    , is_holiday
    , insert_ts
    , update_ts
    , filename
    , is_deleted
FROM {{var('db-name')}}.{{var('work-schema')}}.{{table_name}} a
JOIN (
    SELECT
        store_id
        , date
        , MAX(update_ts) AS max_update_ts 
    FROM {{var('db-name')}}.{{var('work-schema')}}.{{table_name}}
    GROUP BY store_id, date
) b
    ON a.store_id = b.store_id 
        AND a.date = b.date
        AND a.update_ts = b.max_update_ts
;

{% endmacro %}