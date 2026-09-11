
# 02. Data Architecture & Dimensional Model

## 1. Architectural Approach: Galaxy Schema (Fact Constellation)

Traditional Star Schemas merge all operational measures into a single fact table. However, in this e-commerce platform, **Sales**, **Payments**, and **Shipments** occur at different times, possess different business keys, and operate at distinct operational grains:

* **Sales Orders:** Grain = Individual Order Line Item (`OrderItemID`)
* **Payments:** Grain = Payment Transaction (`PaymentID` / Header Level)
* **Shipments:** Grain = Delivery Package / Dispatch Event (`ShipmentID`)

Forcing these into one table leads to severe join fan-outs and null-value inflation. Thus, a **Galaxy Schema** architecture is implemented, anchored by shared **Conformed Dimensions**.

```text
               [Dim_Customer]        [Dim_Date]        [Dim_Channel]
                     \                   |                   /
                      +------------------+------------------+
                      |                  |                  |
               [Fact_Sales]       [Fact_Payment]     [Fact_Shipment]
                      |                  |                  |
               [Dim_Product]    [Dim_PaymentMethod]   [Dim_Carrier]
