SELECT
    COUNT(*) AS InvalidRows
FROM dwh.FactShipment fs
LEFT JOIN dwh.DimOrder o
    ON fs.OrderKey = o.OrderKey
LEFT JOIN dwh.DimCustomer c
    ON fs.CustomerKey = c.CustomerKey
WHERE o.OrderKey IS NULL
   OR c.CustomerKey IS NULL;