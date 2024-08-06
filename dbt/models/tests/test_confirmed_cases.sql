-- models/tests/test_confirmed_cases.sql

SELECT *
FROM {{ ref('covid19_confirmed') }}
WHERE confirmed_cases < 0
