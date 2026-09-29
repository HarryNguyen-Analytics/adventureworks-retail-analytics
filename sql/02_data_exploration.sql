-- =========================================================
-- 02 | DATA EXPLORATION
-- Understand sales patterns, product mix, customer activity
-- and transaction distribution before deeper analysis.
-- =========================================================


-- 1. MONTHLY SALES OVERVIEW
-- Review monthly orders, customers, units sold and revenue.
select
  extract (year from s.OrderDate) as sales_year,
  extract (month from s.OrderDate) as sales_month,
  count(distinct s.OrderNumber) as total_order,
  count(distinct s.CustomerKey) as active_customers,
  sum(s.OrderQuantity) as total_units_sold,
  round(sum(s.OrderQuantity * p.ProductPrice),2) as total_revenue

from `adventureworks.sales_data` s
join `adventureworks.product_lookup` p on s.ProductKey = p.ProductKey
group by sales_year, sales_month
order by sales_year, sales_month;
/*
Result:
- Sales data covers 2020, 2021 and January-June 2022.
- Monthly sales activity can be reviewed using orders, active customers, units sold and revenue.
*/

-- 2. PRODUCT MIX
-- Review the number of active products across categories
-- and subcategories.
select 
   pc.CategoryName as category,
   count(distinct p.ProductKey) as total_products,
   count(distinct s.ProductKey) as active_product,
   sum(s.OrderQuantity) as total_unit_sold,
   round(sum(s.OrderQuantity * p.ProductPrice),2) as total_revenue
from `adventureworks.sales_data` s
join `adventureworks.product_lookup` p on s.ProductKey = p.ProductKey
join `adventureworks.product_subcategories_lookup` ps on p.ProductSubcategoryKey = ps.ProductSubcategoryKey
join `adventureworks.product_categories_lookup` pc on ps.ProductCategoryKey = pc.ProductCategoryKey
group by pc.CategoryName
order by total_revenue desc;
/*
Result:
Bikes generated the majority of sales revenue despite lower unit volume than Accessories
ndicating that higher-priced products are the primary revenue driver. 
All products within the observed categories were active during the sales period.
*/

-- 3. CUSTOMER ACTIVITY
select 
  pc.CategoryName as category,
  ps.SubcategoryName as subcategory,
  count(distinct s.ProductKey) as active_product,
  sum(s.OrderQuantity) as total_unit_sold,
  round(sum(s.OrderQuantity * p.ProductPrice),2) as total_revenue
from `adventureworks.sales_data` s
join `adventureworks.product_lookup` p on s.ProductKey = p.ProductKey
join `adventureworks.product_subcategories_lookup` ps on p.ProductSubcategoryKey = ps.ProductSubcategoryKey
join `adventureworks.product_categories_lookup` pc on ps.ProductCategoryKey = pc.ProductCategoryKey
group by pc.CategoryName, ps.SubcategoryName
order by pc.CategoryName, total_revenue desc;
/*
Result:
- Subcategory-level exploration shows where product activity
  and sales value are concentrated within each category.
*/

-- =========================================================
-- 4. CUSTOMER ORDER ACTIVITY
-- Review how frequently customers placed orders.
-- =========================================================
with sales_summary as (
select 
  s.CustomerKey,
  count(distinct s.OrderNumber) as total_order,
  round(sum(p.ProductCost*s.OrderQuantity),2) as total_revenue
from `adventureworks.sales_data` s 
join `adventureworks.product_lookup` p on p.ProductKey = s.ProductKey
group by s.CustomerKey)

select sales_summary.total_order,
count(*) as total_customer
from sales_summary 
group by sales_summary.total_order
order by sales_summary.total_order
/*
Result:
- Customer order frequency distribution shows how many customers placed one order versus multiple orders.
*/

-- =========================================================
-- 5. CUSTOMER PURCHASE SUMMARY
-- Review customer-level purchasing volume and value.
-- =========================================================
select
    s.CustomerKey,
    count(distinct s.OrderNumber) as total_orders,
    sum(s.OrderQuantity) as total_units_sold,
    round(sum(s.OrderQuantity * p.ProductPrice), 2) as total_revenue
from `adventureworks.sales_data` s
join `adventureworks.product_lookup` p on s.ProductKey = p.ProductKey
group by s.CustomerKey
order by total_revenue desc;
/*
Result:

- Customer-level aggregation provides the base for later
  repeat customer and customer value analysis.
*/

-- =========================================================
-- 6. ORDER LINE QUANTITY DISTRIBUTION
-- Review how many units are purchased per order line.
-- =========================================================
select
  s.OrderQuantity,
  count(*) as total_order_lines,
  round(
    count(*) / sum(count(*)) over() * 100,2) as order_line_percentage
from `adventureworks.sales_data` s
group by s.OrderQuantity
order by s.OrderQuantity;

/*
Result:
- Order quantity distribution shows the typical number of units purchased within individual sales lines.
*/

-- =========================================================
-- 7. RETURNS BY PRODUCT
-- Identify products with the highest return volume.
-- =========================================================

select
    p.ProductKey,
    p.ProductName,
    sum(r.ReturnQuantity) as total_units_returned
from `adventureworks.returns_data` r
join `adventureworks.product_lookup` p
    on r.ProductKey = p.ProductKey
group by p.ProductKey, p.ProductName
order by total_units_returned desc;
/*
Result:
- Product-level return volume identifies which products account for the highest number of returned units.
*/
