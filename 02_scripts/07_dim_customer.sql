
-- =========================================================
-- E-Commerce Data Warehouse
-- Script: 07_dim_customer.sql
-- Purpose: Create the customer dimension
-- =========================================================

USE ECommerceDW;
GO

-- ---------------------------------------------------------
-- Create schema if it does not exist
-- ---------------------------------------------------------

IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'dwh'
)
BEGIN
    EXEC('CREATE SCHEMA dwh');
END;
GO

-- ---------------------------------------------------------
-- Create customer dimension if it does not exist
-- ---------------------------------------------------------

IF OBJECT_ID('dwh.DimCustomer', 'U') IS NULL
BEGIN
    CREATE TABLE dwh.DimCustomer
    (
        CustomerKey       INT          NOT NULL,
        CustomerID        VARCHAR(20)  NOT NULL,
        Name              VARCHAR(200) NULL,
        Country           VARCHAR(100) NULL,
        Segment            VARCHAR(50)  NULL,
        RegistrationDate  DATE         NULL,

        CONSTRAINT PK_DimCustomer
            PRIMARY KEY (CustomerKey),

        CONSTRAINT UQ_DimCustomer_CustomerID
            UNIQUE (CustomerID)
    );
END;
GO
