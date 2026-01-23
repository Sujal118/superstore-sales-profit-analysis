select * from sales

-- Find total sales and total profit for each month from start to end.

Select 
date_trunc('month',order_date) as month,
sum(sales) as total_sales,
sum(profit) as total_profit
from sales
group by month 
order by month;



-- Identify the month with the highest total sales.

Select 
date_trunc('month',order_date) as month,
Round(sum(sales)::numeric,2) as total_sales
from sales
group by month 
order by total_sales desc
limit 1;


-- Find the month with the lowest total profit.

Select 
date_trunc('month',order_date) as month,
Round(sum(profit)::numeric,2) as total_profit
from sales
group by month 
order by total_profit

limit 1;


-- Calculate month-over-month sales growth compared to the previous month.

WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', order_date) AS month,
        SUM(sales) AS total_sales
    FROM sales
    GROUP BY month
)
SELECT
    month,
    ROUND(total_sales::numeric, 2) AS total_sales,
    ROUND(
        (total_sales - LAG(total_sales) OVER (ORDER BY month)) --Lag is ued to access previous data i.e previous month sale
        / LAG(total_sales) OVER (ORDER BY month) * 100
    , 2) AS mom_sales_growth_percent
FROM monthly_sales
ORDER BY month;


 -- Yearly sales & profit summary Question: Find total sales and total profit for each year.

Select 
date_trunc('year',order_date) as year,
sum(sales) as total_sales,
sum(profit) as total_profit
from sales
group by year 
order by year;


 -- Best year vs worst year Question: Identify the year with the highest total profit and the year with the lowest total profit. 
 
WITH yearly_profit AS (
    SELECT
        EXTRACT(YEAR FROM order_date) AS year,
        SUM(profit) AS total_profit
    FROM sales
    GROUP BY year
)
SELECT *
FROM yearly_profit
WHERE total_profit = (SELECT MAX(total_profit) FROM yearly_profit)
   OR total_profit = (SELECT MIN(total_profit) FROM yearly_profit);
 
 -- Yearly profit margin Question: Calculate profit margin (profit / sales) for each year. 

SELECT
    EXTRACT(YEAR FROM order_date) AS year,
    ROUND(SUM(profit)::numeric, 2) AS total_profit,
    ROUND(SUM(sales)::numeric, 2) AS total_sales,
    ROUND((SUM(profit)  / NULLIF(SUM(sales), 0) * 100)::numeric, 2) AS profit_margin_percent
FROM sales
GROUP BY year
ORDER BY year;

 
 
 -- 🟨 START → END (FULL TIMELINE)
 -- Overall performance (entire dataset) Question: Calculate total sales, total profit, and profit margin from the first date to the last date in the dataset.
 
select
	min(order_date) as strat_date,
	max(order_date) as end_date,
	round(sum(sales)::numeric,2) as total_sales, 
	round(sum(profit)::numeric,2) as total_profit, 
	round((sum(profit)/nullif(sum(sales),0)*100)::numeric,2) as profit_margin_percent
from sales;
 -- Cumulative sales & profit over time Question: Calculate cumulative sales and cumulative profit from the start date to the end date. (Running total) 


WITH monthly_summary AS (
    SELECT
        DATE_TRUNC('month', order_date) AS month,
        SUM(sales)  AS monthly_sales,
        SUM(profit) AS monthly_profit
    FROM sales
    GROUP BY month
)
SELECT
    month,
    ROUND(monthly_sales::numeric, 2)  AS monthly_sales,
    ROUND(monthly_profit::numeric, 2) AS monthly_profit,
    ROUND(
        SUM(monthly_sales) OVER (ORDER BY month)::numeric
    , 2) AS cumulative_sales,
    ROUND(
        SUM(monthly_profit) OVER (ORDER BY month)::numeric
    , 2) AS cumulative_profit
FROM monthly_summary
ORDER BY month;
 
 
 -- Sales & profit trend between two dates Question: Find total sales and profit between a given start date and end date (parameterized).


-- SELECT
--     MIN(order_date) AS min_date,
--     MAX(order_date) AS max_date
-- FROM sales;



SELECT
    '2012-01-01'::date AS start_date,
    '2013-12-31'::date AS end_date,
    ROUND(SUM(sales)::numeric, 2)  AS total_sales,
    ROUND(SUM(profit)::numeric, 2) AS total_profit
FROM sales
WHERE order_date BETWEEN '2012-01-01' AND '2013-12-31';




-- Find monthly total sales and profit for each region.
-- 📌 Business use: Identify which region drives growth over time

SELECT
    DATE_TRUNC('month', order_date) AS month,
    region,
    ROUND(SUM(sales)::numeric, 2)  AS total_sales,
    ROUND(SUM(profit)::numeric, 2) AS total_profit
FROM sales
GROUP BY month, region
ORDER BY month, region;


-- Find monthly sales and profit for each product category.
-- Category seasonality detection


SELECT
    DATE_TRUNC('month', order_date):: date AS month,
    category,
    ROUND(SUM(sales)::numeric, 2)  AS total_sales,
    ROUND(SUM(profit)::numeric, 2) AS total_profit
FROM sales
GROUP BY month, category
ORDER BY month, category;



-- Identify categories that consistently generate negative profit across months.
-- 📌 Business use: Product portfolio optimization


select 
	date_trunc('month',order_date)::date as Month,
	Category,
	ROUND(SUM(profit)::numeric, 2) AS total_profit
from sales
group by month,category
having sum(profit) <0
order by month,category;



-- Find yearly sales and profit for each customer segment.
-- 📌 Business use: Customer targeting strategy


select
	date_trunc('year',order_date)::date as Year,
	segment,
	round(sum(sales)::numeric,2) as "Total sales",
	round(sum(profit)::numeric,2) as "Total profit"
from sales
group by year,segment
order by year, segment;
	


-- Analyze how average discount affects profit on a monthly basis.
-- 📌 Business use: Pricing & discount policy


SELECT
    DATE_TRUNC('month', order_date)::date AS month,
    ROUND(AVG(discount)::numeric, 2) AS avg_discount,
    ROUND(SUM(profit)::numeric, 2)   AS total_profit
FROM sales
GROUP BY month
ORDER BY month;



--High-sales but low-profit products
-- Identify products with high sales but negative profit.


-- SELECT COUNT(DISTINCT product_name) AS unique_products
-- FROM sales;


WITH product_summary AS (
    SELECT
        product_name,
        SUM(sales)  AS total_sales,
        SUM(profit) AS total_profit
    FROM sales
    GROUP BY product_name
)
SELECT
    product_name,
    ROUND(total_sales::numeric, 2)  AS total_sales,
    ROUND(total_profit::numeric, 2) AS total_profit
FROM product_summary
WHERE total_sales > (
        SELECT AVG(total_sales)
        FROM product_summary
    )
  AND total_profit < 0
ORDER BY total_sales DESC;



-- Region-wise loss contribution
-- Find which regions contribute most to overall losses.


SELECT
    region,
    ROUND(SUM(profit)::numeric, 2) AS total_loss
FROM sales
WHERE profit < 0
GROUP BY region
ORDER BY total_loss ASC;


--  Best & worst region by profit (yearly)
-- Identify the best and worst performing regions by profit for each year.
-- 📌 Business use: Regional strategy decisions


WITH yearly_region_profit AS (
    SELECT
        EXTRACT(YEAR FROM order_date) AS year,
        region,
        SUM(profit) AS total_profit
    FROM sales
    GROUP BY year, region
),
ranked_regions AS (
    SELECT
        year,
        region,
        total_profit,
        RANK() OVER (PARTITION BY year ORDER BY total_profit DESC) AS best_rank,
        RANK() OVER (PARTITION BY year ORDER BY total_profit ASC)  AS worst_rank
    FROM yearly_region_profit
)
SELECT
    year,
    region,
    ROUND(total_profit::numeric, 2) AS total_profit,
    CASE
        WHEN best_rank = 1 THEN 'Best Region'
        WHEN worst_rank = 1 THEN 'Worst Region'
    END AS performance
FROM ranked_regions
WHERE best_rank = 1 OR worst_rank = 1
ORDER BY year, performance DESC;


