/*
============================================================
Project: AdventureWorks Retail Analytics

File: 05_customer_analysis.sql
Purpose:
Analyse customer activity, repeat purchasing, customer value
and demographic performance.

SQL dialect: GoogleSQL
Platform: Google BigQuery
============================================================
*/

-- =========================================================
-- 1. OVERALL CUSTOMER PERFORMANCE
-- Review customer activity and purchasing value.
-- =========================================================

select
  count(distinct s.CustomerKey) as total_customer,
  count(distinct s.OrderNumber) as total_order,
  round( count(distinct s.OrderNumber) / count(distinct s.CustomerKey),2 ) as avg_order_per_customer,
  round(sum(s.OrderQuantity * p.ProductPrice),2) as total_revenue,
  round(sum(s.OrderQuantity * p.ProductPrice) / count(distinct s.CustomerKey),2) as avg_revenue_per_customer
from `adventureworks.sales_data` s
join `adventureworks.product_lookup` p on s.ProductKey = p.ProductKey;

-- =========================================================
-- 2. REPEAT CUSTOMER RATE
-- Measure the share of active customers placing more than
-- one order within the available period.
-- =========================================================

with customer_summary as (
select
  s.CustomerKey,
  count(distinct s.OrderNumber) as total_order
from `adventureworks.sales_data` s
group by s.CustomerKey )

select 
  count(*) as total_customer,
  sum(case when cs.total_order > 1 then 1 else 0 end) as repeat_customer,
  round(sum(case when cs.total_order > 1 then 1 else 0 end) / count(*) * 100,2) as repeat_customer_rate_pct
from customer_summary 

/*
  Result:
Row	total_customer: 17416	
Repeat_customer: 5857
Repeat_customer_rate_pct: 33.63
*/

-- =========================================================
-- 3. CUSTOMER PURCHASE FREQUENCY
-- Show how customers are distributed by number of orders.
-- =========================================================
with customer_summary as (
select
  s.CustomerKey,
  count(distinct s.OrderNumber) as total_order
from `adventureworks.sales_data` s
group by s.CustomerKey)
select cs.total_order,
  count(*) as total_customer
from customer_summary cs
group by cs.total_order
order by cs.total_order;

-- =========================================================
-- 4. TOP CUSTOMERS BY REVENUE
-- Identify customers generating the highest sales value.
-- =========================================================

select
  s.CustomerKey as customer_key,
  count(distinct s.OrderNumber) as total_order,
  sum(s.OrderQuantity) as total_unit_sold,
  round(sum(s.OrderQuantity * p.ProductPrice),2) as total_revenue
from `adventureworks.sales_data` s
join `adventureworks.product_lookup` p on s.ProductKey = p.ProductKey
group by s.CustomerKey
order by total_revenue desc
limit 10;

-- =========================================================
-- 5. CUSTOMER PERFORMANCE BY OCCUPATION
-- Compare customer activity and revenue across occupations.
-- =========================================================

select
  c.Occupation as occupation,
  count(distinct s.CustomerKey) as total_customer,
  count(distinct s.OrderNumber) as total_order,
  round(sum(s.OrderQuantity * p.ProductPrice),2) as total_revenue,
  round(sum(s.OrderQuantity * p.ProductPrice)/count(distinct s.CustomerKey),2) as avg_revenue_per_customer
from `adventureworks.sales_data` s
join `adventureworks.product_lookup` p on s.ProductKey = p.ProductKey
join `adventureworks.customer_lookup` c on s.CustomerKey = c.CustomerKey
group by c.Occupation
order by total_revenue desc;

/*
Result:
- Professional customers generated the highest revenue at $8.47M
  and recorded the highest average revenue per customer at $1,622.18.
- Management customers also showed relatively high customer value
  at $1,589.87 per customer despite a smaller customer base.
- Manual customers recorded the lowest revenue and average revenue
  per customer among the occupation groups.
*/
