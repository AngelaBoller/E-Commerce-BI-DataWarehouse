USE ECommerceDW;


-- =========================================================
-- UNKNOWN CUSTOMER
-- =========================================================

INSERT INTO dwh.DimCustomer
(
    CustomerKey,
    CustomerID,
    Name,
    Country,
    Segment,
    RegistrationDate
)
VALUES
(
    -1,
    'UNKNOWN',
    'Unknown Customer',
    'Unknown',
    'Unknown',
    NULL
);
