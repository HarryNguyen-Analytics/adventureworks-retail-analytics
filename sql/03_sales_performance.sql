/*
============================================================
Project: AdventureWorks Retail Analytics

File: 03_sales_performance.sql
Purpose:
Analyse overall sales performance, revenue trends, profitability and period-over-period growth.
SQL dialect: GoogleSQL
Platform: Google BigQuery
============================================================
*/
-- =========================================================
-- 1. OVERALL SALES PERFORMANCE
-- Review core sales and profitability KPIs.
-- =========================================================
with sales_summary as (
select 
  count(distinct s.OrderNumber) as total_order,
  count(distinct s.CustomerKey) as total_customer,
  sum(s.OrderQuantity) as total_unit_sold,
  round(sum(p.ProductPrice * s.OrderQuantity),2) as total_revenue,
  round(sum(p.ProductCost * s.OrderQuantity),2) as total_cost,
  round(sum((p.ProductPrice - p.ProductCost) * s.OrderQuantity),2) as total_profit
from `adventureworks.sales_data` s
join `adventureworks.product_lookup` p on p.ProductKey = s.ProductKey)

select sm.total_order, sm.total_customer, sm.total_unit_sold,
round(sm.total_profit/sm.total_revenue*100,2) as profit_margin_pct,
round(sm.total_revenue/sm.total_order ,2) as avg_order_value
from sales_summary sm;

-- =========================================================
-- 2. MONTHLY SALES TREND
-- Review revenue, orders and units sold over time.
-- =========================================================
select
  extract(year from s.OrderDate) as year_sale,
  extract(month from s.OrderDate) as month_sale,
  count(distinct s.OrderNumber) as total_order,
  sum(s.OrderQuantity) as total_unit_sold,
  round(sum(p.ProductPrice * s.OrderQuantity),2) as total_revenue,
  round(sum(s.OrderQuantity * (p.ProductPrice-p.ProductCost)),2) as total_profit
from `adventureworks.sales_data` s
join `adventureworks.product_lookup` p on p.ProductKey = s.ProductKey
group by year_sale, month_sale
order by year_sale, month_sale

/*
Important: 2022 contains January-June only.
*/

-- =========================================================
-- 3. YEARLY SALES PERFORMANCE
-- Compare revenue, profit, margin and AOV by year.
-- =========================================================
with sale_summary as (
select
  extract(year from s.OrderDate) as year_sale,
  count(distinct s.OrderNumber) as total_order,
  count(distinct s.CustomerKey) as total_customer,
  sum(s.OrderQuantity) as total_unit_sold,
  round(sum(s.OrderQuantity * p.ProductPrice), 2) as total_revenue,
  round(sum(s.OrderQuantity * (p.ProductPrice - p.ProductCost)), 2) as total_profit,
from `adventureworks.sales_data` s
join `adventureworks.product_lookup` p
    on s.ProductKey = p.ProductKey
group by year_sale)

select 
  sm.year_sale,sm.total_order,sm.total_customer,sm.total_unit_sold,
  sm.total_revenue,sm.total_profit,
  round(sm.total_profit/sm.total_revenue*100,2) as profit_margin_pct,
  round(sm.total_revenue/sm.total_order,2) as avg_order_value
from sale_summary sm
order by sm.year_sale;
/*
Note:
2022 is a partial year and should not be directly compared with full-year 2021 without matching the same period.
*/

-- =========================================================
-- 4. MONTH-OVER-MONTH REVENUE GROWTH
-- Compare each month with the immediately previous month.
-- =========================================================
with monthly_summary as (
select
  extract (year from s.OrderDate) as year_sale,
  extract (month from s.OrderDate) as month_sale,
  round(sum(s.OrderQuantity * p.ProductPrice), 2) as total_revenue
from `adventureworks.sales_data` s 
join `adventureworks.product_lookup` p on p.ProductKey = s.ProductKey
group by year_sale, month_sale),

monthly_comparison as (
select ms.year_sale, ms.month_sale, ms.total_revenue,
lag(ms.total_revenue) over(order by ms.year_sale, ms.month_sale) as prev_month_revenue
from monthly_summary ms)

select mc.year_sale, mc.month_sale, mc.total_revenue, mc.prev_month_revenue,
round((mc.total_revenue - mc.prev_month_revenue)/mc.prev_month_revenue*100,2) as mom_revenue_growth_pct
from monthly_comparison mc
order by mc.year_sale, mc.month_sale

-- =========================================================
-- 5. YEAR-OVER-YEAR REVENUE GROWTH
-- Use the same available month range for fair comparison.
-- =========================================================
with monthly_summary as (
select
  extract(year from s.OrderDate) as year_sales,
  extract(month from s.OrderDate) as month_sales,
  sum(s.OrderQuantity * p.ProductPrice) as total_revenue
from `adventureworks.sales_data` s
join `adventureworks.product_lookup` p
  on s.ProductKey = p.ProductKey
group by year_sales, month_sales
)

select
  ms.year_sales,
  count(*) as month_count,
  round(sum(ms.total_revenue),2) as total_revenue,
  round(sum(ms.total_revenue),2) as prev_year_revenue,
  round(safe_divide(sum(ms.total_revenue) - sum(ms2.total_revenue),sum(ms2.total_revenue))*100,2) as yoy_revenue_growth_pct
from monthly_summary ms
left join monthly_summary ms2 on ms2.year_sales = ms.year_sales - 1
    and ms2.month_sales = ms.month_sales
group by ms.year_sales
order by ms.year_sales;
/*
Result:
- 2022 YoY revenue is compared against January-June 2021 to account for partial-year data.
- Row	year_sales	month_count	total_revenue	prev_year_revenue	yoy_revenue_growth_pct
1	2020	12	6404933.58	0.0	null
2	2021	12	9324203.79	6404933.58	45.58
3	2022	6	9185449.45	2952867.55	211.07
*/
