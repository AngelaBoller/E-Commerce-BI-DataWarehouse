
# 03. Data Dictionary

## 1. Conformed Dimensions

### `Dim_Customer`
* **Source:** `stg.Customers`
* **Grain:** One row per customer.

| Column Name | Data Type | Key Type | Nullable | Description |
| :--- | :--- | :--- | :--- | :--- |
| `CustomerSK` | `INT` | Primary Key (Surrogate) | No | Auto-incremented surrogate key. |
| `CustomerID` | `VARCHAR(20)` | Business Key | No | Unique business identifier for customer. |
| `CustomerName` | `VARCHAR(100)` | Attribute | Yes | Full name of the customer. |
| `Country` | `VARCHAR(50)` | Attribute | No | Residence country (CH, DE, AT, FR, IT). |
| `Segment` | `VARCHAR(20)` | Attribute | No | Market segment (`Standard`, `Premium`, `VIP`). |
| `RegistrationDate` | `DATE` | Attribute | No | Date when customer account was created. |

### `Dim_Product`
* **Source:** `stg.Products`
* **Grain:** One row per product.

| Column Name | Data Type | Key Type | Nullable | Description |
| :--- | :--- | :--- | :--- | :--- |
| `ProductSK` | `INT` | Primary Key (Surrogate) | No | Auto-incremented surrogate key. |
| `ProductID` | `VARCHAR(20)` | Business Key | No | Unique business SKU code. |
| `ProductName` | `VARCHAR(100)` | Attribute | No | Commercial name of the item. |
| `Category` | `VARCHAR(50)` | Attribute | No | High-level product category. |
| `Subcategory` | `VARCHAR(50)` | Attribute | No | Specific product sub-classification. |
| `Brand` | `VARCHAR(50)` | Attribute | Yes | Brand manufacturer name. |
| `UnitCost` | `DECIMAL(10,2)` | Attribute | No | Base cost price per unit. |
| `ListPrice` | `DECIMAL(10,2)` | Attribute | No | Base selling price per unit. |

### `Dim_Date`
* **Source:** Generated Calendar Dimension
* **Grain:** One row per calendar day (2024–2026).

| Column Name | Data Type | Key Type | Nullable | Description |
| :--- | :--- | :--- | :--- | :--- |
| `DateSK` | `INT` | Primary Key | No | Format `YYYYMMDD`. |
| `FullDate` | `DATE` | Attribute | No | Calendar date. |
| `Year` | `INT` | Attribute | No | Calendar year (e.g., 2025). |
| `Quarter` | `VARCHAR(2)` | Attribute | No | Quarter representation (Q1-Q4). |
| `Month` | `INT` | Attribute | No | Month number (1-12). |
| `MonthName` | `VARCHAR(20)` | Attribute | No | Full month name (e.g., January). |
| `DayOfWeek` | `VARCHAR(20)` | Attribute | No | Day name (e.g., Monday). |

---

## 2. Fact Tables

### `Fact_Sales`
* **Grain:** One row per **Order Line Item**.

| Column Name | Data Type | Key Type | Nullable | Description |
| :--- | :--- | :--- | :--- | :--- |
| `SalesFactID` | `BIGINT` | Primary Key | No | Auto-incremented surrogate key. |
| `OrderLineID` | `VARCHAR(30)` | Business Key | No | Unique identifier for order line item. |
| `OrderID` | `VARCHAR(20)` | Attribute / Degenerate | No | Parent order reference number. |
| `DateSK` | `INT` | Foreign Key | No | FK to `Dim_Date`. |
| `CustomerSK` | `INT` | Foreign Key | No | FK to `Dim_Customer`. |
| `ProductSK` | `INT` | Foreign Key | No | FK to `Dim_Product`. |
| `Channel` | `VARCHAR(30)` | Attribute | No | Sales channel (`Webshop`, `App`, `Marketplace`). |
| `Quantity` | `INT` | Measure | No | Units purchased. |
| `UnitPrice` | `DECIMAL(10,2)` | Measure | No | Effective unit selling price. |
| `Discount` | `DECIMAL(10,2)` | Measure | No | Discount value applied. |
| `LineNetAmount` | `DECIMAL(10,2)` | Measure | No | Total line net revenue: `(Qty * Price) - Discount`. |

### `Fact_Payment`
* **Grain:** One row per **Payment Transaction**.

| Column Name | Data Type | Key Type | Nullable | Description |
| :--- | :--- | :--- | :--- | :--- |
| `PaymentFactID` | `BIGINT` | Primary Key | No | Auto-incremented surrogate key. |
| `PaymentID` | `VARCHAR(20)` | Business Key | No | Transaction reference identifier. |
| `OrderID` | `VARCHAR(20)` | Attribute / Degenerate | No | Associated parent order. |
| `DateSK` | `INT` | Foreign Key | No | FK to `Dim_Date` (Payment Date). |
| `CustomerSK` | `INT` | Foreign Key | No | FK to `Dim_Customer`. |
| `PaymentMethod` | `VARCHAR(30)` | Attribute | No | Method used (`CreditCard`, `PayPal`, `Invoice`, etc.). |
| `PaymentStatus` | `VARCHAR(20)` | Attribute | No | Status (`Completed`, `Failed`, `Pending`). |
| `PaymentAmount` | `DECIMAL(10,2)` | Measure | No | Settled payment transaction amount. |

### `Fact_Shipment`
* **Grain:** One row per **Shipment Package Event**.

| Column Name | Data Type | Key Type | Nullable | Description |
| :--- | :--- | :--- | :--- | :--- |
| `ShipmentFactID` | `BIGINT` | Primary Key | No | Auto-incremented surrogate key. |
| `ShipmentID` | `VARCHAR(20)` | Business Key | No | Package tracking reference number. |
| `OrderID` | `VARCHAR(20)` | Attribute / Degenerate | No | Associated parent order. |
| `ShipmentDateSK` | `INT` | Foreign Key | No | FK to `Dim_Date` (Dispatch Date). |
| `DeliveryDateSK` | `INT` | Foreign Key | Yes | FK to `Dim_Date` (Actual Delivery Date). |
| `CustomerSK` | `INT` | Foreign Key | No | FK to `Dim_Customer`. |
| `Carrier` | `VARCHAR(50)` | Attribute | No | Shipping carrier name (`DHL`, `SwissPost`, etc.). |
| `ShipmentStatus` | `VARCHAR(20)` | Attribute | No | Delivery status (`Delivered`, `In Transit`, `Returned`). |
| `ShippingCost` | `DECIMAL(10,2)` | Measure | No | Carrier charge amount. |
