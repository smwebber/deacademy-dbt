{% macro name_format_macro(firstname, lastname) %}

concat( '{{lastname}}', ', ', '{{firstname}}' )

{% endmacro %}