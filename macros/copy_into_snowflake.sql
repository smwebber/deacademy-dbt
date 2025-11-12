{% macro copy_json(table_name) %}

DELETE FROM {{var('target_db')}}.{{var('target_schema')}}.{{table_name}}
;

COPY INTO {{var('target_db')}}.{{var('target_schema')}}.{{table_name}}
FROM (
    SELECT
        $1 AS data
    FROM @{{var('stage_name')}}
)
FILE_FORMAT = (TYPE = JSON)
FORCE = TRUE
;

{% endmacro %}