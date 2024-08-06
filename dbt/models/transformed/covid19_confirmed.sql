WITH base AS (
    SELECT 
        "Province/State",
        "Country/Region",
        "Lat",
        "Long",
        UNNEST(ARRAY[
            -- Dynamically fetch all date columns
            {% for column in adapter.get_columns_in_relation(ref('staging_covid19_confirmed')) if column.name matches('[0-9]{1,2}/[0-9]{1,2}/[0-9]{2}') %}
                '{{ column.name }}'{% if not loop.last %},{% endif %}
            {% endfor %}
        ]) AS date,
        UNNEST(ARRAY[
            {% for column in adapter.get_columns_in_relation(ref('staging_covid19_confirmed')) if column.name matches('[0-9]{1,2}/[0-9]{1,2}/[0-9]{2}') %}
                {{ column.name | as_column_name }}{% if not loop.last %},{% endif %}
            {% endfor %}
        ]) AS confirmed_cases
    FROM {{ ref('staging_covid19_confirmed') }}
)

SELECT 
    "Province/State",
    "Country/Region",
    "Lat",
    "Long",
    CAST(date AS DATE) AS date,
    confirmed_cases
FROM base
ORDER BY "Country/Region", date
