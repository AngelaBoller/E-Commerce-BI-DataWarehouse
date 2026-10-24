SELECT
    COUNT(*) AS InvalidRows
FROM dwh.FactPayment fp
LEFT JOIN dwh.DimOrder o
    ON fp.OrderKey = o.OrderKey
LEFT JOIN dwh.DimCustomer c
    ON fp.CustomerKey = c.CustomerKey
WHERE o.OrderKey IS NULL
   OR c.CustomerKey IS NULL;