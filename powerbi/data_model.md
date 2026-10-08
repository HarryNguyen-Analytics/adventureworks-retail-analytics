# Power BI Data Model

The Power BI model uses a star-schema-style structure with sales and returns data connected to shared dimension tables.

## Model Structure

### Fact Tables

**Sales Data**
- OrderDate
- StockDate
- OrderNumber
- ProductKey
- CustomerKey
- TerritoryKey
- OrderLineItem
- OrderQuantity

**Returns Data**
- ReturnDate
- TerritoryKey
- ProductKey
- ReturnQuantity

### Dimension Tables

**Product Lookup**
- Product information, price and cost
- Linked to Product Subcategories

**Product Subcategories Lookup**
- Product subcategory information
- Linked to Product Categories

**Product Categories Lookup**
- Product category information

**Customer Lookup**
- Customer demographic and profile attributes

**Territory Lookup**
- Region, country and continent

**Calendar Lookup**
- Shared date dimension used for time-based analysis

## Key Relationships

| From | To | Relationship |
|---|---|---|
| Sales Data | Product Lookup | ProductKey |
| Sales Data | Customer Lookup | CustomerKey |
| Sales Data | Territory Lookup | TerritoryKey |
| Sales Data | Calendar Lookup | OrderDate |
| Product Lookup | Product Subcategories Lookup | ProductSubcategoryKey |
| Product Subcategories Lookup | Product Categories Lookup | ProductCategoryKey |
| Returns Data | Product Lookup | ProductKey |
| Returns Data | Territory Lookup | TerritoryKey |
| Returns Data | Calendar Lookup | ReturnDate |

## Modelling Approach

The model separates transactional data from descriptive dimensions so that sales, product and customer measures can be analysed consistently across dashboard pages.

The Calendar table provides the common time dimension for monthly and year-over-year analysis.

2022 contains January–June data only. YoY measures involving 2022 therefore use comparable January–June periods rather than comparing against the full 2021 year.
