-- 1. What is our total revenue, profit, and overall profit margin?
select round(sum(order_items.revenue))
from order_items;

-- Total revenue 239,409,976 (239.4M)

select round(sum(order_items.profit))
from order_items;

-- Total profit 79,368,273

select round(
               sum(order_items.profit) * 100 / sum(order_items.revenue)
       )
from order_items;

-- Total profit margin 33%


-- 2. What percentage of orders were successfully completed?
select count(*) filter (where order_status = 'Completed') * 100.0 /
       count(*)
from orders;

-- Completed rate 89.9%


-- 3. What is the average order value (AOV)?
select sum(order_items.revenue) /
       count(distinct order_items.order_id)
from order_items;

-- Average Order Value (AOV): 1,995 SAR


-- 4. Which product categories generate the highest profit?
select categories.category_name,
       round(sum(order_items.profit)) as total_profi
from order_items
join products
on order_items.product_id = products.product_id
join categories
on products.category_id = categories.category_id
group by categories.category_name
order by total_profi desc;

-- Sports & Outdoors generated the highest profit (~12M SAR).
-- Toys & Games generated the lowest profit (~5M SAR).


-- 5. Which products generate the highest profit?
select order_items.product_id,
       products.product_name,
       round(sum(order_items.profit)) as total_profi
from order_items
join products
on order_items.product_id = products.product_id
group by product_name, order_items.product_id
order by total_profi desc
limit 10;

-- Top 10 profitable products.


-- 6. Which products generate the lowest profit?
select order_items.product_id,
       products.product_name,
       round(sum(order_items.profit)) as total_profi
from order_items
join products
on order_items.product_id = products.product_id
group by product_name, order_items.product_id
order by total_profi
limit 10;

-- Least 10 profitable products.


-- 7. What is the profit margin for each category?
select categories.category_name,
       round(sum(order_items.revenue)) as total_revenue,
       round(sum(order_items.profit) * 100 / sum(order_items.revenue), 1) as profit_margin
from order_items
join products
on order_items.product_id = products.product_id
join categories
on products.category_id = categories.category_id
group by categories.category_name
order by total_revenue desc;

-- Beauty & Personal Care and Books & Stationery had the highest margin (34.7%).
-- Toys & Games had the lowest margin (31.1%).


-- 8. Which stores generate the highest revenue?
select stores.store_name,
       round(sum(order_items.revenue)) as total_revenue
from order_items
join orders
on order_items.order_id = orders.order_id
join stores
on orders.store_id = stores.store_id
group by store_name
order by total_revenue desc;

-- Khobar Branch had the highest revenue (~12.3M SAR).
-- Riyadh Airport had the lowest revenue (~11.6M SAR).


-- 9. Which stores generate the highest profit?
select stores.store_name,
       round(sum(order_items.profit)) as total_profit
from order_items
join orders
on order_items.order_id = orders.order_id
join stores
on orders.store_id = stores.store_id
group by store_name
order by total_profit desc;

-- Khobar Branch had the highest profit (4.05M SAR).
-- Riyadh Airport had the lowest profit (3.8M SAR).


-- 10. Do discounts increase sales volume or only reduce profitability?
select order_items.discount,
       sum(order_items.quantity) as orders,
       round(sum(order_items.profit)) as profit
from order_items
group by discount
order by orders desc;

-- Higher discounts did not increase sales volume and reduced profitability.
-- Recommendation: Review the discount strategy and use targeted discounts instead of broad discounts.


-- 11. How do sales trend month over month, and when is the peak sales season?
SELECT
    orders.order_year,
    orders.order_month,
    TO_CHAR(ROUND(SUM(order_items.revenue)), 'FM999,999,999,999') AS total_sales
FROM order_items
JOIN orders
ON order_items.order_id = orders.order_id
GROUP BY
    orders.order_year,
    orders.order_month,
    EXTRACT(MONTH FROM order_date)
ORDER BY
    orders.order_year,
    EXTRACT(MONTH FROM order_date);

-- Sales increased over time, reaching the highest level in July 2025 (11M SAR).
-- January 2023 recorded the lowest sales (145K SAR).
-- Sales were strongest from July to December, indicating a peak sales season.
-- Recommendation: Increase inventory and staffing before the July–December peak season to meet customer demand.