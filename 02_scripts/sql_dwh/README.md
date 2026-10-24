# SQL Scripts

## Overview

This folder contains the SQL scripts used to build, populate, and validate the E-Commerce Data Warehouse in Microsoft SQL Server.

The scripts support the transformation of cleaned e-commerce data into a dimensional data model designed for analytical reporting in Power BI.

## Main Components

The SQL scripts cover the following areas:

- **Staging:** Preparation of source data for loading into the data warehouse.
- **Dimension Tables:** Creation and population of customer, product, date, and order dimensions.
- **Fact Tables:** Loading of sales, payment, and shipment data at their defined levels of detail.
- **Data Quality and Validation:** Checks to verify record counts, data consistency, and the presence of required records.

## Data Warehouse Schema

The warehouse uses the `dwh` schema and contains the following tables.

**Dimension tables**
- `dwh.DimCustomer`
- `dwh.DimProduct`
- `dwh.DimDate`
- `dwh.DimOrder`

**Fact tables**
- `dwh.FactSales`
- `dwh.FactPayment`
- `dwh.FactShipment`

## Execution Notes

1. Review the scripts and confirm that the database and required schemas exist.
2. Prepare and load the staging data.
3. Create and populate the dimension tables.
4. Load the fact tables.
5. Execute the validation scripts to check the resulting data.

The exact execution order depends on the dependencies between individual scripts. Review the SQL files before running them in a new environment.

## Important Notes

- The project uses synthetic e-commerce data for demonstration and portfolio purposes.
- Table and column names must match the actual database schema.
- Some validation checks may need to be adapted if the source data or warehouse structure changes.

## Related Documentation

For the business requirements, dimensional model, data dictionary, and data quality approach, see the project's `01_documentation` folder.
