--- Ram price($) predicted per GB in 2027-2028
SELECT year,month,
    ROUND(predicted_price_per_gb::numeric, 2) AS predicted_price_per_gb
FROM ram_price_forecast
ORDER BY year, month;
-- Avarage price($) increase from past 2024-2028
SELECT year,
    ROUND(AVG(price_per_gb)::numeric, 2) AS avg_price,
    'Historical' AS data_type
FROM ram_facts
GROUP BY year
UNION ALL

SELECT year,
    ROUND(AVG(predicted_price_per_gb)::numeric, 2) AS avg_price,
    'Predicted' AS data_type
FROM ram_price_forecast
GROUP BY year
ORDER BY year;

-- percentage(%) of prices increased from 2024
WITH base AS (
    SELECT AVG(price_per_gb) AS base_2024
    FROM ram_facts
    WHERE year = 2024
),
forecast AS (
    SELECT year,
           AVG(predicted_price_per_gb) AS avg_price
    FROM ram_price_forecast
    GROUP BY year
)
SELECT
    f.year,
    ROUND(f.avg_price::numeric, 2)                              AS predicted_price,
    ROUND(((f.avg_price - b.base_2024) / b.base_2024 * 100)::numeric, 1) AS pct_increase_vs_2024
FROM forecast f
CROSS JOIN base b
ORDER BY f.year;