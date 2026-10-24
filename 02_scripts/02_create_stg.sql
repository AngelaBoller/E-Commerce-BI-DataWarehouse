-- =========================================================
-- E-Commerce Data Warehouse
-- Script: 02_create_staging_tables.sql
-- Purpose: Create staging tables for raw source data
-- =========================================================

USE ECommerceDW;
GO

-- Create staging schema
IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'stg'
)
BEGIN
    EXEC('CREATE SCHEMA stg');
END;
GO

-- Customers
CREATE TABLE stg.Customers
(
    CustomerID VARCHAR(20),
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    ...
);