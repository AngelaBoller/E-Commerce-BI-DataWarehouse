
-- =========================================================
-- E-Commerce Data Warehouse
-- Script: 08_insert_unknown.sql
-- Purpose: Insert unknown dimension members safely
-- =========================================================

USE ECommerceDW;
GO

-- ---------------------------------------------------------
-- UNKNOWN CUSTOMER
-- ---------------------------------------------------------

IF NOT EXISTS (
    SELECT 1
    FROM dwh.DimCustomer
    WHERE CustomerKey = -1
)
BEGIN
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
END;
GO
