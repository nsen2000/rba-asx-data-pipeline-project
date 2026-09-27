{{ config(materialized='table') }}

WITH rba_daily AS (
    SELECT
        date, 
        cash_rate_target, 
        LAG(cash_rate_target) OVER (
            ORDER BY date
        ) AS prev_cash_rate_target
    FROM {{ ref('stg_rba_cash_rate') }}
),

change_points AS (
    SELECT 
        date AS valid_from,
        cash_rate_target,
        prev_cash_rate_target
    FROM rba_daily
    WHERE cash_rate_target <> prev_cash_rate_target
        OR prev_cash_rate_target IS NULL
),

rate_periods AS (
    SELECT
        valid_from,
        cash_rate_target, 
        COALESCE(LEAD(valid_from) OVER (ORDER BY valid_from), DATE '9999-12-31') AS valid_to
    FROM change_points
)

SELECT
    ASX.date AS asx_date,
    RBA.valid_from AS rba_date,
    RBA.cash_rate_target AS cash_rate_target,
    ASX.Ticker AS ticker, 
    ASX.open AS open, 
    ASX.close AS close, 
    ASX.high AS high,
    ASX.low AS low,
    ASX.volume AS volume
FROM {{ ref('stg_asx_prices') }} AS ASX
JOIN rate_periods AS RBA
ON ASX.date >= RBA.valid_from AND ASX.date < RBA.valid_to
