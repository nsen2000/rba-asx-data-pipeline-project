SELECT 
     asx_date,
     rba_date
FROM {{ ref('fct_rate_vs_market') }}
WHERE rba_date > asx_date
