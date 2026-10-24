
-- =========================================================
-- E-Commerce Data Warehouse
-- Script: 25_DWH_Technical_Validation.sql
-- Purpose: Validate DWH row counts, keys, relationships,
--          measures, date logic and intentional DQ handling
-- Note: Read-only validation. No data is modified.
-- =========================================================

USE ECommerceDW;
GO

-- ---------------------------------------------------------
-- 1. Row Count Validation
-- ---------------------------------------------------------

SELECT
    v.TableName,
    v.ExpectedRows,
    v.ActualRows,
    CASE
        WHEN v.ActualRows = v.ExpectedRows THEN 'PASS'
        ELSE 'FAIL'
    END AS Result
FROM
(
    SELECT 'DimCustomer' AS TableName, 10001 AS ExpectedRows,
           COUNT_BIG(*) AS ActualRows FROM dwh.DimCustomer
    UNION ALL
    SELECT 'DimProduct', 501, COUNT_BIG(*) FROM dwh.DimProduct
    UNION ALL
    SELECT 'DimDate', 5844, COUNT_BIG(*) FROM dwh.DimDate
    UNION ALL
    SELECT 'DimOrder', 100000, COUNT_BIG(*) FROM dwh.DimOrder
    UNION ALL
    SELECT 'FactSales', 299131, COUNT_BIG(*) FROM dwh.FactSales
    UNION ALL
    SELECT 'FactPayment', 100000, COUNT_BIG(*) FROM dwh.FactPayment
    UNION ALL
    SELECT 'FactShipment', 94974, COUNT_BIG(*) FROM dwh.FactShipment
) AS v
ORDER BY v.TableName;
GO

-- ---------------------------------------------------------
-- 2. UNKNOWN Member Validation
-- ---------------------------------------------------------

SELECT
    v.Validation,
    v.ActualRows,
    v.ExpectedRows,
    CASE
        WHEN v.ActualRows = v.ExpectedRows THEN 'PASS'
        ELSE 'FAIL'
    END AS Result
FROM
(
    SELECT 'DimCustomer UNKNOWN' AS Validation,
           COUNT_BIG(*) AS ActualRows, 1 AS ExpectedRows
    FROM dwh.DimCustomer
    WHERE CustomerKey = -1

    UNION ALL

    SELECT 'DimProduct UNKNOWN',
           COUNT_BIG(*), 1
    FROM dwh.DimProduct
    WHERE ProductKey = -1
) AS v;
GO

-- ---------------------------------------------------------
-- 3. Dimension Business Key Duplicates
-- Expected: zero duplicate groups
-- ---------------------------------------------------------

SELECT
    v.Validation,
    v.DuplicateGroups,
    CASE
        WHEN v.DuplicateGroups = 0 THEN 'PASS'
        ELSE 'FAIL'
    END AS Result
FROM
(
    SELECT
        'DimCustomer.CustomerID' AS Validation,
        COUNT_BIG(*) AS DuplicateGroups
    FROM
    (
        SELECT CustomerID
        FROM dwh.DimCustomer
        WHERE CustomerKey <> -1
        GROUP BY CustomerID
        HAVING COUNT(*) > 1
    ) AS c

    UNION ALL

    SELECT
        'DimProduct.ProductID',
        COUNT_BIG(*)
    FROM
    (
        SELECT ProductID
        FROM dwh.DimProduct
        WHERE ProductKey <> -1
        GROUP BY ProductID
        HAVING COUNT(*) > 1
    ) AS p

    UNION ALL

    SELECT
        'DimOrder.OrderID',
        COUNT_BIG(*)
    FROM
    (
        SELECT OrderID
        FROM dwh.DimOrder
        GROUP BY OrderID
        HAVING COUNT(*) > 1
    ) AS o
) AS v;
GO

-- ---------------------------------------------------------
-- 4. Fact Grain Duplicates
-- Expected: zero duplicate groups
-- ---------------------------------------------------------

SELECT
    v.Validation,
    v.DuplicateGroups,
    CASE
        WHEN v.DuplicateGroups = 0 THEN 'PASS'
        ELSE 'FAIL'
    END AS Result
FROM
(
    SELECT
        'FactSales.OrderItemID' AS Validation,
        COUNT_BIG(*) AS DuplicateGroups
    FROM
    (
        SELECT OrderItemID
        FROM dwh.FactSales
        GROUP BY OrderItemID
        HAVING COUNT(*) > 1
    ) AS s

    UNION ALL

    SELECT
        'FactPayment.PaymentID',
        COUNT_BIG(*)
    FROM
    (
        SELECT PaymentID
        FROM dwh.FactPayment
        GROUP BY PaymentID
        HAVING COUNT(*) > 1
    ) AS p

    UNION ALL

    SELECT
        'FactShipment.ShipmentID',
        COUNT_BIG(*)
    FROM
    (
        SELECT ShipmentID
        FROM dwh.FactShipment
        GROUP BY ShipmentID
        HAVING COUNT(*) > 1
    ) AS sh
) AS v;
GO

-- ---------------------------------------------------------
-- 5. Fact-to-Dimension Referential Integrity
-- Expected: zero invalid references
-- ---------------------------------------------------------

SELECT
    v.Validation,
    v.InvalidRows,
    CASE
        WHEN v.InvalidRows = 0 THEN 'PASS'
        ELSE 'FAIL'
    END AS Result
FROM
(
    SELECT
        'FactSales -> DimCustomer' AS Validation,
        COUNT_BIG(*) AS InvalidRows
    FROM dwh.FactSales AS f
    LEFT JOIN dwh.DimCustomer AS d
        ON f.CustomerKey = d.CustomerKey
    WHERE d.CustomerKey IS NULL

    UNION ALL

    SELECT
        'FactSales -> DimProduct',
        COUNT_BIG(*)
    FROM dwh.FactSales AS f
    LEFT JOIN dwh.DimProduct AS d
        ON f.ProductKey = d.ProductKey
    WHERE d.ProductKey IS NULL

    UNION ALL

    SELECT
        'FactSales -> DimOrder',
        COUNT_BIG(*)
    FROM dwh.FactSales AS f
    LEFT JOIN dwh.DimOrder AS d
        ON f.OrderKey = d.OrderKey
    WHERE d.OrderKey IS NULL

    UNION ALL

    SELECT
        'FactPayment -> DimCustomer',
        COUNT_BIG(*)
    FROM dwh.FactPayment AS f
    LEFT JOIN dwh.DimCustomer AS d
        ON f.CustomerKey = d.CustomerKey
    WHERE d.CustomerKey IS NULL

    UNION ALL

    SELECT
        'FactPayment -> DimOrder',
        COUNT_BIG(*)
    FROM dwh.FactPayment AS f
    LEFT JOIN dwh.DimOrder AS d
        ON f.OrderKey = d.OrderKey
    WHERE d.OrderKey IS NULL

    UNION ALL

    SELECT
        'FactShipment -> DimCustomer',
        COUNT_BIG(*)
    FROM dwh.FactShipment AS f
    LEFT JOIN dwh.DimCustomer AS d
        ON f.CustomerKey = d.CustomerKey
    WHERE d.CustomerKey IS NULL

    UNION ALL

    SELECT
        'FactShipment -> DimOrder',
        COUNT_BIG(*)
    FROM dwh.FactShipment AS f
    LEFT JOIN dwh.DimOrder AS d
        ON f.OrderKey = d.OrderKey
    WHERE d.OrderKey IS NULL
) AS v;
GO

-- ---------------------------------------------------------
-- 6. Fact-to-Date Dimension Validation
-- NULL date keys and invalid non-NULL references are
-- reported separately because date keys may be optional.
-- ---------------------------------------------------------

SELECT
    v.Validation,
    v.IssueType,
    v.IssueRows
FROM
(
    SELECT
        'FactSales.OrderDateKey' AS Validation,
        'NULL date key' AS IssueType,
        COUNT_BIG(*) AS IssueRows
    FROM dwh.FactSales
    WHERE OrderDateKey IS NULL

    UNION ALL

    SELECT
        'FactSales.OrderDateKey',
        'Invalid non-NULL date key',
        COUNT_BIG(*)
    FROM dwh.FactSales AS f
    LEFT JOIN dwh.DimDate AS d
        ON f.OrderDateKey = d.DateKey
    WHERE f.OrderDateKey IS NOT NULL
      AND d.DateKey IS NULL

    UNION ALL

    SELECT
        'FactPayment.PaymentDateKey',
        'NULL date key',
        COUNT_BIG(*)
    FROM dwh.FactPayment
    WHERE PaymentDateKey IS NULL

    UNION ALL

    SELECT
        'FactPayment.PaymentDateKey',
        'Invalid non-NULL date key',
        COUNT_BIG(*)
    FROM dwh.FactPayment AS f
    LEFT JOIN dwh.DimDate AS d
        ON f.PaymentDateKey = d.DateKey
    WHERE f.PaymentDateKey IS NOT NULL
      AND d.DateKey IS NULL

    UNION ALL

    SELECT
        'FactShipment.ShipmentDateKey',
        'NULL date key',
        COUNT_BIG(*)
    FROM dwh.FactShipment
    WHERE ShipmentDateKey IS NULL

    UNION ALL

    SELECT
        'FactShipment.ShipmentDateKey',
        'Invalid non-NULL date key',
        COUNT_BIG(*)
    FROM dwh.FactShipment AS f
    LEFT JOIN dwh.DimDate AS d
        ON f.ShipmentDateKey = d.DateKey
    WHERE f.ShipmentDateKey IS NOT NULL
      AND d.DateKey IS NULL

    UNION ALL

    SELECT
        'FactShipment.DeliveryDateKey',
        'NULL date key',
        COUNT_BIG(*)
    FROM dwh.FactShipment
    WHERE DeliveryDateKey IS NULL

    UNION ALL

    SELECT
        'FactShipment.DeliveryDateKey',
        'Invalid non-NULL date key',
        COUNT_BIG(*)
    FROM dwh.FactShipment AS f
    LEFT JOIN dwh.DimDate AS d
        ON f.DeliveryDateKey = d.DateKey
    WHERE f.DeliveryDateKey IS NOT NULL
      AND d.DateKey IS NULL
) AS v
ORDER BY v.Validation, v.IssueType;
GO

-- ---------------------------------------------------------
-- 7. Fact Measure Checks
-- Negative values are flagged for review.
-- They are not automatically classified as errors.
-- ---------------------------------------------------------

SELECT
    v.Validation,
    v.InvalidRows,
    CASE
        WHEN v.InvalidRows = 0 THEN 'PASS'
        ELSE 'CHECK'
    END AS Result
FROM
(
    SELECT
        'FactSales Quantity < 0' AS Validation,
        COUNT_BIG(*) AS InvalidRows
    FROM dwh.FactSales
    WHERE Quantity < 0

    UNION ALL

    SELECT
        'FactSales UnitPrice < 0',
        COUNT_BIG(*)
    FROM dwh.FactSales
    WHERE UnitPrice < 0

    UNION ALL

    SELECT
        'FactSales SalesAmount < 0',
        COUNT_BIG(*)
    FROM dwh.FactSales
    WHERE SalesAmount < 0

    UNION ALL

    SELECT
        'FactPayment PaymentAmount < 0',
        COUNT_BIG(*)
    FROM dwh.FactPayment
    WHERE PaymentAmount < 0

    UNION ALL

    SELECT
        'FactShipment DeliveryDurationDays < 0',
        COUNT_BIG(*)
    FROM dwh.FactShipment
    WHERE DeliveryDurationDays < 0
) AS v;
GO

-- ---------------------------------------------------------
-- 8. Intentional Data Quality Cases
-- Expected values are project-specific and should be
-- rechecked if the processed data changes.
-- ---------------------------------------------------------

SELECT
    v.Validation,
    v.ActualRows,
    v.ExpectedRows,
    CASE
        WHEN v.ActualRows = v.ExpectedRows THEN 'PASS'
        ELSE 'CHECK'
    END AS Result
FROM
(
    SELECT
        'FactSales Unknown ProductKey' AS Validation,
        COUNT_BIG(*) AS ActualRows,
        200 AS ExpectedRows
    FROM dwh.FactSales
    WHERE ProductKey = -1

    UNION ALL

    SELECT
        'FactSales Quantity = 0',
        COUNT_BIG(*),
        100
    FROM dwh.FactSales
    WHERE Quantity = 0

    UNION ALL

    SELECT
        'FactSales UnitPrice = 0',
        COUNT_BIG(*),
        100
    FROM dwh.FactSales
    WHERE UnitPrice = 0

    UNION ALL

    SELECT
        'DimOrder UNKNOWN Customer',
        COUNT_BIG(*),
        100
    FROM dwh.DimOrder
    WHERE CustomerKey = -1
) AS v;
GO

-- ---------------------------------------------------------
-- 9. Shipment Date Logic
-- Compare actual dates rather than integer date keys.
-- Rows with missing or invalid date references are not
-- evaluated by this check; see Section 6.
-- ---------------------------------------------------------

SELECT
    'Delivery before Shipment' AS Validation,
    COUNT_BIG(*) AS InvalidRows,
    CASE
        WHEN COUNT_BIG(*) = 0 THEN 'PASS'
        ELSE 'CHECK'
    END AS Result
FROM dwh.FactShipment AS f
INNER JOIN dwh.DimDate AS shipmentDate
    ON f.ShipmentDateKey = shipmentDate.DateKey
INNER JOIN dwh.DimDate AS deliveryDate
    ON f.DeliveryDateKey = deliveryDate.DateKey
WHERE deliveryDate.[Date] < shipmentDate.[Date];
GO

-- ---------------------------------------------------------
-- 10. NULL Required Keys in Facts
-- ---------------------------------------------------------

SELECT
    v.Validation,
    v.InvalidRows,
    CASE
        WHEN v.InvalidRows = 0 THEN 'PASS'
        ELSE 'FAIL'
    END AS Result
FROM
(
    SELECT
        'FactSales NULL CustomerKey' AS Validation,
        COUNT_BIG(*) AS InvalidRows
    FROM dwh.FactSales
    WHERE CustomerKey IS NULL

    UNION ALL

    SELECT
        'FactSales NULL ProductKey',
        COUNT_BIG(*)
    FROM dwh.FactSales
    WHERE ProductKey IS NULL

    UNION ALL

    SELECT
        'FactSales NULL OrderKey',
        COUNT_BIG(*)
    FROM dwh.FactSales
    WHERE OrderKey IS NULL

    UNION ALL

    SELECT
        'FactPayment NULL CustomerKey',
        COUNT_BIG(*)
    FROM dwh.FactPayment
    WHERE CustomerKey IS NULL

    UNION ALL

    SELECT
        'FactPayment NULL OrderKey',
        COUNT_BIG(*)
    FROM dwh.FactPayment
    WHERE OrderKey IS NULL

    UNION ALL

    SELECT
        'FactShipment NULL CustomerKey',
        COUNT_BIG(*)
    FROM dwh.FactShipment
    WHERE CustomerKey IS NULL

    UNION ALL

    SELECT
        'FactShipment NULL OrderKey',
        COUNT_BIG(*)
    FROM dwh.FactShipment
    WHERE OrderKey IS NULL
) AS v;
GO

-- ---------------------------------------------------------
-- 11. Validation Completed
-- This confirms script completion, not that every check
-- passed. Review all result sets above.
-- ---------------------------------------------------------

SELECT
    'DWH Technical Validation completed' AS Status,
    GETDATE() AS ValidationTimestamp;
GO
