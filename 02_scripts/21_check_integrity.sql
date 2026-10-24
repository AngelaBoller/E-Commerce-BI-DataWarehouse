SELECT
    COUNT(*) AS InvalidRows
FROM dwh.FactSales fs
LEFT JOIN dwh.DimOrder o
    ON fs.OrderKey = o.OrderKey
LEFT JOIN dwh.DimCustomer c
    ON fs.CustomerKey = c.CustomerKey
LEFT JOIN dwh.DimProduct p
    ON fs.ProductKey = p.ProductKey
WHERE o.OrderKey IS NULL
   OR c.CustomerKey IS NULL
   OR p.ProductKey IS NULL;