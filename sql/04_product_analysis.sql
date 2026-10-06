/*
============================================================
Project: AdventureWorks Retail Analytics

File: 04_product_analysis.sql
Purpose:
Analyse category, subcategory and product performance,
revenue contribution, profitability and product returns.

SQL dialect: GoogleSQL
Platform: Google BigQuery
============================================================
*/

-- =========================================================
-- 1. CATEGORY PERFORMANCE
-- Compare category sales, profitability and revenue share.
-- =========================================================
with category_summary as (
select 
  p.ProductName as category,
  sum(s.OrderQuantity) as total_unit_sold,
  round(sum(s.OrderQuantity*p.ProductPrice),2) as total_revenue,
  round(sum(s.OrderQuantity*(p.ProductPrice - p.ProductCost)),2) as total_profit
from `adventureworks.sales_data` s
join `adventureworks.product_lookup` p on p.ProductKey = s.ProductKey
join `adventureworks.product_subcategories_lookup` ps on ps.ProductSubcategoryKey = p.ProductSubcategoryKey
join `adventureworks.product_categories_lookup` pc on pc.ProductCategoryKey = ps.ProductCategoryKey
group by category)


select cm.category, cm.category, cm.total_revenue, cm.total_profit,
round(cm.total_profit/cm.total_revenue*100,2) as profit_margin_pct,
round(cm.total_revenue/sum(total_revenue) over()*100,2) as revenue_cont_pct
from category_summary cm
order by cm.total_revenue desc;

-- =========================================================
-- 2. SUBCATEGORY PERFORMANCE
-- Rank subcategories by revenue within each category.
-- =========================================================
with subcategory_summary as (
select
  pc.CategoryName as category,
  ps.SubcategoryName as subcategory,
  sum(s.OrderQuantity) as total_unit_sold,
  round(sum(s.OrderQuantity * p.ProductPrice),2) as total_revenue,
  round(sum(s.OrderQuantity * (p.ProductPrice - p.ProductCost)),2) as total_profit
from `adventureworks.sales_data` s
join `adventureworks.product_lookup` p
  on s.ProductKey = p.ProductKey
join `adventureworks.product_subcategories_lookup` ps
  on p.ProductSubcategoryKey = ps.ProductSubcategoryKey
join `adventureworks.product_categories_lookup` pc
  on ps.ProductCategoryKey = pc.ProductCategoryKey
group by category, subcategory
)
select ss.category, ss.subcategory, ss.total_unit_sold, ss.total_revenue, ss.total_profit,
round(ss.total_profit/ss.total_revenue*100,2) as profit_margin_pct,
rank() over(partition by ss.category order by ss.total_revenue desc) as revenue_rank
from subcategory_summary ss
order by ss.category, revenue_rank

-- =========================================================
-- 3. TOP PRODUCTS BY REVENUE
-- Identify the highest-revenue products.
-- =========================================================
with product_summary as (
select
  p.ProductKey as product_key, p.ProductName as product_name,
  sum(s.OrderQuantity) as total_unit_sold,
  round(sum(s.OrderQuantity * p.ProductPrice),2) as total_revenue,
  round(sum(s.OrderQuantity * (p.ProductPrice - p.ProductCost)),2) as total_profit
from `adventureworks.sales_data` s
join `adventureworks.product_lookup` p
  on s.ProductKey = p.ProductKey
group by p.ProductKey, p.ProductName)
select
  ps.product_key, ps.product_name, ps.total_unit_sold, ps.total_revenue, ps.total_profit,
  rank() over(
    order by ps.total_revenue desc
  ) as revenue_rank
from product_summary ps
order by revenue_rank
limit 10;

-- =========================================================
-- 4. PRODUCT PROFITABILITY
-- Compare product profit and profit margin.
-- =========================================================
with product_profit_summary as (
select
  p.ProductKey as product_name,
  p.ProductName as product_key,
  sum(s.OrderQuantity) as total_unit_sold,
  round(sum(s.OrderQuantity * p.ProductPrice),2) as total_revenue,
  round(sum(s.OrderQuantity * (p.ProductPrice - p.ProductCost)),2) as total_profit
from `adventureworks.sales_data` s
join `adventureworks.product_lookup` p on s.ProductKey = p.ProductKey
group by p.ProductKey, p.ProductName )
select
  pps.product_name,
  pps.product_key,
  pps.total_unit_sold,
  pps.total_revenue,
  pps.total_profit,
  round( pps.total_profit/pps.total_revenue*100,2 ) as profit_margin_pct
from product_profit_summary pps
order by pps.total_profit desc;

