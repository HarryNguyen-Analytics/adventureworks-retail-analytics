/*
============================================================
Project: AdventureWorks Retail Analytics
File: 01_data_validation.sql

Purpose:
Validate dataset scope, order-line grain, completeness,
key integrity and numerical validity before business analysis.

SQL dialect: GoogleSQL
Platform: Google BigQuery
============================================================
*/

-- =========================================================
-- TEST 1: DATASET OVERVIEW
-- Confirm dataset size, date coverage, orders and customers.
-- =========================================================
select
    min(s.OrderDate) as first_order_date,
    max(s.OrderDate) as last_order_date,
    count(*) as total_rows,
    count(distinct s.OrderNumber) as total_order,
    count(distinct s.CustomerKey) as total_customer
from `adventureworks.sales_data` s;
/*
Result:

- [add validated result]
- Date coverage: [2020-01-01] to [2022-06-30]
- [56046] total sales rows
- [25164] distinct orders
- [17416] active customers
*/

-- =========================================================
-- TEST 2: EXPECTED ROW GRAIN
-- Expected grain:
-- one record per order number and order line item.
-- =========================================================
select
    s.OrderNumber,
    s.OrderLineItem,
    count(*) as rows_per_order_line
from `adventureworks.sales_data` s
group by s.OrderNumber, s.OrderLineItem
having count(*) > 1;
/*
Result:
[There is no data to display.]
Confirmed grain:
One record per OrderNumber and OrderLineItem.
*/

-- 3. Completeness and value checks
select 
  sum(case when s.OrderDate is null then 1 else 0 end) as null_order_date,
  sum(case when s.OrderNumber is null then 1 else 0 end) as null_order_number,
  sum(case when s.ProductKey is null then 1 else 0 end) as null_product_key,
  sum(case when s.CustomerKey is null then 1 else 0 end) as null_customer_key,
  sum(case when s.TerritoryKey is null then 1 else 0 end) as null_territory_key,
  sum(case when s.OrderLineItem is null then 1 else 0 end) as null_order_line_item,
  sum(case when s.OrderQuantity is null then 1 else 0 end) as null_order_quantity,
  sum(case when s.OrderQuantity <= 0 then 1 else 0 end) as invalid_order_quantity
from `adventureworks.sales_data` s
/*
Result:
[All 0 results]
*/

-- =========================================================
-- TEST 4: INVALID NUMERICAL VALUES
-- =========================================================
select
    sum(case when s.OrderQuantity <= 0 then 1 else 0 end) as invalid_order_quantity
from `adventureworks.sales_data` s;
/*
Result: 0
*/

