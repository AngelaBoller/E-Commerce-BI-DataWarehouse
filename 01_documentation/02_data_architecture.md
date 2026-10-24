# 02. Data Architecture & Dimensional Model

## 1. Architectural Approach: Galaxy Schema

The e-commerce data warehouse follows a **Galaxy Schema**, also known as a Fact Constellation Schema. This design separates the three main business processes — sales, payments, and shipments — into individual fact tables.

These processes operate at different levels of detail, or *grain*. Keeping them separate helps prevent duplicated measures and incorrect aggregations when analyzing multiple business processes.

The data warehouse is implemented in SQL Server using the `dwh` schema.

## 2. Fact Table Granularity

Each fact table represents a specific business process and has its own defined grain.

| Fact Table | Grain | Business Purpose |
|---|---|---|
| `FactSales` | One record per order line | Analyze sales revenue, quantities, and product performance |
| `FactPayment` | One record per payment transaction | Analyze payment amounts, methods, and transaction statuses |
| `FactShipment` | One record per shipment record | Analyze shipment activity and delivery duration |

The grain must be considered when combining measures from different fact tables. Joining tables without accounting for their individual granularity can duplicate records and inflate aggregated values.

## 3. Dimension Tables

The model contains four dimension tables.

| Dimension Table | Purpose |
|---|---|
| `DimCustomer` | Provides customer-related attributes for customer and market analysis |
| `DimProduct` | Provides product-related attributes for product and category analysis |
| `DimDate` | Provides calendar attributes for time-based analysis |
| `DimOrder` | Provides order-related attributes for order-level analysis |

These dimensions support filtering, grouping, and comparison across the fact tables where corresponding relationships are defined.

Attributes such as sales channel, payment method, or carrier do not represent separate dimension tables in the current implementation. They may be analyzed as attributes of the relevant tables where available.

### Galaxy Schema Overview

The data warehouse contains three fact tables and four dimension tables.

```text
DIMENSION TABLES                 FACT TABLES

DimCustomer ──────────────────── FactSales
DimProduct  ──────────────────── FactSales
DimDate     ──────────────────── FactSales
DimOrder    ──────────────────── FactSales

DimCustomer ──────────────────── FactPayment
DimDate     ──────────────────── FactPayment
DimOrder    ──────────────────── FactPayment

DimCustomer ──────────────────── FactShipment
DimDate     ──────────────────── FactShipment
DimOrder    ──────────────────── FactShipment
```

**Note:** This is a simplified logical overview. The relationships shown must be verified against the actual foreign keys in the SQL Server data warehouse before being treated as the definitive database model.

## 5. Data Flow and Processing Architecture

The analytical workflow consists of the following stages:

1. **Synthetic Data Generation:** Python generates the source datasets representing customers, products, orders, order lines, payments, and shipments.
2. **Data Cleaning and Quality Checks:** Python processes the datasets and applies defined data quality rules.
3. **Staging and Data Loading:** SQL Server stores and processes the prepared data through the staging and loading workflow.
4. **Dimensional Modeling:** Dimension and fact tables are populated in the `dwh` schema.
5. **Technical Validation:** SQL queries check record counts, key consistency, and selected data quality conditions.
6. **Business Intelligence:** Power BI connects to the data warehouse to provide interactive reporting and analysis.

## 6. Design Principles

The architecture follows these principles:

- **Separation of Business Processes:** Sales, payments, and shipments are modeled independently.
- **Explicit Granularity:** Each fact table has a clearly defined level of detail.
- **Dimensional Analysis:** Dimension tables provide descriptive context for analytical queries.
- **Data Quality:** Validation checks help identify inconsistencies before they affect reporting.
- **Consistent Reporting:** Measures should be aggregated at the correct grain to avoid double-counting.
- **Extensibility:** Additional data sources and analytical capabilities may be integrated in future development.

## 7. Future Enhancements

Potential future improvements include:

- Integrating additional external or operational data sources.
- Extending the dimensional model if new analytical requirements justify additional dimensions.
- Expanding automated referential-integrity and data quality validation.
- Implementing additional financial and operational KPIs as documented in the business requirements.

These enhancements are planned possibilities and are not presented as completed functionality.
