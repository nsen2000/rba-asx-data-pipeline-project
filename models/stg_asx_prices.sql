SELECT
    CAST(Date AS DATE) AS date,
    CAST(Close AS DECIMAL) AS close,
    CAST(High AS DECIMAL) AS high,
    CAST(Low AS DECIMAL) AS low,
    CAST(Open AS DECIMAL) AS open,
    CAST(Volume AS INTEGER) AS volume,
    Ticker AS ticker
FROM {{ source('rba_asx_raw', 'asx_prices') }}
WHERE CAST(Date AS DATE) >= '2024-01-02'

