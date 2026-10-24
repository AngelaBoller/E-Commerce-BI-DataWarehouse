
USE ECommerceDW;

-- =========================================================
-- 09_dimension_product.sql
-- Create Product Dimension
-- =========================================================

CREATE TABLE dwh.DimProduct
(
    ProductKey    INT           NOT NULL,
    ProductID     VARCHAR(20)   NOT NULL,
    ProductName   VARCHAR(200)  NULL,
    Category      VARCHAR(100)  NULL,
    Subcategory   VARCHAR(100)  NULL,
    Brand         VARCHAR(100)  NULL,
    UnitCost      DECIMAL(18,2) NULL,
    ListPrice     DECIMAL(18,2) NULL,

    CONSTRAINT PK_DimProduct
        PRIMARY KEY (ProductKey),

    CONSTRAINT UQ_DimProduct_ProductID
        UNIQUE (ProductID)
);

