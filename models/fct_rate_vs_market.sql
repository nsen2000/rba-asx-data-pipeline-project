{{ config(materialized='view') }}

SELECT
    ASX.date AS asx_date,
    RBA.date AS rba_date,
    RBA.cash_rate_target AS cash_rate_target,
    ASX.Ticker AS ticker, 
    ASX.open AS open, 
    ASX.close AS close, 
    ASX.high AS high,
    ASX.low AS low,
    ASX.volume AS volume
FROM {{ ref('stg_asx_prices') }} AS ASX
CROSS JOIN {{ ref('stg_rba_cash_rate') }} AS RBA
WHERE RBA.date = (
    SELECT MAX(r.date)
    FROM {{ ref('stg_rba_cash_rate') }} AS r
    WHERE r.date <= ASX.date
)
ORDER BY asx_date

