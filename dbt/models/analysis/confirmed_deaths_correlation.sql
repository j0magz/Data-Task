WITH totals AS (
    SELECT 
        c."Country/Region",
        SUM(c.confirmed_cases) AS total_confirmed,
        SUM(d.deaths) AS total_deaths
    FROM {{ ref('covid19_confirmed') }} c
    JOIN {{ ref('covid19_deaths') }} d
    ON c."Country/Region" = d."Country/Region"
    GROUP BY c."Country/Region"
)

SELECT 
    "Country/Region",
    total_confirmed,
    total_deaths
FROM totals
WHERE total_confirmed > 0 AND total_deaths > 0
