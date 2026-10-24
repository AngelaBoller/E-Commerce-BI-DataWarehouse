
-- =========================================================
-- E-Commerce Data Warehouse
-- Script: 04_Load_Dirty_Data_to_Staging.sql
-- Purpose:
-- Document and validate the loading of dirty source data
-- into the staging layer.
--
-- IMPORTANT:
-- The staging tables are already populated.
-- This script does NOT reload data, avoiding duplicates.
-- =========================================================

USE ECommerceDW;
GO

-- ---------------------------------------------------------
-- 1. Verify staging tables
-- ---------------------------------------------------------

IF OBJECT_ID('stg.Customers', 'U') IS NULL
    THROW 50001, 'Missing staging table: stg.Customers', 1;

IF OBJECT_ID('stg.Products', 'U') IS NULL
    THROW 50002, 'Missing staging table: stg.Products', 1;

IF OBJECT_ID('stg.Orders', 'U') IS NULL
    THROW 50003, 'Missing staging table: stg.Orders', 1;

IF OBJECT_ID('stg.OrderItems', 'U') IS NULL
    THROW 50004, 'Missing staging table: stg.OrderItems', 1;

IF OBJECT_ID('stg.Payments', 'U') IS NULL
    THROW 50005, 'Missing staging table: stg.Payments', 1;

IF OBJECT_ID('stg.Shippments', 'U') IS NULL
    THROW 50006, 'Missing staging table: stg.Shippments', 1;
GO

-- ---------------------------------------------------------
-- 2. Report current staging row counts
-- ---------------------------------------------------------

SELECT 'Customers' AS TableName, COUNT_BIG(*) AS RowCount
FROM stg.Customers

UNION ALL

SELECT 'Products', COUNT_BIG(*)
FROM stg.Products

UNION ALL

SELECT 'Orders', COUNT_BIG(*)
FROM stg.Orders

UNION ALL

SELECT 'OrderItems', COUNT_BIG(*)
FROM stg.OrderItems

UNION ALL

SELECT 'Payments', COUNT_BIG(*)
FROM stg.Payments

UNION ALL

SELECT 'Shippments', COUNT_BIG(*)
FROM stg.Shippments;
GO
