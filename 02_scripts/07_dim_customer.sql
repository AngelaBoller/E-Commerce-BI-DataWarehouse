```sql
USE ECommerceDW

-- =========================================================
-- DWH DIMENSION: CUSTOMER
-- =========================================================

CREATE TABLE dwh.DimCustomer
(
    CustomerKey       INT          NOT NULL,
    CustomerID        VARCHAR(20)  NOT NULL,
    Name              VARCHAR(200) NULL,
    Country           VARCHAR(100) NULL,
    Segment           VARCHAR(50)  NULL,
    RegistrationDate  DATE         NULL,

    CONSTRAINT PK_DimCustomer
        PRIMARY KEY (CustomerKey),

    CONSTRAINT UQ_DimCustomer_CustomerID
        UNIQUE (CustomerID)
)
```

