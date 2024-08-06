-- models/tests/test_recovered_cases.sql

SELECT *
FROM {{ ref('covid19_recovered') }}
WHERE recovered < 0
