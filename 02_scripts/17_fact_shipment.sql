
USE ECommerceDW;

-- =========================================================
-- 
-- Fact Shipment
-- Grain:
-- One row = one shipment record
-- =========================================================

CREATE TABLE dwh.FactShipment
(
    ShipmentID            VARCHAR(20) NOT NULL,
    OrderKey              INT         NOT NULL,
    CustomerKey           INT         NOT NULL,
    ShipmentDateKey       INT         NULL,
    DeliveryDateKey       INT         NULL,
    ShippingCountry       VARCHAR(100) NULL,
    ShippingStatus        VARCHAR(50)  NULL,
    DeliveryDurationDays  INT          NULL,

    CONSTRAINT PK_FactShipment
        PRIMARY KEY (ShipmentID)
);
