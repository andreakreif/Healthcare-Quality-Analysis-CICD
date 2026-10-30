WITH days AS (
select
    cast('1990-01-01' as date) + cast(range as integer) as d
from range(60000)
)
SELECT
    CAST(STRFTIME(d, '%Y%m%d') AS INT)                        AS date_key,
    d                                                       AS full_date,
    YEAR(d)                                                 AS year_num,
    QUARTER(d)                                              AS quarter_num,
    YEAR(d) || '-Q' || QUARTER(d)                           AS quarter_label,
    MONTH(d)                                                AS month_num,
    MONTHNAME(d)                                            AS month_name,
    STRFTIME(d, '%Y-%m')                                      AS year_month,
    DAY(d)                                                  AS day_of_month,
    DAYOFYEAR(d)                                            AS day_of_year,
    ISODOW(d)                                               AS day_of_week_iso,
    DAYNAME(d)                                              AS day_name,
    WEEKOFYEAR(d)                                           AS iso_week_num,
    ISOYEAR(d)                                              AS iso_year_num,
    CASE WHEN ISODOW(d) IN (6, 7)  THEN 'Y' ELSE 'N' END    AS is_weekend,
    DATE_TRUNC('month', d)                                  AS month_start_date,
    LAST_DAY(d)                                             AS month_end_date,
    DATE_TRUNC('year', d)                                   AS year_start_date,
    LAST_DAY(DATE_ADD(CURRENT_DATE, INTERVAL '1 year'))     AS year_end_date
FROM days
WHERE d <= STRPTIME('2050-12-31','%Y-%m-%d')::DATE
UNION ALL
-- Sentinel rows
SELECT 99991231, STRPTIME('9999-12-31','%Y-%m-%d')::DATE, 9999, 4, '9999-Q4', 12, 'December', '9999-12',
  31, 365, 5, 'Friday', 52, 9999, FALSE,
  STRPTIME('9999-12-01','%Y-%m-%d')::DATE, STRPTIME('9999-12-31','%Y-%m-%d')::DATE, 
  STRPTIME('9999-01-01','%Y-%m-%d')::DATE, STRPTIME('9999-12-31','%Y-%m-%d')::DATE
UNION ALL
 SELECT-1, STRPTIME('1899-12-31','%Y-%m-%d')::DATE, NULL, NULL, 'Unknown', NULL, 'Unknown', 'Unknown',
  NULL, NULL, NULL, 'Unknown', NULL, NULL, NULL, NULL, NULL, NULL, NULL