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