
USE ECommerceDW;

-- =========================================================

-- Create Sales Fact Table
-- Grain:
-- One row = one product line within one order
-- =========================================================

CREATE TABLE dwh.FactSales
(
    OrderItemID  VARCHAR(20)   NOT NULL,
    OrderKey     INT           NOT NULL,
    CustomerKey  INT           NOT NULL,
    ProductKey   INT           NOT NULL,
    OrderDateKey INT           NULL,

    Quantity     INT           NOT NULL,
    UnitPrice    DECIMAL(18,2) NOT NULL,
    Discount     DECIMAL(18,2) NULL,
    SalesAmount  DECIMAL(18,2) NULL,

    CONSTRAINT PK_FactSales
        PRIMARY KEY (OrderItemID)
);

