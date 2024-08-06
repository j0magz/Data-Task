WITH base AS (
    SELECT 
        "Province/State",
        "Country/Region",
        "Lat",
        "Long",
        UNNEST(ARRAY[
            -- Dynamically fetch all date columns
            {% for column in adapter.get_columns_in_relation(ref('staging_covid19_recovered')) if column.name matches('[0-9]{1,2}/[0-9]{1,2}/[0-9]{2}') %}
                '{{ column.name }}'{% if not loop.last %},{% endif %}
            {% endfor %}
        ]) AS date,
        UNNEST(ARRAY[
            {% for column in adapter.get_columns_in_relation(ref('staging_covid19_recovered')) if column.name matches('[0-9]{1,2}/[0-9]{1,2}/[0-9]{2}') %}
                {{ column.name | as_column_name }}{% if not loop.last %},{% endif %}
            {% endfor %}
        ]) AS recovered
    FROM {{ ref('staging_covid19_recovered') }}
)

SELECT 
    "Province/State",
    "Country/Region",
    "Lat",
    "Long",
    CAST(date AS DATE) AS date,
    recovered
FROM base
ORDER BY "Country/Region", date
