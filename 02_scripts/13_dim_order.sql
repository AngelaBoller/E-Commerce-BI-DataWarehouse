
USE ECommerceDW;

-- =========================================================
-- 13_dimension_order.sql
-- Create Order Dimension
-- =========================================================

CREATE TABLE dwh.DimOrder
(
    OrderKey       INT          NOT NULL,
    OrderID        VARCHAR(20)  NOT NULL,
    CustomerKey    INT          NOT NULL,
    OrderDateKey   INT          NULL,
    OrderDate      DATE         NULL,
    Channel        VARCHAR(50)  NULL,
    OrderStatus    VARCHAR(50)  NULL,

    CONSTRAINT PK_DimOrder
        PRIMARY KEY (OrderKey),

    CONSTRAINT UQ_DimOrder_OrderID
        UNIQUE (OrderID)
);
