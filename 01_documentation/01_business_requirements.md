
# 01. Business Requirements & KPI Definitions

## 1. Executive Summary & Core Objectives
The primary objective of this Data Warehouse initiative is to establish a single, reliable source of truth for analytical reporting across global e-commerce operations.

### Key Business Goals
* **Unified Sales Visibility:** Consolidate order lines, transactions, and channel sources into a centralized analytical platform.
* **Granular Product & Profitability Performance:** Enable drill-downs from high-level categories down to individual product SKUs, net margins, and discounts.
* **Process Alignment:** Decouple commercial orders, payment processing, and logistics fulfillment to maintain high analytical clarity across distinct process lifecycles.
* **Reporting Trust:** Enforce automated data quality validations during ingestion to prevent corrupted data from impacting decision-making.

---

## 2. Business Questions Matrix

| Business Domain | Core Analytical Questions | Target Granularity |
| :--- | :--- | :--- |
| **Sales Performance** | What is the total gross vs. net revenue? How are order volumes trending over time? What is the Average Order Value (AOV)? | Date, Country, Channel |
| **Product & Portfolio** | Which product categories drive the highest volume and profit margins? What is the impact of item discounts? | Category, Subcategory, Product |
| **Payment Operations** | What proportion of orders are successfully settled vs. failed/pending? Which payment methods predominate per country? | Payment Method, Status, Date |
| **Fulfillment & Logistics** | What is the average lead time between order creation and carrier dispatch? What is the on-time delivery rate per carrier? | Carrier, Shipping Country, Status |
| **Customer Insights** | What is the revenue distribution across customer segments? How many active customers exist per market? | Segment, Country |

---

## 3. Key Performance Indicators (KPI) Formulation Guide

### Financial & Commercial KPIs

* **Total Gross Revenue**
  $$\text{Gross Revenue} = \sum (\text{Quantity} \times \text{UnitPrice})$$
* **Total Net Revenue**
  $$\text{Net Revenue} = \sum ((\text{Quantity} \times \text{UnitPrice}) - \text{Discount})$$
* **Total Cost of Goods Sold (COGS)**
  $$\text{Total COGS} = \sum (\text{Quantity} \times \text{UnitCost})$$
* **Gross Profit**
  $$\text{Gross Profit} = \text{Net Revenue} - \text{Total COGS}$$
* **Gross Profit Margin (%)**
  $$\text{Gross Margin} = \frac{\text{Gross Profit}}{\text{Net Revenue}} \times 100$$
* **Average Order Value (AOV)**
  $$\text{AOV} = \frac{\text{Total Net Revenue}}{\text{Total Unique Orders}}$$

### Operational & Process KPIs

* **Payment Settlement Rate (%)**
  $$\text{Settlement Rate} = \frac{\text{Count of Successful Transactions}}{\text{Total Payment Transactions}} \times 100$$
* **Fulfillment Duration (Lead Time in Days)**
  $$\text{Fulfillment Lead Time} = \text{Shipment Date} - \text{Order Date}$$
