# Data Dictionary

This project uses the AdventureWorks retail dataset loaded into Google BigQuery.

The three annual sales files (2020, 2021 and 2022) were combined into a single `sales_data` table for analysis. The 2022 sales data covers January to June only.

---

## sales_data

**Grain:** One row per order line (`OrderNumber` + `OrderLineItem`).

| Column | Description |
|---|---|
| `OrderDate` | Date the customer order was placed |
| `StockDate` | Date associated with product stock processing |
| `OrderNumber` | Unique sales order identifier |
| `ProductKey` | Product identifier used to join to `product_lookup` |
| `CustomerKey` | Customer identifier used to join to `customer_lookup` |
| `TerritoryKey` | Sales territory identifier |
| `OrderLineItem` | Line number within an order |
| `OrderQuantity` | Number of units sold on the order line |

---

## product_lookup

**Grain:** One row per product.

| Column | Description |
|---|---|
| `ProductKey` | Unique product identifier |
| `ProductSubcategoryKey` | Links the product to its subcategory |
| `ProductSKU` | Product stock keeping unit |
| `ProductName` | Product name |
| `ModelName` | Product model |
| `ProductDescription` | Product description |
| `ProductColor` | Product colour |
| `ProductSize` | Product size |
| `ProductStyle` | Product style |
| `ProductCost` | Unit product cost |
| `ProductPrice` | Unit selling price |

---

## product_subcategories_lookup

**Grain:** One row per product subcategory.

| Column | Description |
|---|---|
| `ProductSubcategoryKey` | Unique product subcategory identifier |
| `SubcategoryName` | Product subcategory name |
| `ProductCategoryKey` | Links the subcategory to its parent category |

---

## product_categories_lookup

**Grain:** One row per product category.

| Column | Description |
|---|---|
| `ProductCategoryKey` | Unique product category identifier |
| `CategoryName` | Product category name |

---

## customer_lookup

**Grain:** One row per customer after source cleanup.

| Column | Description |
|---|---|
| `CustomerKey` | Unique customer identifier |
| `Prefix` | Customer title or prefix |
| `FirstName` | Customer first name |
| `LastName` | Customer last name |
| `BirthDate` | Customer date of birth |
| `MaritalStatus` | Customer marital status |
| `Gender` | Customer gender |
| `EmailAddress` | Customer email address |
| `AnnualIncome` | Customer annual income |
| `TotalChildren` | Number of children |
| `EducationLevel` | Customer education level |
| `Occupation` | Customer occupation |
| `HomeOwner` | Indicates home ownership status |

**Source note:** Non-customer footer rows contained in the original CSV were excluded before customer analysis.

---

## territory_lookup

**Grain:** One row per sales territory.

| Column | Description |
|---|---|
| `SalesTerritoryKey` | Unique sales territory identifier |
| `Region` | Sales region |
| `Country` | Country |
| `Continent` | Continent |

---

## returns_data

| Column | Description |
|---|---|
| `ReturnDate` | Date of the return |
| `TerritoryKey` | Territory associated with the return |
| `ProductKey` | Returned product identifier |
| `ReturnQuantity` | Number of units returned |

---

## calendar_lookup

**Grain:** One row per calendar date.

| Column | Description |
|---|---|
| `Date` | Calendar date used for time-based analysis |

---

# Table Relationships

| From | To | Key |
|---|---|---|
| `sales_data` | `product_lookup` | `ProductKey` |
| `sales_data` | `customer_lookup` | `CustomerKey` |
| `sales_data` | `territory_lookup` | `TerritoryKey` → `SalesTerritoryKey` |
| `sales_data` | `calendar_lookup` | `OrderDate` → `Date` |
| `product_lookup` | `product_subcategories_lookup` | `ProductSubcategoryKey` |
| `product_subcategories_lookup` | `product_categories_lookup` | `ProductCategoryKey` |
| `returns_data` | `product_lookup` | `ProductKey` |
| `returns_data` | `territory_lookup` | `TerritoryKey` → `SalesTerritoryKey` |
| `returns_data` | `calendar_lookup` | `ReturnDate` → `Date` |

---

# Derived Metrics

| Metric | Definition |
|---|---|
| Revenue | `ProductPrice × OrderQuantity` |
| Cost | `ProductCost × OrderQuantity` |
| Profit | `Revenue - Cost` |
| Profit Margin % | `Profit / Revenue × 100` |
| Total Orders | Distinct count of `OrderNumber` |
| Active Customers | Distinct count of `CustomerKey` within the selected period |
| Average Order Value | `Revenue / Total Orders` |
| Revenue Contribution % | `Group Revenue / Total Revenue × 100` |
| Repeat Customer | Active customer with more than one distinct order within the selected period |
| Repeat Customer Rate % | `Repeat Customers / Active Customers × 100` |
| Returned Units | Sum of `ReturnQuantity` |
