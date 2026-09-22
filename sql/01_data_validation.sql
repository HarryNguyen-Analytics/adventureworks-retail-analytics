-- 01 | Data validation
-- SQL dialect and physical table names: TODO after source selection.
-- Expected grain: one sales order line. Do not run as-is.

-- 1. Coverage and volume
-- TODO: map <sales_order_lines>, <order_date>, <order_id>, <customer_id>, <product_id>.
-- SELECT MIN(<order_date>) AS first_order_date,
--        MAX(<order_date>) AS last_order_date,
--        COUNT(*) AS line_rows,
--        COUNT(DISTINCT <order_id>) AS orders,
--        COUNT(DISTINCT <customer_id>) AS customers,
--        COUNT(DISTINCT <product_id>) AS products
-- FROM <sales_order_lines>;

-- 2. Key integrity
-- TODO: group by the confirmed order-line key; investigate any count > 1.
-- SELECT <order_id>, <line_id>, COUNT(*) AS rows_per_key
-- FROM <sales_order_lines>
-- GROUP BY <order_id>, <line_id>
-- HAVING COUNT(*) > 1;

-- 3. Completeness and value checks
-- TODO: count null keys/dates, zero or negative quantities and sales amounts.
-- TODO: check orphan product/customer keys after confirming dimension cardinality.

-- 4. Month coverage
-- TODO: count orders and lines by year and month.
-- Confirm that 2022 contains January–June only before using a YoY measure.

-- 5. Reconciliation
-- TODO: compare line-level sales amount with order totals, including documented
-- discount, return, tax and freight treatment.
