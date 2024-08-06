WITH source_data AS (
    SELECT * FROM {{ source('covid19_source', 'deaths') }}
)

SELECT 
    "Province/State",
    "Country/Region",
    "Lat",
    "Long",
    {% for column in adapter.get_columns_in_relation(ref('source_data')) %}
        {% if column.name matches('[0-9]{1,2}/[0-9]{1,2}/[0-9]{2}') %}
            "{{ column.name }}"{{ "," if not loop.last }}
        {% endif %}
    {% endfor %}
FROM source_data
