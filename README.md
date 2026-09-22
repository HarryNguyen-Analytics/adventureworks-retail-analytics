# AdventureWorks Retail Analytics

Retail sales, product and customer analysis using SQL and Power BI.

## Project overview

This project brings the AdventureWorks retail data into one business story: how sales change over time, which products drive the mix, and how customers contribute to orders and revenue. SQL covers validation and analysis; Power BI is planned for the semantic model and dashboard. The repository currently contains an analysis scaffold. Results and dashboard screenshots will be added only after the dataset, schema and measures are validated.

## Business questions

- How are revenue, orders and average order value changing over time?
- Which categories and products contribute most to revenue and order volume?
- How concentrated is revenue across products and customers?
- What share of active customers place more than one order within the selected period?

## Analysis scope and metric definitions

- **Revenue:** sum of the confirmed sales amount at the validated order-line grain, net of returns or discounts only where supported by source fields.
- **Orders:** distinct order IDs in the selected period.
- **Average Order Value:** revenue divided by distinct orders.
- **Active Customers:** distinct customers with at least one order in the selected period.
- **Repeat Customer Rate:** active customers with more than one distinct order in the selected period divided by active customers in that period. This is a period-based purchase frequency measure, not a retention rate.
- **Year-over-year (YoY):** compare equivalent date windows. The 2022 dataset covers **January–June only**, so any comparison to 2022 must use January–June in the comparison year; a full-year 2023 versus 2022 comparison would be misleading.

The exact source tables, date range, currency, return handling and sales grain must be confirmed before publishing results. See [data dictionary](data/data_dictionary.md).

## Workflow

1. Validate keys, dates, missing values and order-line grain in [SQL validation](sql/01_data_validation.sql).
2. Profile coverage and dimensions in [SQL exploration](sql/02_data_exploration.sql).
3. Analyse [sales](sql/03_sales_performance.sql), [products](sql/04_product_analysis.sql) and [customers](sql/05_customer_analysis.sql).
4. Build the Power BI [data model](powerbi/data_model.md) and [DAX measures](powerbi/dax_measures.md) against the confirmed schema.
5. Publish only validated [findings](results/key_findings.md) and dashboard images.

## Repository structure

```text
adventureworks-retail-analytics/
├── README.md
├── .gitignore
├── data/
│   └── data_dictionary.md
├── sql/
│   ├── 01_data_validation.sql
│   ├── 02_data_exploration.sql
│   ├── 03_sales_performance.sql
│   ├── 04_product_analysis.sql
│   └── 05_customer_analysis.sql
├── powerbi/
│   ├── data_model.md
│   └── dax_measures.md
├── results/
│   └── key_findings.md
└── images/
    └── README.md
```

## Current status

The repository is ready for the confirmed AdventureWorks extract and Power BI build. It does not yet claim measured findings or include a PBIX file. SQL examples are intentionally templates until table and column names are verified.
