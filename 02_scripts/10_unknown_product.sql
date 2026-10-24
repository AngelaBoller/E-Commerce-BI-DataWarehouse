
USE ECommerceDW;

-- =========================================================
-- UNKNOWN PRODUCT
-- =========================================================

IF NOT EXISTS
(
    SELECT 1
    FROM dwh.DimProduct
    WHERE ProductKey = -1
)
BEGIN
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
    VALUES
    (
        -1,
        'UNKNOWN',
        'Unknown Product',
        'Unknown',
        'Unknown',
        'Unknown',
        NULL,
        NULL
    );
END;

