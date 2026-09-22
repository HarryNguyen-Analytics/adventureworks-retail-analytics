-- 04 | Product analysis
-- Use product keys validated against the order-line fact.

-- 1. Category and subcategory contribution
-- TODO: revenue, units, orders and share of total revenue.
-- Use a distinct order count when a basket contains multiple products.

-- 2. Product ranking
-- TODO: rank products by revenue and units within the same selected period.
-- Include category context and avoid interpreting revenue as profit.

-- 3. Mix over time
-- TODO: track category share by comparable month or period.
-- Check whether product availability changes across years.

-- 4. Concentration
-- TODO: calculate cumulative revenue share for ranked products.
-- Do not recommend assortment changes without margin, stock and availability data.
