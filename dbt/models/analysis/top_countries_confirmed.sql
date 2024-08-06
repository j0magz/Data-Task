WITH confirmed_totals AS (
    SELECT 
        "Country/Region",
        SUM(confirmed_cases) AS total_confirmed
    FROM {{ ref('covid19_confirmed') }}
    GROUP BY "Country/Region"
)

SELECT 
    "Country/Region",
    total_confirmed
FROM confirmed_totals
ORDER BY total_confirmed DESC
LIMIT 5
