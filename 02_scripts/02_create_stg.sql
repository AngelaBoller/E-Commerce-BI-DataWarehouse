
-- =========================================================
-- E-Commerce Data Warehouse
-- Script: 02_create_staging_tables.sql
-- Purpose: Create staging tables for raw source data
-- =========================================================

USE ECommerceDW;
GO

-- ---------------------------------------------------------
-- Create staging schema if it does not exist
-- ---------------------------------------------------------

IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'stg'
)
BEGIN
    EXEC('CREATE SCHEMA stg');
END;
GO

-- ---------------------------------------------------------
-- Create Customers staging table if it does not exist
-- ---------------------------------------------------------

IF OBJECT_ID('stg.Customers', 'U') IS NULL
BEGIN
    CREATE TABLE stg.Customers
    (
        CustomerID VARCHAR(20),
        FirstName  VARCHAR(100),
        LastName   VARCHAR(100)
    );
END;
GO
