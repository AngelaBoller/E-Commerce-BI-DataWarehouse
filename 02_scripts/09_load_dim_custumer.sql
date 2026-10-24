
USE ECommerceDW;

;WITH CleanCustomers AS
(
    SELECT
        CustomerID,
        Name,
        CASE
            WHEN Country IS NULL OR LTRIM(RTRIM(Country)) = ''
                THEN 'Unknown'
            ELSE Country
        END AS Country,
        CASE
            WHEN Segment IN ('Standard', 'Premium', 'VIP')
                THEN Segment
            ELSE 'Unknown'
        END AS Segment,
        RegistrationDate,
        ROW_NUMBER() OVER
        (
            PARTITION BY CustomerID
            ORDER BY CustomerID
        ) AS rn
    FROM stg.Customers
    WHERE CustomerID IS NOT NULL
      AND CustomerID <> 'UNKNOWN'
)

INSERT INTO dwh.DimCustomer
(
    CustomerKey,
    CustomerID,
    Name,
    Country,
    Segment,
    RegistrationDate
)
SELECT
    ROW_NUMBER() OVER (ORDER BY CustomerID) AS CustomerKey,
    CustomerID,
    Name,
    Country,
    Segment,
    RegistrationDate
FROM CleanCustomers
WHERE rn = 1;

