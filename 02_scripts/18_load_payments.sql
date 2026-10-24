
-- =========================================================
-- E-Commerce Data Warehouse
-- Script: 18_load_payments.sql
-- Purpose: Load payment transactions into FactPayment
-- =========================================================

USE ECommerceDW;
GO

-- ---------------------------------------------------------
-- Check required tables
-- ---------------------------------------------------------

IF OBJECT_ID('stg.Payments', 'U') IS NULL
    THROW 50001, 'Missing table: stg.Payments', 1;

IF OBJECT_ID('dwh.FactPayment', 'U') IS NULL
    THROW 50002, 'Missing table: dwh.FactPayment', 1;

IF OBJECT_ID('dwh.DimOrder', 'U') IS NULL
    THROW 50003, 'Missing table: dwh.DimOrder', 1;

IF OBJECT_ID('dwh.DimDate', 'U') IS NULL
    THROW 50004, 'Missing table: dwh.DimDate', 1;
GO

-- ---------------------------------------------------------
-- Load payments that do not yet exist in FactPayment
-- ---------------------------------------------------------

INSERT INTO dwh.FactPayment
(
    PaymentID,
    OrderKey,
    CustomerKey,
    PaymentDateKey,
    PaymentMethod,
    PaymentStatus,
    PaymentAmount
)
SELECT
    p.PaymentID,
    o.OrderKey,
    o.CustomerKey,
    d.DateKey,
    p.PaymentMethod,
    p.PaymentStatus,
    p.PaymentAmount
FROM stg.Payments AS p
INNER JOIN dwh.DimOrder AS o
    ON p.OrderID = o.OrderID
LEFT JOIN dwh.DimDate AS d
    ON p.PaymentDate = d.[Date]
WHERE p.PaymentID IS NOT NULL
  AND NOT EXISTS
  (
      SELECT 1
      FROM dwh.FactPayment AS fp
      WHERE fp.PaymentID = p.PaymentID
  );
GO

-- ---------------------------------------------------------
-- Validate payment load
-- ---------------------------------------------------------

SELECT
    COUNT(*) AS TotalPayments,
    COUNT(DISTINCT PaymentID) AS DistinctPaymentIDs,
    SUM(PaymentAmount) AS TotalPaymentAmount
FROM dwh.FactPayment;
GO
