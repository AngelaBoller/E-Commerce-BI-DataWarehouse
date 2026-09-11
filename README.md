# E-Commerce Analytics & Data Warehouse Platform

> **Project Status:** 🛠️ In Development  
> **Architecture:** Python (ETL) ➔ SQL Server (Staging & Galaxy Schema DWH) ➔ Power BI

---

## 1. Project Overview

### Purpose
The purpose of this project is to design and implement an end-to-end data platform for an e-commerce business. The platform integrates transactional data from different operational processes, transforms it into an analytical Data Warehouse using a **Galaxy Schema**, and provides reliable data for business reporting and executive decision-making.

This is a self-initiated portfolio project demonstrating practical skills in:
* **SQL** & **Data Warehousing** (Dimensional Modeling, Galaxy Schema / Fact Constellation)
* **Python** (Data Generation, Data Quality Checks & ETL Pipelines)
* **Data Quality & Governance** (Validation Rules & Anomaly Detection)
* **Power BI** (Data Modeling, DAX & Executive Dashboards)
* **Business Requirements Analysis** (Translating business questions into analytical models)

---

## 2. Business Scenario
A fictional international e-commerce company sells consumer products globally. Operational processes generate data across different lifecycles—sales orders, payment processing, and fulfillment/shipments. 

Management lacks a unified analytical view, and mixing these distinct operational events into a single flat model leads to data duplication and grain conflicts. The goal is to establish a central Data Warehouse that models each process at its correct granularity while enabling cross-process analytics.

---

## 3. Business Objectives
* **Process Isolation & Granularity:** Model Sales, Payments, and Shipments independently to prevent grain mismatch.
* **Unified Cross-Process View:** Leverage Conformed Dimensions to allow seamless drill-downs across processes.
* **Trend & Sales Analysis:** Track revenue, order volumes, and profitability over time.
* **Product & Category Insights:** Identify top-performing products, subcategories, and profit drivers.
* **Logistics & Payment Performance:** Monitor delivery durations, carrier efficiency, and payment processing statuses.
* **Customer Understanding:** Analyze buying behavior, segment performance, and retention.
* **Data Quality & Trust:** Implement strict data quality checks before reporting.

---

## 4. Key Business Questions

| Category | Questions |
| :--- | :--- |
| **Sales** | How much revenue did we generate? How do sales develop over time? What is the Average Order Value (AOV)? |
| **Products** | Which products generate the most revenue? Which categories have the highest profit margins? |
| **Payments** | What percentage of orders are paid vs. pending? Which payment methods are preferred per country? |
| **Shipments** | What is the average delivery time per carrier? Are there regional shipping bottlenecks? |
| **Customers** | How many active customers exist? What is the revenue split across customer segments? |
| **Geography & Channels** | Which countries generate the highest revenue? How do sales compare between Online Shop, App, and Marketplaces? |

---

## 5. Key Business KPIs

* **Total Revenue:** $\sum (\text{Line Sales Revenue})$
* **Total Orders:** Count of unique orders (`COUNT(DISTINCT OrderID)`)
* **Average Order Value (AOV):** $\frac{\text{Total Revenue}}{\text{Total Orders}}$
* **Gross Profit & Margin:** $\text{Revenue} - \text{Product Cost}$ and $\frac{\text{Gross Profit}}{\text{Revenue}}$
* **Payment Settlement Rate:** $\frac{\text{Successful Payments}}{\text{Total Payment Transactions}}$
* **On-Time Delivery Rate:** $\frac{\text{Shipments Delivered On Time}}{\text{Total Shipments}}$
* **YoY Revenue Growth:** Year-over-Year comparison of sales performance

---

## 6. Data Warehouse Architecture: Galaxy Schema (Fact Constellation)

Because **Sales**, **Payments**, and **Shipments** occur at different operational stages, have distinct business keys, and operate at different grains, forcing them into a single star schema would cause severe 1:n join fan-outs and duplication errors. 

The architecture utilizes a **Galaxy Schema** centered around **Conformed Dimensions**:

```text
               [Dim_Customer]        [Dim_Date]        [Dim_Channel]
                     \                   |                   /
                      +------------------+------------------+
                      |                  |                  |
               [Fact_Sales]       [Fact_Payment]     [Fact_Shipment]
                      |                  |                  |
               [Dim_Product]    [Dim_PaymentMethod]   [Dim_Carrier]
