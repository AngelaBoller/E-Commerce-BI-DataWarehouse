
USE ECommerceDW;

-- =========================================================
-- 12_dimension_date.sql
-- Create and populate Date Dimension (max und Min order- , shipment and paymentdate checked (Start 01.01.2024 and 31.12.2035 End + 9 Years)


CREATE TABLE dwh.DimDate
(
    DateKey      INT          NOT NULL,
    [Date]       DATE         NOT NULL,
    [Year]       INT          NOT NULL,
    [Quarter]    INT          NOT NULL,
    [Month]      INT          NOT NULL,
    MonthName    VARCHAR(20)  NOT NULL,
    [Week]       INT          NOT NULL,
    [Day]        INT          NOT NULL,
    DayOfWeek    INT          NOT NULL,
    DayName      VARCHAR(20)  NOT NULL,
    IsWeekend    BIT          NOT NULL,

    CONSTRAINT PK_DimDate
        PRIMARY KEY (DateKey),

    CONSTRAINT UQ_DimDate_Date
        UNIQUE ([Date])
);

;WITH DateSeries AS
(
    SELECT CAST('2020-01-01' AS DATE) AS DateValue

    UNION ALL

    SELECT DATEADD(DAY, 1, DateValue)
    FROM DateSeries
    WHERE DateValue < '2035-12-31'
)
INSERT INTO dwh.DimDate
(
    DateKey,
    [Date],
    [Year],
    [Quarter],
    [Month],
    MonthName,
    [Week],
    [Day],
    DayOfWeek,
    DayName,
    IsWeekend
)
SELECT
    CONVERT(INT, CONVERT(CHAR(8), DateValue, 112)) AS DateKey,
    DateValue,
    YEAR(DateValue),
    DATEPART(QUARTER, DateValue),
    MONTH(DateValue),
    DATENAME(MONTH, DateValue),
    DATEPART(ISO_WEEK, DateValue),

    DAY(DateValue),

    ((DATEPART(WEEKDAY, DateValue) + @@DATEFIRST - 2) % 7) + 1
        AS DayOfWeek,

    DATENAME(WEEKDAY, DateValue)
        AS DayName,

    CASE
        WHEN ((DATEPART(WEEKDAY, DateValue) + @@DATEFIRST - 2) % 7) + 1
             IN (6, 7)
        THEN 1
        ELSE 0
    END AS IsWeekend

FROM DateSeries
OPTION (MAXRECURSION 0);
