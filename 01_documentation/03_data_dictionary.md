# 03. Data Dictionary

## 1. Overview

This document describes the structure of the SQL Server e-commerce data warehouse implemented in the `dwh` schema.

The data warehouse consists of four dimension tables and three fact tables:

**Dimension tables**
- `DimCustomer`
- `DimProduct`
- `DimDate`
- `DimOrder`

**Fact tables**
- `FactSales`
- `FactPayment`
- `FactShipment`

The definitions below reflect the column names, SQL Server data types, nullability, and primary-key information retrieved from the database.

## 2. Dimension Tables

### 2.1 DimCustomer

**Purpose:** Stores customer attributes for customer, country, and segment analysis.

**Grain:** One row per customer.

| Column | Data Type | Key / Role | Nullable | Description |
|---|---|---|---|---|
| `CustomerKey` | `INT` | Primary Key | No | Customer surrogate key. |
| `CustomerID` | `VARCHAR(20)` | Business Identifier | No | Customer identifier from the source data. |
| `Name` | `VARCHAR(200)` | Attribute | Yes | Customer name. |
| `Country` | `VARCHAR(100)` | Attribute | Yes | Customer country. |
| `Segment` | `VARCHAR(50)` | Attribute | Yes | Customer segment. |
| `RegistrationDate` | `DATE` | Attribute | Yes | Date the customer registered. |

### 2.2 DimProduct

**Purpose:** Stores descriptive product attributes and product cost and pricing information.

**Grain:** One row per product.

| Column | Data Type | Key / Role | Nullable | Description |
|---|---|---|---|---|
| `ProductKey` | `INT` | Primary Key | No | Product surrogate key. |
| `ProductID` | `VARCHAR(20)` | Business Identifier | No | Product identifier from the source data. |
| `ProductName` | `VARCHAR(200)` | Attribute | Yes | Product name. |
| `Category` | `VARCHAR(100)` | Attribute | Yes | Product category. |
| `Subcategory` | `VARCHAR(100)` | Attribute | Yes | Product subcategory. |
| `Brand` | `VARCHAR(100)` | Attribute | Yes | Product brand. |
| `UnitCost` | `DECIMAL(18,2)` | Attribute | Yes | Cost per product unit. |
| `ListPrice` | `DECIMAL(18,2)` | Attribute | Yes | Listed selling price per product unit. |

### 2.3 DimDate

**Purpose:** Provides calendar attributes for time-based reporting.

**Grain:** One row per calendar date.

The dimension contains 5,844 rows covering 1 January 2020 through 31 December 2035.

| Column | Data Type | Key / Role | Nullable | Description |
|---|---|---|---|---|
| `DateKey` | `INT` | Primary Key | No | Date key used for date-based analysis. |
| `Date` | `DATE` | Date Attribute | No | Full calendar date. |
| `Year` | `INT` | Attribute | No | Calendar year. |
| `Quarter` | `INT` | Attribute | No | Calendar quarter. |
| `Month` | `INT` | Attribute | No | Month number. |
| `MonthName` | `VARCHAR(20)` | Attribute | No | Month name. |
| `Week` | `INT` | Attribute | No | Week number. |
| `Day` | `INT` | Attribute | No | Day of the month. |
| `DayOfWeek` | `INT` | Attribute | No | Numeric day-of-week value. |
| `DayName` | `VARCHAR(20)` | Attribute | No | Name of the day. |
| `IsWeekend` | `BIT` | Attribute | No | Indicates whether the date is classified as a weekend. |

### 2.4 DimOrder

**Purpose:** Stores order-level attributes for order analysis and filtering.

**Grain:** One row per order.

| Column | Data Type | Key / Role | Nullable | Description |
|---|---|---|---|---|
| `OrderKey` | `INT` | Primary Key | No | Order surrogate key. |
| `OrderID` | `VARCHAR(20)` | Business Identifier | No | Order identifier from the source data. |
| `CustomerKey` | `INT` | Attribute / Relationship Key | No | Customer key associated with the order. |
| `OrderDateKey` | `INT` | Attribute / Date Key | Yes | Date key associated with the order date. |
| `OrderDate` | `DATE` | Attribute | Yes | Order creation date. |
| `Channel` | `VARCHAR(50)` | Attribute | Yes | Sales channel associated with the order. |
| `OrderStatus` | `VARCHAR(50)` | Attribute | Yes | Order status. |

## 3. Fact Tables

### 3.1 FactSales

**Purpose:** Stores sales measures at order-line level.

**Grain:** One row per order line.

| Column | Data Type | Key / Role | Nullable | Description |
|---|---|---|---|---|
| `OrderItemID` | `VARCHAR(20)` | Primary Key | No | Identifier for the order line item. |
| `OrderKey` | `INT` | Relationship Key | No | Key identifying the associated order. |
| `CustomerKey` | `INT` | Relationship Key | No | Key identifying the associated customer. |
| `ProductKey` | `INT` | Relationship Key | No | Key identifying the associated product. |
| `OrderDateKey` | `INT` | Date Key | Yes | Date key associated with the order date. |
| `Quantity` | `INT` | Measure | No | Quantity of products purchased. |
| `UnitPrice` | `DECIMAL(18,2)` | Measure | No | Unit selling price recorded for the order line. |
| `Discount` | `DECIMAL(18,2)` | Measure | Yes | Discount amount recorded for the order line. |
| `SalesAmount` | `DECIMAL(18,2)` | Measure | Yes | Sales amount recorded for the order line. |

### 3.2 FactPayment

**Purpose:** Stores payment transactions associated with orders and customers.

**Grain:** One row per payment transaction.

| Column | Data Type | Key / Role | Nullable | Description |
|---|---|---|---|---|
| `PaymentID` | `VARCHAR(20)` | Primary Key | No | Payment transaction identifier. |
| `OrderKey` | `INT` | Relationship Key | No | Key identifying the associated order. |
| `CustomerKey` | `INT` | Relationship Key | No | Key identifying the associated customer. |
| `PaymentDateKey` | `INT` | Date Key | Yes | Date key associated with the payment date. |
| `PaymentMethod` | `VARCHAR(50)` | Attribute | Yes | Payment method used. |
| `PaymentStatus` | `VARCHAR(50)` | Attribute | Yes | Payment transaction status. |
| `PaymentAmount` | `DECIMAL(18,2)` | Measure | Yes | Payment amount recorded for the transaction. |

### 3.3 FactShipment

**Purpose:** Stores shipment information for delivery and logistics analysis.

**Grain:** One row per shipment record.

| Column | Data Type | Key / Role | Nullable | Description |
|---|---|---|---|---|
| `ShipmentID` | `VARCHAR(20)` | Primary Key | No | Shipment identifier. |
| `OrderKey` | `INT` | Relationship Key | No | Key identifying the associated order. |
| `CustomerKey` | `INT` | Relationship Key | No | Key identifying the associated customer. |
| `ShipmentDateKey` | `INT` | Date Key | Yes | Date key associated with the shipment date. |
| `DeliveryDateKey` | `INT` | Date Key | Yes | Date key associated with the delivery date. |
| `ShippingCountry` | `VARCHAR(100)` | Attribute | Yes | Shipping destination country. |
| `ShippingStatus` | `VARCHAR(50)` | Attribute | Yes | Shipment or delivery status. |
| `DeliveryDurationDays` | `INT` | Measure | Yes | Recorded delivery duration in days. |

## 4. Keys and Relationships

The database metadata identifies the following primary keys:

- `DimCustomer.CustomerKey`
- `DimProduct.ProductKey`
- `DimDate.DateKey`
- `DimOrder.OrderKey`
- `FactSales.OrderItemID`
- `FactPayment.PaymentID`
- `FactShipment.ShipmentID`

Several fact-table columns are intended to associate transactions with dimensions, orders, and dates. The column metadata query used for this document did not return foreign-key constraints.

Consequently, the intended analytical relationships should be verified against the actual Power BI model and SQL Server relationship definitions before being documented as enforced foreign keys.

## 5. Data Types and Nullability

The warehouse uses the following main SQL Server data types:

- `INT` for surrogate keys, calendar attributes, and quantities.
- `VARCHAR` for business identifiers and descriptive attributes.
- `DATE` for calendar and business dates.
- `DECIMAL(18,2)` for monetary values.
- `BIT` for the weekend indicator.

A column marked as nullable can contain SQL `NULL` values. This describes the database schema and does not necessarily mean that NULL values are present in the current data.

## 6. Notes and Limitations

- Column definitions and key information are based on the SQL Server metadata retrieved from the `dwh` schema.
- Descriptions explain the apparent business purpose of the columns; they do not replace validation of the underlying calculation logic.
- The exact formulas used to calculate `SalesAmount` and `PaymentAmount` should be confirmed in the corresponding loading scripts.
- Foreign-key relationships and referential integrity should be documented separately after verification.
- Additional KPIs and analytical capabilities are described in `01_business_requirements`.

