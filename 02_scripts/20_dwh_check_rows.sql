USE ECommerceDW;

SELECT 'DimCustomer' AS TableName, COUNT(*) AS Rows
FROM dwh.DimCustomer

UNION ALL

SELECT 'DimProduct', COUNT(*)
FROM dwh.DimProduct

UNION ALL

SELECT 'DimDate', COUNT(*)
FROM dwh.DimDate

UNION ALL

SELECT 'DimOrder', COUNT(*)
FROM dwh.DimOrder

UNION ALL

SELECT 'FactSales', COUNT(*)
FROM dwh.FactSales

UNION ALL

SELECT 'FactPayment', COUNT(*)
FROM dwh.FactPayment

UNION ALL

SELECT 'FactShipment', COUNT(*)
FROM dwh.FactShipment;