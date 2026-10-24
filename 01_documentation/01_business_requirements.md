# 01. Business Requirements & KPI Definitions

## 1. Executive Summary

The objective of this data warehouse project is to establish a centralized and reliable analytical foundation for a fictional international e-commerce business.

The solution integrates sales, payment, and shipment data into a SQL Server data warehouse using a Galaxy Schema design. Python is used for synthetic data generation, data cleaning, and data quality checks. Power BI provides interactive dashboards for business reporting and analysis.

This document defines the business requirements, key analytical questions, and KPI definitions that guide the project. It distinguishes between KPIs currently implemented in the dashboard and additional KPIs planned for future development.

## 2. Business Objectives

The main business objectives are:

- **Unified Sales Visibility:** Provide a consolidated view of sales performance, order volumes, and revenue trends.
- **Product Performance Analysis:** Analyze sales volume and revenue across products and product categories.
- **Payment Monitoring:** Support the analysis of payment amounts, transaction volumes, payment methods, and payment statuses.
- **Logistics Performance:** Analyze shipment activity and delivery duration.
- **Customer Insights:** Understand customer distribution and sales performance across countries and customer segments.
- **Data Quality and Reliability:** Identify and address data quality issues during data preparation and loading.
- **Scalable Analytical Architecture:** Separate sales, payment, and shipment processes into fact tables with clearly defined levels of detail.

## 3. Business Questions

| Business Domain | Key Business Questions | Analytical Dimensions |
|---|---|---|
| Sales Performance | How does revenue develop over time? How many orders are placed? Which months generate the highest sales? | Date, Country, Channel |
| Product Performance | Which products and categories generate the highest revenue and sales volume? | Product, Category |
| Payment Operations | What payment amounts are recorded? How are transactions distributed across payment methods and statuses? | Date, Payment Method, Payment Status |
| Fulfillment and Logistics | How long does delivery take? How does delivery duration vary over time or across markets? | Date, Country, Shipment |
| Customer Insights | How are customers distributed across countries and customer segments? Which markets contribute most to revenue? | Customer, Country, Segment |
| Data Quality | Are records complete, consistent, and valid? Can data quality issues be detected before analytical reporting? | Data quality rules, source tables |

These questions describe the business requirements for the analytical solution. Some questions may require additional measures or data fields before they can be answered fully.

## 4. Current Dashboard KPIs

The following KPIs are currently represented in the Power BI dashboard.

| KPI | Definition | Business Purpose |
|---|---|---|
| Total Revenue | Revenue calculated from the sales data used by the dashboard | Monitor overall sales performance |
| Total Orders | Number of distinct orders | Track order volume |
| Total Customers | Number of customers represented in the analysis | Understand customer scale |
| Units Sold | Total quantity of products sold | Measure sales volume |
| Payment Amount | Sum of recorded payment amounts | Monitor payment-related amounts |
| Average Delivery Duration | Average delivery duration in days, according to the implemented calculation | Monitor delivery performance |

The exact calculation of each KPI depends on the measures implemented in the Power BI model. Revenue and payment amounts represent different business processes and should not automatically be interpreted as equivalent financial totals.

## 5. Planned KPI Enhancements

The following KPIs are defined as future enhancements. Their formulas document the intended business logic; they are not claimed to be implemented in the current dashboard.

### 5.1 Financial and Commercial KPIs

**Total Gross Revenue**

Intended definition: the total value of order lines before discounts.

\[
\text{Gross Revenue} = \sum(\text{Quantity} \times \text{UnitPrice})
\]

**Total Net Revenue**

Intended definition: gross revenue after deducting applicable discounts.

\[
\text{Net Revenue} = \sum((\text{Quantity} \times \text{UnitPrice})-\text{Discount})
\]

The calculation depends on how discounts are stored in the source data and whether they are recorded per unit or per order line.

**Total Cost of Goods Sold (COGS)**

Intended definition: the total product cost associated with sold quantities.

\[
\text{COGS} = \sum(\text{Quantity} \times \text{UnitCost})
\]

This KPI requires a reliable unit-cost field in the product or sales data.

**Gross Profit**

Intended definition: net revenue less cost of goods sold.

\[
\text{Gross Profit} = \text{Net Revenue} - \text{COGS}
\]

**Gross Profit Margin**

Intended definition: gross profit as a percentage of net revenue.

\[
\text{Gross Profit Margin (\%)} =
\frac{\text{Gross Profit}}{\text{Net Revenue}} \times 100
\]

The calculation should handle cases where net revenue is zero or missing.

**Average Order Value (AOV)**

Intended definition: net revenue divided by the number of distinct orders.

\[
\text{AOV} =
\frac{\text{Net Revenue}}{\text{Distinct Orders}}
\]

### 5.2 Payment Operations KPIs

**Payment Settlement Rate**

Intended definition: the proportion of payment transactions classified as successful.

\[
\text{Settlement Rate (\%)} =
\frac{\text{Successful Payment Transactions}}
{\text{Total Payment Transactions}} \times 100
\]

The calculation requires a consistent definition of a successful payment status. It measures the share of successful transactions, not necessarily the share of orders fully paid.

### 5.3 Fulfillment and Logistics KPIs

**Fulfillment Lead Time**

Intended definition: the elapsed time between order creation and shipment dispatch.

\[
\text{Fulfillment Lead Time} =
\text{Shipment Date} - \text{Order Date}
\]

The unit of measurement is days. The implementation should confirm which shipment date represents dispatch and how missing or invalid dates are handled.

**On-Time Delivery Rate**

A potential future KPI is the percentage of shipments delivered on or before the promised delivery date.

\[
\text{On-Time Delivery Rate (\%)} =
\frac{\text{Shipments Delivered On Time}}
{\text{Eligible Delivered Shipments}} \times 100
\]

This KPI requires a reliable promised delivery date and an agreed definition of eligible shipments.

## 6. Data Quality Requirements

Data quality is an integral part of the analytical workflow.

The project includes data quality checks during data preparation and validation of the data warehouse. The requirements include:

- Identifying missing, invalid, or inconsistent values.
- Checking identifiers and relationships between related entities.
- Detecting invalid or unexpected numerical values.
- Checking data consistency across orders, order lines, payments, and shipments.
- Validating expected record counts and the presence of required dimension members.
- Preventing identified data quality issues from silently affecting analytical results.

The checks are implemented through the project's Python and SQL workflow. Individual checks and validation results are documented separately where applicable.

## 7. Data Warehouse Design Requirements

The data warehouse follows a Galaxy Schema design with three fact tables representing separate business processes.

### Fact Tables

- **FactSales:** One record per order line.
- **FactPayment:** One record per payment transaction.
- **FactShipment:** One record per shipment record.

### Dimension Tables

- **DimCustomer:** Customer-related attributes.
- **DimProduct:** Product-related attributes.
- **DimDate:** Calendar attributes for time-based analysis.
- **DimOrder:** Order-related attributes.

The separation of fact tables preserves the distinct granularity of sales, payments, and shipments. Analytical queries must respect these different levels of detail to avoid unintended duplication when combining measures.

## 8. Scope and Future Development

The current project provides an end-to-end analytical workflow using synthetic e-commerce data, Python, SQL Server, and Power BI.

Potential future enhancements include:

- Implementing the planned financial, payment, and logistics KPIs.
- Expanding dashboard analysis with additional business measures.
- Integrating additional data sources to enrich the existing analytical model.
- Extending automated data quality checks and technical validation.
- Improving documentation of KPI definitions, assumptions, and calculation logic.

These items represent planned development and are not presented as completed functionality.

## 9. Data Disclaimer

The e-commerce data used in this project is synthetic and created for demonstration and portfolio purposes. It does not represent actual customers, transactions, or financial performance of a real
