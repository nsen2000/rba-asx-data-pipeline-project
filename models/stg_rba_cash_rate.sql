WITH source AS (
    SELECT
        *
    FROM {{ source('rba_asx_raw', 'rba_cash_rate') }}
),

renamed AS (
    SELECT
        SAFE.PARSE_DATE('%d/%m/%Y', string_field_0) AS date,
        SAFE_CAST(string_field_1 AS DECIMAL) AS cash_rate_target,
        SAFE_CAST(string_field_2 AS DECIMAL) AS interbank_overnight_cash_rate,
        SAFE_CAST(string_field_3 AS DECIMAL) AS highest_overnight_cash_rate,
        SAFE_CAST(string_field_4 AS DECIMAL) AS lowest_overnight_cash_rate
    FROM source
    WHERE SAFE.PARSE_DATE('%d/%m/%Y', string_field_0) > DATE '2020-01-01'
)

SELECT *
FROM renamed

