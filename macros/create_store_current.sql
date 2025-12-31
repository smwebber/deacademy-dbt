{% macro create_store_current() %}

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
FROM {{source('bronze', 'STORE_CURRENT')}} a
JOIN (
    SELECT
        store_id
        , MAX(update_ts) AS max_update_ts
    FROM {{source('bronze', 'STORE_SOURCE')}}
    GROUP BY store_id
) b
    ON a.store_id = b.store_id
        AND a.update_ts = b.max_update_ts
;

{% endmacro %}