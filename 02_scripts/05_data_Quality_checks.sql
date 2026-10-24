-- ============================================================
-- E-COMMERCE DATA WAREHOUSE & ANALYTICS PROJECT
-- ============================================================
-- Script: 04_Data_Quality_Checks.sql
--
-- Purpose:
-- Identify and quantify deliberately introduced data-quality
-- issues in the staging layer before transformation into the
-- analytical data warehouse.
--
-- Data Source:
-- Dirty e-commerce source data loaded into the stg schema.
--
-- Expected total number of data-quality violations: 751
--
-- The checks cover:
--   - Completeness
--   - Uniqueness
--   - Domain validity
--   - Referential integrity
--   - Business-rule validation
--   - Data consistency
--
-- ============================================================


USE ECommerceDW;
GO


-- ============================================================
-- DATA QUALITY TEST CASES
-- ============================================================
--
-- ID     Table         Validation Rule
-- ------------------------------------------------------------
--
-- DQ001  Customers     Country must not be NULL
--                      Expected: 100 violations
--
-- DQ002  Customers     CustomerID must be unique
--                      Expected: 1 duplicate
--
-- DQ003  Customers     Segment must be Standard, Premium
--                      or VIP
--                      Expected: 50 violations
--
-- DQ004  Orders        CustomerID must exist in Customers
--                      Expected: 100 violations
--
-- DQ005  OrderItems    ProductID must exist in Products
--                      Expected: 200 violations
--
-- DQ006  OrderItems    Quantity must be greater than 0
--                      Expected: 100 violations
--
-- DQ007  OrderItems    UnitPrice must be greater than 0
--                      Expected: 100 violations
--
-- DQ008  Payments      Payment Amount must correspond to
--                      the related Order Amount
--                      Expected: 100 violations
--
-- ============================================================


-- ============================================================
-- EXPECTED RESULTS SUMMARY
-- ============================================================
--
-- Customers:
--   DQ001  Country IS NULL                  100
--   DQ002  Duplicate CustomerID               1
--   DQ003  Invalid Segment                   50
--                                      ----------
--                                      Total 151
--
-- Orders:
--   DQ004  Invalid CustomerID               100
--                                      ----------
--                                      Total 100
--
-- OrderItems:
--   DQ005  Invalid ProductID                200
--   DQ006  Quantity <= 0                    100
--   DQ007  UnitPrice <= 0                   100
--                                      ----------
--                                      Total 400
--
-- Payments:
--   DQ008  Payment Amount mismatch           100
--                                      ----------
--                                      Total 100
--
-- ------------------------------------------------------------
-- TOTAL EXPECTED VIOLATIONS:                751
-- ============================================================


-- ============================================================
-- DQ001 - CUSTOMER COUNTRY MUST NOT BE NULL
-- ============================================================
-- Rule:
-- Every customer record must contain a country.
--
-- Expected violations: 100
-- ============================================================


SELECT COUNT(*) AS ErrorCount
FROM stg.Customers
WHERE Country IS NULL;


-- ============================================================
-- DQ002 - CUSTOMER ID MUST BE UNIQUE
-- ============================================================
-- Rule:
-- Each CustomerID must occur only once.
--
-- Expected:
-- 1 duplicate CustomerID
--
-- Note:
-- The query returns the duplicated ID and its occurrence count.
-- ============================================================


SELECT
    CustomerID,
    COUNT(*) AS CountRows
FROM stg.Customers
GROUP BY CustomerID
HAVING COUNT(*) > 1;


-- ============================================================
-- DQ003 - CUSTOMER SEGMENT MUST BE VALID
-- ============================================================
-- Rule:
-- Segment must be one of:
--   Standard
--   Premium
--   VIP
--
-- Expected violations: 50
-- ============================================================


SELECT COUNT(*) AS ErrorCount
FROM stg.Customers
WHERE Segment NOT IN ('Standard', 'Premium', 'VIP')
   OR Segment IS NULL;


-- ============================================================
-- DQ004 - ORDER CUSTOMER ID MUST EXIST
-- ============================================================
-- Rule:
-- Every Order must reference an existing CustomerID.
--
-- Expected violations: 100
-- ============================================================


SELECT COUNT(*) AS ErrorCount
FROM stg.Orders o
LEFT JOIN stg.Customers c
    ON o.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL;


-- ============================================================
-- DQ005 - ORDER ITEM PRODUCT ID MUST EXIST
-- ============================================================
-- Rule:
-- Every OrderItem must reference an existing ProductID.
--
-- Expected violations: 200
-- ============================================================


SELECT COUNT(*) AS ErrorCount
FROM stg.OrderItems oi
LEFT JOIN stg.Products p
    ON oi.ProductID = p.ProductID
WHERE p.ProductID IS NULL;


-- ============================================================
-- DQ006 - ORDER ITEM QUANTITY MUST BE GREATER THAN ZERO
-- ============================================================
-- Rule:
-- Quantity must be greater than 0.
--
-- Expected violations: 100
-- ============================================================


SELECT COUNT(*) AS ErrorCount
FROM stg.OrderItems
WHERE Quantity <= 0
   OR Quantity IS NULL;


-- ============================================================
-- DQ007 - ORDER ITEM UNIT PRICE MUST BE GREATER THAN ZERO
-- ============================================================
-- Rule:
-- UnitPrice must be greater than 0.
--
-- Expected violations: 100
-- ============================================================


SELECT COUNT(*) AS ErrorCount
FROM stg.OrderItems
WHERE UnitPrice <= 0
   OR UnitPrice IS NULL;


-- ============================================================
-- DQ008 - PAYMENT AMOUNT MUST MATCH ORDER AMOUNT
-- ============================================================
-- Rule:
-- Payment Amount must correspond to the total amount
-- of the related order.
--
-- Expected violations: 100
-- ============================================================


-- NOTE:
-- The exact calculation of the expected Order Amount depends
-- on the business definition used in the source data.
-- The validation below compares the payment amount against
-- the aggregated OrderItems amount.


SELECT COUNT(*) AS ErrorCount
FROM stg.Payments p
JOIN
(
    SELECT
        OrderID,
        SUM(SalesAmount) AS OrderAmount
    FROM stg.OrderItems
    GROUP BY OrderID
) oi
    ON p.OrderID = oi.OrderID
WHERE ABS(p.PaymentAmount - oi.OrderAmount) > 0.01;

DROP TABLE IF EXISTS #DQResults;

-- ============================================================
-- DATA QUALITY CHECK SUMMARY
-- ============================================================
-- Purpose:
-- Consolidate all eight data quality checks into one result set.
--
-- DQ002:
-- A duplicate CustomerID is counted as ONE violation,
-- even if the duplicated CustomerID occurs in TWO rows.
--
-- Expected total violations: 751
-- ============================================================


-- ------------------------------------------------------------
-- Create temporary result table
-- ------------------------------------------------------------

CREATE TABLE #DQResults
(
    DQ_ID VARCHAR(10),
    Description VARCHAR(200),
    ExpectedCount INT,
    ActualCount INT,
    Status VARCHAR(10)
);


-- ============================================================
-- DQ001 - Country must not be NULL
-- Expected: 100
-- ============================================================

INSERT INTO #DQResults
(
    DQ_ID,
    Description,
    ExpectedCount,
    ActualCount,
    Status
)
SELECT
    'DQ001',
    'Country must not be NULL',
    100,
    COUNT(*),
    CASE
        WHEN COUNT(*) = 100 THEN 'PASS'
        ELSE 'FAIL'
    END
FROM stg.Customers
WHERE Country IS NULL;


-- ============================================================
-- DQ002 - CustomerID must be unique
-- Expected: 1 duplicate violation
--
-- Important:
-- C000001 appearing twice = 1 duplicate violation
-- affecting 2 physical rows.
-- ============================================================

INSERT INTO #DQResults
(
    DQ_ID,
    Description,
    ExpectedCount,
    ActualCount,
    Status
)
SELECT
    'DQ002',
    'CustomerID must be unique',
    1,
    COUNT(*),
    CASE
        WHEN COUNT(*) = 1 THEN 'PASS'
        ELSE 'FAIL'
    END
FROM
(
    SELECT CustomerID
    FROM stg.Customers
    GROUP BY CustomerID
    HAVING COUNT(*) > 1
) AS DuplicateCustomers;


-- ============================================================
-- DQ003 - Segment must be Standard, Premium or VIP
-- Expected: 50
-- ============================================================

INSERT INTO #DQResults
(
    DQ_ID,
    Description,
    ExpectedCount,
    ActualCount,
    Status
)
SELECT
    'DQ003',
    'Segment must be Standard, Premium or VIP',
    50,
    COUNT(*),
    CASE
        WHEN COUNT(*) = 50 THEN 'PASS'
        ELSE 'FAIL'
    END
FROM stg.Customers
WHERE Segment NOT IN ('Standard', 'Premium', 'VIP')
   OR Segment IS NULL;


-- ============================================================
-- DQ004 - Order CustomerID must exist in Customers
-- Expected: 100
-- ============================================================

INSERT INTO #DQResults
(
    DQ_ID,
    Description,
    ExpectedCount,
    ActualCount,
    Status
)
SELECT
    'DQ004',
    'Order CustomerID must exist in Customers',
    100,
    COUNT(*),
    CASE
        WHEN COUNT(*) = 100 THEN 'PASS'
        ELSE 'FAIL'
    END
FROM stg.Orders o
LEFT JOIN stg.Customers c
    ON o.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL;


-- ============================================================
-- DQ005 - OrderItem ProductID must exist in Products
-- Expected: 200
-- ============================================================

INSERT INTO #DQResults
(
    DQ_ID,
    Description,
    ExpectedCount,
    ActualCount,
    Status
)
SELECT
    'DQ005',
    'OrderItem ProductID must exist in Products',
    200,
    COUNT(*),
    CASE
        WHEN COUNT(*) = 200 THEN 'PASS'
        ELSE 'FAIL'
    END
FROM stg.OrderItems oi
LEFT JOIN stg.Products p
    ON oi.ProductID = p.ProductID
WHERE p.ProductID IS NULL;


-- ============================================================
-- DQ006 - Quantity must be greater than 0
-- Expected: 100
-- ============================================================

INSERT INTO #DQResults
(
    DQ_ID,
    Description,
    ExpectedCount,
    ActualCount,
    Status
)
SELECT
    'DQ006',
    'Quantity must be greater than 0',
    100,
    COUNT(*),
    CASE
        WHEN COUNT(*) = 100 THEN 'PASS'
        ELSE 'FAIL'
    END
FROM stg.OrderItems
WHERE Quantity <= 0
   OR Quantity IS NULL;


-- ============================================================
-- DQ007 - UnitPrice must be greater than 0
-- Expected: 100
-- ============================================================

INSERT INTO #DQResults
(
    DQ_ID,
    Description,
    ExpectedCount,
    ActualCount,
    Status
)
SELECT
    'DQ007',
    'UnitPrice must be greater than 0',
    100,
    COUNT(*),
    CASE
        WHEN COUNT(*) = 100 THEN 'PASS'
        ELSE 'FAIL'
    END
FROM stg.OrderItems
WHERE UnitPrice <= 0
   OR UnitPrice IS NULL;


-- ============================================================
-- DQ008 - PaymentAmount must match Order Amount
-- Expected: 100
--
-- Order Amount is calculated from OrderItems.SalesAmount.
-- A tolerance of 0.01 is used for decimal rounding differences.
-- ============================================================

INSERT INTO #DQResults
(
    DQ_ID,
    Description,
    ExpectedCount,
    ActualCount,
    Status
)
SELECT
    'DQ008',
    'PaymentAmount must match Order Amount',
    100,
    COUNT(*),
    CASE
        WHEN COUNT(*) = 100 THEN 'PASS'
        ELSE 'FAIL'
    END
FROM stg.Payments p
JOIN
(
    SELECT
        OrderID,
        SUM(SalesAmount) AS OrderAmount
    FROM stg.OrderItems
    GROUP BY OrderID
) oi
    ON p.OrderID = oi.OrderID
WHERE ABS(p.PaymentAmount - oi.OrderAmount) > 0.01;


-- ============================================================
-- DISPLAY RESULTS OF ALL DQ CHECKS
-- ============================================================

SELECT
    DQ_ID,
    Description,
    ExpectedCount,
    ActualCount,
    Status
FROM #DQResults
ORDER BY DQ_ID;


-- ============================================================
-- TOTAL RESULT
-- ============================================================

SELECT
    'TOTAL' AS DQ_ID,
    'Total Data Quality Violations' AS Description,
    SUM(ExpectedCount) AS ExpectedCount,
    SUM(ActualCount) AS ActualCount,
    CASE
        WHEN SUM(ExpectedCount) = SUM(ActualCount)
        THEN 'PASS'
        ELSE 'FAIL'
    END AS Status
FROM #DQResults;


-- ============================================================
-- DQ002 DETAIL
-- Shows the duplicated CustomerID and affected rows.
-- ============================================================

SELECT
    CustomerID,
    COUNT(*) AS Anzahl
FROM stg.Customers
GROUP BY CustomerID
HAVING COUNT(*) > 1;


-- ============================================================
-- END OF DATA QUALITY CHECK SUMMARY
-- ============================================================



-- Next step:
-- Cleanse and transform validated staging data into the
-- dimensional data warehouse layer (dwh).
--
-- ============================================================