
# 04. ETL Architecture & Data Quality Framework

## 1. ETL Pipeline Overview & Staging Logic

The ETL workflow follows an ELT/ETL hybrid pattern designed for robust data processing in Microsoft SQL Server. Data flows from raw source files through staging tables where validation rules are applied before being loaded into the production Data Warehouse (`dwh`) dimensional model.

```text
[ Source CSV Files ]
         │
         ▼
[ stg.Raw_* Tables ]  ◄── (Fast Bulk Insert / Truncate & Load)
         │
         ▼
[ Data Quality Check Engine ] ──► Anomaly Detected? ──YES──► [ stg.ErrorLog ] (Quarantine)
         │
        NO (Valid Data)
         ▼
[ dwh.Dim_* & dwh.Fact_* ] ◄── (Surrogate Key Mapping & Upsert Logic)
