SELECT
    'Unknown Customers' AS CheckName,
    COUNT(*) AS Rows
FROM dwh.DimCustomer
WHERE CustomerKey = -1

UNION ALL

SELECT
    'Unknown Products',
    COUNT(*)
FROM dwh.DimProduct
WHERE ProductKey = -1

UNION ALL

SELECT
    'Sales with Unknown Product',
    COUNT(*)
FROM dwh.FactSales
WHERE ProductKey = -1

UNION ALL

SELECT
    'Orders with Unknown Customer',
    COUNT(*)
FROM dwh.DimOrder
WHERE CustomerKey = -1

UNION ALL

SELECT
    'Payments with Unknown Customer',
    COUNT(*)
FROM dwh.FactPayment
WHERE CustomerKey = -1

UNION ALL

SELECT
    'Shipments with Unknown Customer',
    COUNT(*)
FROM dwh.FactShipment
WHERE CustomerKey = -1;