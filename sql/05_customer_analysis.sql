-- 05 | Customer analysis
-- Customer identity and order keys must be validated first.

-- 1. Active customers and orders
-- TODO: count distinct customers and orders within the selected period.

-- 2. Repeat Customer Rate
-- Definition: customers with >1 distinct order in the selected period
-- divided by active customers with >=1 distinct order in that same period.
-- This is not a retention rate.
-- Template:
-- WITH customer_orders AS (
--   SELECT <customer_id>, COUNT(DISTINCT <order_id>) AS order_count
--   FROM <validated_order_view>
--   WHERE <order_date> >= <period_start>
--     AND <order_date> < <period_end_exclusive>
--     AND <customer_id> IS NOT NULL
--   GROUP BY <customer_id>
-- )
-- SELECT SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) * 1.0
--        / NULLIF(COUNT(*), 0) AS repeat_customer_rate
-- FROM customer_orders;

-- 3. Customer revenue distribution
-- TODO: rank customers by validated revenue and calculate contribution shares.
-- Avoid inferring lifetime value from a partial observation window.

-- 4. Cohorts (future)
-- TODO: add only after full customer history and a clear first-order definition
-- are available. Do not label period-based repeat purchasing as retention.
