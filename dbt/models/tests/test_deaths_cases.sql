-- models/tests/test_deaths_cases.sql

SELECT *
FROM {{ ref('covid19_deaths') }}
WHERE deaths < 0
