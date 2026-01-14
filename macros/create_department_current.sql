{% macro create_department_current(table_name) %}

USE ROLE ACCOUNTADMIN
;

CREATE OR REPLACE TABLE {{var('db-name')}}.{{var('work-schema')}}.DEPARTMENT_CURRENT (
    store_id INT
    , department_id INT
    , date DATE
    , weekly_sales DECIMAL(10, 2)
    , is_holiday BOOLEAN
    , insert_ts TIMESTAMP(6)
    , update_ts TIMESTAMP(6)
    , filename VARCHAR(50)
    , is_deleted BOOLEAN
) ;

INSERT INTO {{var('db-name')}}.{{var('work-schema')}}.DEPARTMENT_CURRENT
SELECT
    a.*
FROM {{var('db-name')}}.{{var('work-schema')}}.{{table_name}} a
JOIN (
    SELECT
        store_id
        , department_id
        , date
        , MAX(update_ts) AS max_update_ts
    FROM {{var('db-name')}}.{{var('work-schema')}}.{{table_name}}
    GROUP BY store_id, department_id, date
) b
    ON a.store_id = b.store_id
        AND a.department_id = b.department_id
        AND a.date = b.date
        AND a.update_ts = b.max_update_ts
;

{% endmacro %}