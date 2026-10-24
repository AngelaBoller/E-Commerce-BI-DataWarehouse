# 04. ETL Architecture & Data Quality Framework

## 1. Overview

The project implements a data preparation and loading workflow for a synthetic e-commerce dataset. Python is used for data generation, cleaning, and data quality checks, while Microsoft SQL Server is used to stage and load data into the data warehouse.

The workflow prepares data for analytical reporting in Power BI.

The main processing stages are:

1. Synthetic source data generation.
2. Data cleaning and data quality checks in Python.
3. Staging and data loading in SQL Server.
4. Population of dimension and fact tables.
5. Technical validation of the data warehouse.
6. Analytical reporting in Power BI.

## 2. ETL Pipeline Architecture

The following diagram illustrates the overall workflow.

```text
[ Synthetic Source Data ]
           |
           v
[ Python: Data Generation ]
           |
           v
[ Python: Data Cleaning ]
           |
           v
[ Python: Data Quality Checks ]
           |
           v
[ Prepared Data Files ]
           |
           v
[ SQL Server: Staging Layer ]
           |
           v
[ Data Warehouse Loading ]
           |
           v
[ dwh Dimension and Fact Tables ]
           |
           v
[ SQL Technical Validation ]
           |
           v
[ Power BI Reporting ]
```

This diagram represents the project's overall processing flow. The exact implementation of individual loading and validation steps is defined by the corresponding Python notebooks and SQL scripts.

## 3. Python Data Preparation

Python is used to generate and prepare the synthetic e-commerce data.

The workflow includes:

- Generating datasets representing customers, products, orders, order items, payments, and shipments.
- Introducing selected data quality issues for testing purposes.
- Cleaning the generated data.
- Applying data quality rules to identify and correct defined issues.
- Exporting the processed datasets for subsequent SQL Server loading.

The data preparation process is designed to create a reproducible dataset suitable for testing analytical data processing.

## 4. SQL Server Staging and Loading

SQL Server is used to load the prepared datasets into the data warehouse environment.

The database is named `ECommerceDW`, and the dimensional model is implemented in the `dwh` schema.

The data warehouse contains the following dimension tables:

- `dwh.DimCustomer`
- `dwh.DimProduct`
- `dwh.DimDate`
- `dwh.DimOrder`

The following fact tables store the main business processes:

- `dwh.FactSales`
- `dwh.FactPayment`
- `dwh.FactShipment`

The loading workflow maps source identifiers to warehouse keys and prepares data for analytical queries.

The exact loading strategy, including whether individual scripts use full reloads, incremental loads, or upsert operations, depends on the implementation of the respective SQL scripts.

## 5. Data Quality Framework

Data quality checks are an important part of the project. The Python preparation workflow and SQL validation queries help identify issues that could affect analytical reporting.

The framework addresses the following areas:

| Data Quality Area | Objective |
|---|---|
| Completeness | Identify missing values in relevant fields. |
| Validity | Detect values outside expected ranges or permitted formats. |
| Consistency | Check whether related records contain compatible values. |
| Uniqueness | Identify duplicate identifiers where uniqueness is required. |
| Referential Integrity | Validate that fact-table records can be matched to the appropriate dimension or order records. |
| Reconciliation | Compare expected and actual record counts after loading. |

The specific checks applied depend on the data quality rules implemented in the Python notebooks and SQL scripts.

## 6. Data Quality Testing and Validation

The project includes technical validation of the populated data warehouse.

Examples of validation activities include:

- Comparing actual and expected row counts.
- Checking for missing business identifiers.
- Checking the presence of designated unknown members in dimensions.
- Validating relationships between fact and dimension records.
- Reviewing selected data quality issues and their treatment during data preparation.

Validation results should be documented alongside the corresponding SQL queries or notebook outputs.

A validation check should only be reported as passed when its query has been executed successfully and the observed result meets the expected condition.

## 7. Error Handling and Data Quality Issues

The synthetic source data includes deliberately introduced data quality issues for testing the preparation and cleaning workflow.

The project uses these issues to demonstrate how data quality problems can be identified and addressed before the data is used for reporting.

Automated error logging, quarantine tables, and detailed monitoring can be added as future enhancements if they are not already implemented in the current SQL workflow.

## 8. Design Principles

The ETL and data quality workflow follows these principles:

- **Reproducibility:** Synthetic data supports repeatable testing and demonstration.
- **Separation of Responsibilities:** Python handles data preparation, while SQL Server provides the warehouse and SQL-based loading and validation.
- **Traceability:** Processing steps and validation logic should be documented.
- **Data Integrity:** Checks help prevent inconsistent data from silently affecting reports.
- **Analytical Reliability:** Data is structured according to the grain of the individual fact tables.
- **Extensibility:** The workflow can be expanded to support additional sources and business requirements.

## 9. Future Enhancements

Potential improvements include:

- Integrating additional data sources.
- Automating the execution of the complete ETL workflow.
- Introducing centralized error logging and quarantine handling where appropriate.
- Expanding data quality monitoring and validation reporting.
- Implementing incremental loading where required.
- Improving documentation of data lineage and transformation rules.

These items are planned enhancements unless explicitly implemented in the current project.

