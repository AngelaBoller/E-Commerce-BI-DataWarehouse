-- 
-- Technical validation of the ECommerceDW Data Warehouse

USE ECommerceDW;

-- 1. Row Counts

SELECT
'DimCustomer' AS TableName,
10001 AS ExpectedRows,
COUNT(*) AS ActualRows
FROM dwh.DimCustomer

UNION ALL

SELECT
'DimProduct',
501,
COUNT(*)
FROM dwh.DimProduct

UNION ALL

SELECT
'DimDate',
5844,
COUNT(*)
FROM dwh.DimDate

UNION ALL

SELECT
'DimOrder',
100000,
COUNT(*)
FROM dwh.DimOrder

UNION ALL

SELECT
'FactSales',
299131,
COUNT(*)
FROM dwh.FactSales

UNION ALL

SELECT
'FactPayment',
100000,
COUNT(*)
FROM dwh.FactPayment

UNION ALL

SELECT
'FactShipment',
94974,
COUNT(*)
FROM dwh.FactShipment;

-- 2. Row Count Validation

SELECT
'DimCustomer' AS TableName,
10001 AS ExpectedRows,
COUNT(*) AS ActualRows,
IIF(COUNT(*) = 10001, 'PASS', 'FAIL') AS Result
FROM dwh.DimCustomer

UNION ALL

SELECT
'DimProduct',
501,
COUNT(*),
IIF(COUNT(*) = 501, 'PASS', 'FAIL')
FROM dwh.DimProduct

UNION ALL

SELECT
'DimOrder',
100000,
COUNT(*),
IIF(COUNT(*) = 100000, 'PASS', 'FAIL')
FROM dwh.DimOrder

UNION ALL

SELECT
'FactSales',
299131,
COUNT(*),
IIF(COUNT(*) = 299131, 'PASS', 'FAIL')
FROM dwh.FactSales

UNION ALL

SELECT
'FactPayment',
100000,
COUNT(*),
IIF(COUNT(*) = 100000, 'PASS', 'FAIL')
FROM dwh.FactPayment

UNION ALL

SELECT
'FactShipment',
94974,
COUNT(*),
IIF(COUNT(*) = 94974, 'PASS', 'FAIL')
FROM dwh.FactShipment;

-- 3. UNKNOWN Members

SELECT
'DimCustomer UNKNOWN' AS Validation,
COUNT(*) AS ActualRows,
1 AS ExpectedRows,
IIF(COUNT(*) = 1, 'PASS', 'FAIL') AS Result
FROM dwh.DimCustomer
WHERE CustomerKey = -1

UNION ALL

SELECT
'DimProduct UNKNOWN',
COUNT(*),
1,
IIF(COUNT(*) = 1, 'PASS', 'FAIL')
FROM dwh.DimProduct
WHERE ProductKey = -1;

-- 4. Dimension Business Key Duplicates

SELECT
'DimCustomer.CustomerID' AS Validation,
COUNT(*) AS DuplicateGroups
FROM
(
SELECT CustomerID
FROM dwh.DimCustomer
WHERE CustomerKey <> -1
GROUP BY CustomerID
HAVING COUNT(*) > 1
) AS d

UNION ALL

SELECT
'DimProduct.ProductID',
COUNT(*)
FROM
(
SELECT ProductID
FROM dwh.DimProduct
WHERE ProductKey <> -1
GROUP BY ProductID
HAVING COUNT(*) > 1
) AS d

UNION ALL

SELECT
'DimOrder.OrderID',
COUNT(*)
FROM
(
SELECT OrderID
FROM dwh.DimOrder
GROUP BY OrderID
HAVING COUNT(*) > 1
) AS d;

-- 5. Fact Grain Duplicates

SELECT
'FactSales.OrderItemID' AS Validation,
COUNT(*) AS DuplicateGroups
FROM
(
SELECT OrderItemID
FROM dwh.FactSales
GROUP BY OrderItemID
HAVING COUNT(*) > 1
) AS d

UNION ALL

SELECT
'FactPayment.PaymentID',
COUNT(*)
FROM
(
SELECT PaymentID
FROM dwh.FactPayment
GROUP BY PaymentID
HAVING COUNT(*) > 1
) AS d

UNION ALL

SELECT
'FactShipment.ShipmentID',
COUNT(*)
FROM
(
SELECT ShipmentID
FROM dwh.FactShipment
GROUP BY ShipmentID
HAVING COUNT(*) > 1
) AS d;

-- 6. Fact to Dimension Referential Integrity

SELECT
'FactSales -> DimCustomer' AS Validation,
COUNT(*) AS InvalidRows
FROM dwh.FactSales f
LEFT JOIN dwh.DimCustomer d
ON f.CustomerKey = d.CustomerKey
WHERE d.CustomerKey IS NULL

UNION ALL

SELECT
'FactSales -> DimProduct',
COUNT(*)
FROM dwh.FactSales f
LEFT JOIN dwh.DimProduct d
ON f.ProductKey = d.ProductKey
WHERE d.ProductKey IS NULL

UNION ALL

SELECT
'FactSales -> DimOrder',
COUNT(*)
FROM dwh.FactSales f
LEFT JOIN dwh.DimOrder d
ON f.OrderKey = d.OrderKey
WHERE d.OrderKey IS NULL

UNION ALL

SELECT
'FactPayment -> DimCustomer',
COUNT(*)
FROM dwh.FactPayment f
LEFT JOIN dwh.DimCustomer d
ON f.CustomerKey = d.CustomerKey
WHERE d.CustomerKey IS NULL

UNION ALL

SELECT
'FactPayment -> DimOrder',
COUNT(*)
FROM dwh.FactPayment f
LEFT JOIN dwh.DimOrder d
ON f.OrderKey = d.OrderKey
WHERE d.OrderKey IS NULL

UNION ALL

SELECT
'FactShipment -> DimCustomer',
COUNT(*)
FROM dwh.FactShipment f
LEFT JOIN dwh.DimCustomer d
ON f.CustomerKey = d.CustomerKey
WHERE d.CustomerKey IS NULL

UNION ALL

SELECT
'FactShipment -> DimOrder',
COUNT(*)
FROM dwh.FactShipment f
LEFT JOIN dwh.DimOrder d
ON f.OrderKey = d.OrderKey
WHERE d.OrderKey IS NULL;

-- 7. Fact to Date Dimension

SELECT
'FactSales -> DimDate' AS Validation,
COUNT(*) AS InvalidRows
FROM dwh.FactSales f
LEFT JOIN dwh.DimDate d
ON f.OrderDateKey = d.DateKey
WHERE d.DateKey IS NULL

UNION ALL

SELECT
'FactPayment -> DimDate',
COUNT(*)
FROM dwh.FactPayment f
LEFT JOIN dwh.DimDate d
ON f.PaymentDateKey = d.DateKey
WHERE d.DateKey IS NULL

UNION ALL

SELECT
'FactShipment ShipmentDate -> DimDate',
COUNT(*)
FROM dwh.FactShipment f
LEFT JOIN dwh.DimDate d
ON f.ShipmentDateKey = d.DateKey
WHERE d.DateKey IS NULL

UNION ALL

SELECT
'FactShipment DeliveryDate -> DimDate',
COUNT(*)
FROM dwh.FactShipment f
LEFT JOIN dwh.DimDate d
ON f.DeliveryDateKey = d.DateKey
WHERE d.DateKey IS NULL;

-- 8. Fact Measure Checks

SELECT
'FactSales Quantity < 0' AS Validation,
COUNT(*) AS InvalidRows
FROM dwh.FactSales
WHERE Quantity < 0

UNION ALL

SELECT
'FactSales UnitPrice < 0',
COUNT(*)
FROM dwh.FactSales
WHERE UnitPrice < 0

UNION ALL

SELECT
'FactSales SalesAmount < 0',
COUNT(*)
FROM dwh.FactSales
WHERE SalesAmount < 0

UNION ALL

SELECT
'FactPayment PaymentAmount < 0',
COUNT(*)
FROM dwh.FactPayment
WHERE PaymentAmount < 0

UNION ALL

SELECT
'FactShipment DeliveryDurationDays < 0',
COUNT(*)
FROM dwh.FactShipment
WHERE DeliveryDurationDays < 0;

-- 9. Intentional DQ Handling

SELECT
'FactSales Unknown ProductKey' AS Validation,
COUNT(*) AS ActualRows,
200 AS ExpectedRows,
IIF(COUNT(*) = 200, 'PASS', 'CHECK') AS Result
FROM dwh.FactSales
WHERE ProductKey = -1

UNION ALL

SELECT
'FactSales Quantity = 0',
COUNT(*),
100,
IIF(COUNT(*) = 100, 'PASS', 'CHECK')
FROM dwh.FactSales
WHERE Quantity = 0

UNION ALL

SELECT
'FactSales UnitPrice = 0',
COUNT(*),
100,
IIF(COUNT(*) = 100, 'PASS', 'CHECK')
FROM dwh.FactSales
WHERE UnitPrice = 0;

-- 10. UNKNOWN Customer in Orders

SELECT
'DimOrder UNKNOWN Customer' AS Validation,
COUNT(*) AS ActualRows,
100 AS ExpectedRows,
IIF(COUNT(*) = 100, 'PASS', 'CHECK') AS Result
FROM dwh.DimOrder
WHERE CustomerKey = -1;

-- 11. Shipment Date Logic

SELECT
'Delivery before Shipment' AS Validation,
COUNT(*) AS InvalidRows
FROM dwh.FactShipment
WHERE DeliveryDateKey < ShipmentDateKey;

-- 12. NULL Dimension Keys in Facts

SELECT
'FactSales NULL CustomerKey' AS Validation,
COUNT(*) AS InvalidRows
FROM dwh.FactSales
WHERE CustomerKey IS NULL

UNION ALL

SELECT
'FactSales NULL ProductKey',
COUNT(*)
FROM dwh.FactSales
WHERE ProductKey IS NULL

UNION ALL

SELECT
'FactSales NULL OrderKey',
COUNT(*)
FROM dwh.FactSales
WHERE OrderKey IS NULL

UNION ALL

SELECT
'FactPayment NULL CustomerKey',
COUNT(*)
FROM dwh.FactPayment
WHERE CustomerKey IS NULL

UNION ALL

SELECT
'FactPayment NULL OrderKey',
COUNT(*)
FROM dwh.FactPayment
WHERE OrderKey IS NULL

UNION ALL

SELECT
'FactShipment NULL CustomerKey',
COUNT(*)
FROM dwh.FactShipment
WHERE CustomerKey IS NULL

UNION ALL

SELECT
'FactShipment NULL OrderKey',
COUNT(*)
FROM dwh.FactShipment
WHERE OrderKey IS NULL;

-- 13. Validation Completed

SELECT
'DWH Technical Validation completed' AS Status,
GETDATE() AS ValidationTimestamp;
