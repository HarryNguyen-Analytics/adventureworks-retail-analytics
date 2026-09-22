-- 03 | Sales performance
-- Use the validated order-line view and confirmed net revenue definition.

-- 1. Monthly sales: revenue, distinct orders, active customers, units and AOV.
-- TODO: aggregate at calendar month; AOV = revenue / distinct orders.

-- 2. YoY: aligned periods only.
-- TODO: compare the same months across years. Because 2022 covers January–June,
-- compare January–June 2023 against January–June 2022, never 2023 full year
-- against 2022 half year.
-- YoY % = (current comparable-period revenue / prior comparable-period revenue) - 1.
-- Guard against zero or missing prior-period values.

-- 3. Monthly movement
-- TODO: use LAG on a complete monthly calendar; distinguish missing months from
-- genuine zero sales.

-- 4. Revenue concentration
-- TODO: rank months and calculate contribution to total revenue only after
-- validating the date window and source filters.
