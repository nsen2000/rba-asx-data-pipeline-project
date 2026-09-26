{{ config(materialized='table') }}


WITH monthly AS (
    SELECT 
        ticker, 
        DATE_TRUNC(asx_date, MONTH) AS month_start_date,
        asx_date,
        close,
        cash_rate_target, 
        ROW_NUMBER() OVER (
            PARTITION BY DATE_TRUNC(asx_date, MONTH), ticker
            ORDER BY asx_date DESC
        ) AS rn
    FROM 
        {{ ref('fct_rate_vs_market') }}
),

month_end AS (
    SELECT 
        ticker,
        month_start_date,
        asx_date AS month_end_date, 
        close AS month_end_close,
        cash_rate_target AS month_end_rate
    FROM monthly
    WHERE rn = 1
),

compare_prev_month AS (
    SELECT
        ticker, 
        month_start_date,
        month_end_close,
        month_end_rate, 
        month_end_date,
        LAG(month_end_close) OVER (
            PARTITION BY ticker
            ORDER BY month_start_date 
        ) AS prev_close,
        LAG(month_end_rate) OVER (
            PARTITION BY ticker
            ORDER BY month_start_date
        ) AS prev_rate
    FROM month_end
)

SELECT 
    ticker, 
    month_start_date,
    month_end_close,
    month_end_rate, 
    month_end_date,
    SAFE_DIVIDE(month_end_close, prev_close) - 1  AS monthly_return,
    month_end_rate - prev_rate                    AS rate_change_pp
FROM compare_prev_month
WHERE prev_close IS NOT NULL
    AND month_start_date < DATE_TRUNC(CURRENT_DATE(), MONTH)
