-- 02 | Data exploration
-- Map placeholders to the validated schema and chosen SQL dialect.

-- 1. Monthly coverage
-- TODO: report order count, active customer count and revenue by year/month.
-- Look for missing months; confirm 2022 ends in June.

-- 2. Product mix
-- TODO: count distinct products by category/subcategory and inspect null labels.
-- Check for one-to-many product mappings before joining sales to dimensions.

-- 3. Customer coverage
-- TODO: inspect order counts per customer within the available date window.
-- Separate missing customer IDs from known customers.

-- 4. Distribution and outliers
-- TODO: profile order-line quantity, line amount and order value.
-- Investigate negative amounts, unusually large orders and return records.

-- 5. Analysis-ready view
-- TODO: create a documented order-line view with confirmed order date, customer,
-- product, quantity and revenue; keep the original source values traceable.
