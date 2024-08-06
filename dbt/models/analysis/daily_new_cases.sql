WITH daily_confirmed AS (
    SELECT 
        date,
        SUM(confirmed_cases) AS total_confirmed
    FROM {{ ref('covid19_confirmed') }}
    GROUP BY date
),

daily_new_cases AS (
    SELECT
        date,
        total_confirmed - LAG(total_confirmed) OVER (ORDER BY date) AS new_cases
    FROM daily_confirmed
)

SELECT
    date,
    new_cases
FROM daily_new_cases
WHERE new_cases IS NOT NULL
ORDER BY date
