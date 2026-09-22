# Power BI data model

## Intended model

A star schema built from the validated sales order-line fact, with Date, Product and Customer dimensions. Order ID remains available for distinct-order measures. Add an Order dimension only if order-level attributes or relationship needs justify it.

| Table | Grain | Relationship |
| --- | --- | --- |
| Sales fact | One confirmed order line | Many-to-one to Date, Product and Customer |
| Date | One calendar date | Active relationship to order date |
| Product | One product key | Unique product key |
| Customer | One customer key | Unique customer key |

Confirm keys, cardinality, inactive dates, blank members and filter direction in the actual model. Prefer single-direction dimension-to-fact filtering. Keep all time comparisons on the Date table.

## Planned report pages

1. **Executive overview:** revenue, orders, AOV, active customers and comparable sales trend.
2. **Product analysis:** category mix, product ranking and contribution.
3. **Customer analysis:** active customers, order frequency and Repeat Customer Rate.

Use clear period labels. A 2022 YoY view must compare January–June with January–June. Add model and report screenshots to `images/` only after the PBIX is built and checked.
