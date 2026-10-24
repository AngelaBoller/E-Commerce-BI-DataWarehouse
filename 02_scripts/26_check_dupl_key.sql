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