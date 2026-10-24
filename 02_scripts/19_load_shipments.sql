
USE ECommerceDW;

INSERT INTO dwh.FactShipment
(
    ShipmentID,
    OrderKey,
    CustomerKey,
    ShipmentDateKey,
    DeliveryDateKey,
    ShippingCountry,
    ShippingStatus,
    DeliveryDurationDays
)
SELECT
    s.ShipmentID,
    o.OrderKey,
    o.CustomerKey,
    sd.DateKey,
    dd.DateKey,
    s.ShippingCountry,
    s.ShippingStatus,
    CASE
        WHEN s.ShipmentDate IS NOT NULL
         AND s.DeliveryDate IS NOT NULL
        THEN DATEDIFF(DAY, s.ShipmentDate, s.DeliveryDate)
        ELSE NULL
    END AS DeliveryDurationDays
FROM stg.Shipments s
LEFT JOIN dwh.DimOrder o
    ON s.OrderID = o.OrderID
LEFT JOIN dwh.DimDate sd
    ON s.ShipmentDate = sd.[Date]
LEFT JOIN dwh.DimDate dd
    ON s.DeliveryDate = dd.[Date]
WHERE s.ShipmentID IS NOT NULL;

