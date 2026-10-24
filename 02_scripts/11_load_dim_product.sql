
USE ECommerceDW;

-- =========================================================
-- LOAD PRODUCT DIMENSION
-- stg.Products -> dwh.DimProduct
-- =========================================================

INSERT INTO dwh.DimProduct
(
    ProductKey,
    ProductID,
    ProductName,
    Category,
    Subcategory,
    Brand,
    UnitCost,
    ListPrice
)
SELECT
    ROW_NUMBER() OVER (ORDER BY ProductID) AS ProductKey,
    ProductID,
    ProductName,
    Category,
    Subcategory,
    Brand,
    UnitCost,
    ListPrice
FROM stg.Products
WHERE ProductID IS NOT NULL
  AND ProductID <> 'UNKNOWN';

