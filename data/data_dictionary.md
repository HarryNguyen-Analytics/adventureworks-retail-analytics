# Data dictionary

## Source and grain

**Source:** AdventureWorks retail extract — exact edition, source URL and refresh date to be recorded when the data is selected.

**Proposed analytical grain:** one row per sales order line. Confirm this against a unique order-line key before calculating revenue or joining dimensions. Document whether cancelled orders, returns, discounts, tax and freight are present and how they affect reported revenue.

| Business entity | Required fields to map | Validation |
| --- | --- | --- |
| Sales order line | order ID, line ID, product ID, order date, quantity, sales amount | Unique order-line key; non-null IDs and date |
| Order / customer | order ID, customer ID | One customer per order; valid customer keys |
| Product | product ID, name, category, subcategory | One active product mapping per product ID |
| Date | date, year, month | Continuous calendar and correct relationship to order date |

## Confirm before analysis

- Exact table and column names, data types, timezone and currency.
- Whether sales amount is line total before or after discounts, returns, tax or freight.
- Whether customer IDs are stable across orders and channels.
- Whether product attributes are current-state or historical.
- Date coverage by month. The stated 2022 coverage is **January–June**; confirm this from the extract. YoY involving 2022 uses the same January–June window.
- Missing values, duplicate order lines, orphaned product/customer keys and negative or zero quantities and amounts.

Record the verified schema, row counts and validation results here once the source is available.
