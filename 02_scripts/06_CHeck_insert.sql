USE ECommerceDW;
GO

SELECT 'Customers' AS TableName, COUNT(*) AS Rows
FROM stg.Customers

UNION ALL

SELECT 'Products', COUNT(*)
FROM stg.Products

UNION ALL

SELECT 'Orders', COUNT(*)
FROM stg.Orders

UNION ALL

SELECT 'OrderItems', COUNT(*)
FROM stg.OrderItems

UNION ALL

SELECT 'Payments', COUNT(*)
FROM stg.Payments

UNION ALL

SELECT 'Shipments', COUNT(*)
FROM stg.Shipments;