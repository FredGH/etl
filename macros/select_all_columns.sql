{% macro select_all_columns(table_name) %}
  {% set table_relation = ref(table_name) %}
  {% set table_columns = adapter.get_columns_in_relation(table_relation) %}
  select
    {% for column in table_columns %}
      {{ column.name }} {% if not loop.last %},{% endif %}
    {% endfor %}
  from {{ table_relation }}
{% endmacro %}