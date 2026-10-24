
USE ECommerceDW;

INSERT INTO dwh.FactPayment
(
    PaymentID,
    OrderKey,
    CustomerKey,
    PaymentDateKey,
    PaymentMethod,
    PaymentStatus,
    PaymentAmount
)
SELECT
    p.PaymentID,
    o.OrderKey,
    o.CustomerKey,
    d.DateKey,
    p.PaymentMethod,
    p.PaymentStatus,
    p.PaymentAmount
FROM stg.Payments p
LEFT JOIN dwh.DimOrder o
    ON p.OrderID = o.OrderID
LEFT JOIN dwh.DimDate d
    ON p.PaymentDate = d.[Date]
WHERE p.PaymentID IS NOT NULL;

