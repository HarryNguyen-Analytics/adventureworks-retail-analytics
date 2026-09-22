# DAX measures

These are measure specifications. Replace table and column placeholders after the source model is verified.

| Measure | Definition |
| --- | --- |
| Revenue | Sum of validated sales amount at order-line grain |
| Orders | Distinct count of order ID |
| Units | Sum of validated quantity |
| Average Order Value | Revenue / Orders |
| Active Customers | Distinct customers with at least one order in the selected period |
| Repeat Customers | Active customers with more than one distinct order in the selected period |
| Repeat Customer Rate | Repeat Customers / Active Customers |

```dax
Revenue = SUM ( 'Sales'[ValidatedSalesAmount] )
Orders = DISTINCTCOUNT ( 'Sales'[OrderID] )
Average Order Value = DIVIDE ( [Revenue], [Orders] )
Active Customers = DISTINCTCOUNT ( 'Sales'[CustomerID] )
Repeat Customers =
    COUNTROWS (
        FILTER (
            VALUES ( 'Sales'[CustomerID] ),
            NOT ISBLANK ( 'Sales'[CustomerID] )
                && CALCULATE ( DISTINCTCOUNT ( 'Sales'[OrderID] ) ) > 1
        )
    )
Repeat Customer Rate = DIVIDE ( [Repeat Customers], [Active Customers] )
```

Exclude blank customer IDs consistently from both numerator and denominator if the source contains them. Validate every measure against SQL totals and selected date filters.

## Time comparison

Implement YoY only through matched date windows. Since 2022 includes January–June only, compare January–June 2023 with January–June 2022 when evaluating that pair. Show the comparison window in report labels and suppress growth where the prior comparable period is incomplete or absent. Do not interpret Repeat Customer Rate as retention.
