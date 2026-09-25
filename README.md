# RBA Cash Rate × ASX Market Performance Pipeline

A batch data pipeline analysing how RBA cash rate changes relate to ASX
market performance (overall and by sector) over 2024–present.

## Question
How do RBA cash rate decisions relate to ASX 200 and sector-level stock
performance over time?

## Architecture

```mermaid
graph LR
    subgraph Airflow["Airflow DAG (Docker Compose)"]
        direction LR

        subgraph Sources["Sources"]
            RBA["RBA Table F1.1<br/>(cash rate, monthly)"]
            YF["yfinance API<br/>(ASX prices, daily)"]
        end

        subgraph Raw["Raw — BigQuery"]
            RAWRBA["raw_rba_cash_rate"]
            RAWASX["raw_asx_prices"]
        end

        subgraph Staging["Staging — dbt"]
            STGRBA["stg_cash_rate"]
            STGASX["stg_asx_prices"]
        end

        subgraph Marts["Marts — dbt"]
            FCT["fct_rate_vs_market<br/><i>as-of join, daily grain</i>"]
            MONTHLY["fct_monthly_returns<br/><i>monthly grain</i>"]
        end
    end

    PBI["Power BI<br/>dashboard"]

    RBA --> RAWRBA --> STGRBA --> FCT
    YF --> RAWASX --> STGASX --> FCT
    FCT --> MONTHLY
    FCT --> PBI
    MONTHLY --> PBI

    classDef source fill:#f5f5f5,stroke:#888,color:#222
    classDef raw fill:#e8eef7,stroke:#5b7fa6,color:#1a2b3c
    classDef stg fill:#e4efe6,stroke:#5c8a63,color:#1d2f21
    classDef mart fill:#f7ece1,stroke:#b07d4a,color:#3b2a18
    classDef bi fill:#f2e8f2,stroke:#8a5c8a,color:#2f1d2f

    class RBA,YF source
    class RAWRBA,RAWASX raw
    class STGRBA,STGASX stg
    class FCT,MONTHLY mart
    class PBI bi
```

## Data
- **RBA cash rate** (Table F1.1, monthly) — the monetary policy signal
- **ASX prices** (daily, via yfinance): ^AXJO (index), CBA.AX (Financials),
  BHP.AX (Materials), WES.AX (Consumer), CSL.AX (Healthcare)
- Window: 2024-01-01 → present

## Key modeling decision
Daily market data joined to monthly rate data via an **as-of join** — each
trading day is tagged with the prevailing cash rate, preserving daily
granularity while correctly modeling the rate as a step function.

## Stack
Python · Google Cloud Storage · BigQuery · dbt · Airflow · Terraform ·
Docker · Power BI

## Status
🚧 In development

## How to run
_(to be documented)_
=======

