-- =========================================================
-- E-Commerce Data Warehouse
-- Script: 03_load_staging.sql
-- Purpose:
-- Load deliberately corrupted source data into staging.
--
-- IMPORTANT:
-- The staging layer intentionally contains data quality
-- issues. No cleansing is performed at this stage.
-- =========================================================

USE ECommerceDW;
GO

-- ---------------------------------------------------------
-- Load Customers
-- ---------------------------------------------------------

BULK INSERT stg.Customers
FROM '...'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a'
);
GO