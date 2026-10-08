# DAX Measures

Key measures used across the AdventureWorks Power BI dashboard.

## Revenue

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

