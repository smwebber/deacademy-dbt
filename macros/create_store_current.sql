{% macro create_store_current(table_name) %}

USE ROLE ACCOUNTADMIN
;

CREATE OR REPLACE TABLE {{var('db-name')}}.{{var('work-schema')}}.STORE_CURRENT (
    store_id INT
    , type VARCHAR(1)
    , size INT
    , insert_ts TIMESTAMP(6)
    , update_ts TIMESTAMP(6)
    , filename VARCHAR(50)
    , is_deleted BOOLEAN
) ;

INSERT INTO {{var('db-name')}}.{{var('work-schema')}}.STORE_CURRENT
SELECT
    a.*
FROM {{var('db-name')}}.{{var('work-schema')}}.{{table_name}} a
JOIN (
    SELECT
        store_id
        , MAX(update_ts) AS max_update_ts
    FROM {{var('db-name')}}.{{var('work-schema')}}.{{table_name}}
    GROUP BY store_id
) b
    ON a.store_id = b.store_id
        AND a.update_ts = b.max_update_ts
;

{% endmacro %}