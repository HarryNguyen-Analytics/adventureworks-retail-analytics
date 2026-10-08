# DAX Measures

Key measures used across the AdventureWorks Power BI dashboard.


```DAX
Total Revenue =
SUMX(
    'Sales Data',
    'Sales Data'[OrderQuantity] * RELATED('Product Lookup'[ProductPrice])
)

Total Cost =
SUMX(
    'Sales Data',
    'Sales Data'[OrderQuantity] * RELATED('Product Lookup'[ProductCost])
)

Total Profit =
[Total Revenue] - [Total Cost]

Profit Margin % =
DIVIDE(
    [Total Profit],
    [Total Revenue]
)

Total Orders =
DISTINCTCOUNT('Sales Data'[OrderNumber])

Active Customers =
DISTINCTCOUNT('Sales Data'[CustomerKey])

Average Order Value =
DIVIDE(
    [Total Revenue],
    [Total Orders]
)

Revenue Contribution % =
DIVIDE(
    [Total Revenue],
    CALCULATE(
        [Total Revenue],
        ALL('Product Categories Lookup'[CategoryName])
    )
)

Repeat Customers =
COUNTROWS(
    FILTER(
        VALUES('Sales Data'[CustomerKey]),
        CALCULATE(
            DISTINCTCOUNT('Sales Data'[OrderNumber])
        ) > 1
    )
)

Repeat Customer Rate % =
DIVIDE(
    [Repeat Customers],
    [Active Customers]
)
```

## Interpretation

Revenue and cost sum product lookup price and cost multiplied by order quantity. Profit is revenue less product cost; returns and operating expenses are not deducted. AOV divides revenue by distinct OrderNumber.

Repeat Customer Rate is the share of active customers with more than one distinct order in the selected period and filter context. It measures repeat purchasing within that window, not customer retention across periods.

Sales data covers 2020, 2021 and January–June 2022. Any 2022 YoY comparison must use January–June 2022 against January–June 2021. The measures listed above do not define a YoY calculation.

See the [README](../README.md#metric-definitions) for metric definitions and data limitations.
