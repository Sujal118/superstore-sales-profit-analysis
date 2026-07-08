#  Superstore Sales & Profitability Analysis

An end-to-end sales and profitability analysis of the **Sample Superstore** dataset (2011–2014), covering SQL analytics, exploratory data analysis in Python, an interactive Power BI dashboard, and a polished PDF business report.

> **TL;DR** — $2.30M in sales and $286K in profit (12.5% margin) over four years. Technology and Office Supplies are the profit engines (~17% margin); Furniture is a structural drag (2.5% margin). Discounts above 20% flip orders unprofitable, and four states (TX, OH, PA, IL) are net loss-making despite strong sales volume.

---

## Repository Contents

| File | Description |
|---|---|
| `Superstore.csv` | Raw transactional dataset — 9,994 order lines, 5,009 orders, 793 customers (2011–2014) |
| `sales_profit.sql` | SQL queries covering monthly/yearly trends, growth rates, regional & category breakdowns, discount impact, and loss-making product/region analysis |
| `Sales_profit.ipynb` | Python (pandas) notebook used to validate SQL results and explore the data |
| `sales_profit.pbix` | Interactive Power BI dashboard for visual, drill-down exploration |
| `Superstore_Sales_Profit_Report.pdf` | Final formatted business report — executive summary, charts, tables, and recommendations |

---

## Key Metrics

| Metric | Value |
|---|---|
| Total Sales | **$2,297,201** |
| Total Profit | **$286,397** |
| Overall Profit Margin | **12.5%** |
| Total Orders | 5,009 |
| Unique Customers | 793 |
| Unique Products | 1,841 |
| Average Order Value | $458.61 |
| Period Covered | Jan 2011 – Dec 2014 |

---

## Analysis Covered

- **Time-series trends** — monthly and yearly sales/profit, month-over-month growth, cumulative totals, seasonality (Nov–Dec peaks)
- **Regional performance** — sales, profit, and margin by region and state; identification of loss-making regions
- **Category & sub-category breakdown** — profit margin by product category, with sub-category-level profit ranking
- **Discount & pricing impact** — correlation between discount level and profit; margin by discount band
- **Customer segment analysis** — Consumer vs. Corporate vs. Home Office performance
- **Shipping mode analysis** — sales and profit by fulfillment method
- **Product-level risk** — high-sales/negative-profit products and top loss-making SKUs

---

## Key Findings

1. **Technology (17.4% margin)** and **Office Supplies (17.0% margin)** are the most profitable categories; **Furniture (2.5% margin)** is dragged down by Tables and Bookcases, both of which are net-unprofitable.
2. **Discounting above 20% destroys profit.** Full-price orders run at a 29.5% margin; orders discounted 40%+ average **-77.4% margin**, collectively wiping out ~$100K in profit.
3. **The West region leads on every metric** (14.9% margin); **Central lags** at just 7.9% margin.
4. **Texas, Ohio, Pennsylvania, and Illinois** post negative total profit despite meaningful sales volume — candidates for a regional pricing review.
5. **Sales are highly seasonal**, peaking every November–December.
6. 123 products generate above-average sales but still lose money overall — led by 3D printers, a Cisco TelePresence system, and several premium conference tables.

Full methodology, charts, and prioritized recommendations are in [`Superstore_Sales_Profit_Report.pdf`](./Superstore_Sales_Profit_Report.pdf).

---

## Tools & Stack

- **SQL** — aggregation, window functions (`LAG`, `RANK`, running totals) for trend and ranking analysis
- **Python** — `pandas` for data validation and exploration
- **Power BI** — interactive dashboard for stakeholder self-service exploration
- **Python (matplotlib / reportlab)** — final report generation

---

## How to Use

1. **Explore the raw data:** open `Superstore.csv` in any spreadsheet tool or load it with pandas.
2. **Run the SQL queries:** load `Superstore.csv` into a Postgres (or compatible) database as a table named `sales`, then run `sales_profit.sql`.
3. **Explore interactively:** open `sales_profit.pbix` in Power BI Desktop.
4. **Read the summary:** open `Superstore_Sales_Profit_Report.pdf` for the full narrative, charts, and recommendations.

