
USE ECommerceDW;

-- =========================================================
-- 
-- Fact Payment
-- Grain:
-- One row = one payment transaction
-- =========================================================

CREATE TABLE dwh.FactPayment
(
    PaymentID       VARCHAR(20)   NOT NULL,
    OrderKey        INT           NOT NULL,
    CustomerKey     INT           NOT NULL,
    PaymentDateKey  INT           NULL,
    PaymentMethod   VARCHAR(50)   NULL,
    PaymentStatus   VARCHAR(50)   NULL,
    PaymentAmount   DECIMAL(18,2) NULL,

    CONSTRAINT PK_FactPayment
        PRIMARY KEY (PaymentID)
);
