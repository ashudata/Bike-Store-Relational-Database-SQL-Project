use bike_store;

-- Questions:

-- 1. Which brand has the highest total sales, and what is the value of those sales?
select brands.brand_name, sum(order_items.quantity * (order_items.list_price - order_items.discount)) AS total_sales
from order_items
join products on order_items.product_id = products.product_id
join brands on products.brand_id = brands.brand_id
group by brands.brand_name
order by total_sales desc
limit 1;

-- 2. Which customer has placed the highest number of orders, and what is the total value of their orders?
select customers.first_name, customers.last_name, COUNT(orders.order_id) 
as total_orders, SUM(order_items.quantity * (order_items.list_price - order_items.discount)) as total_value
from customers
join orders on customers.customer_id = orders.customer_id
join order_items on orders.order_id = order_items.order_id
group by  customers.customer_id, customers.first_name, customers.last_name
order by total_orders desc
limit 1;

-- 3. Which product has the highest sales volume in terms of quantity sold?
select products.product_name, sum(order_items.quantity) as total_quantity
from order_items
join products on order_items.product_id = products.product_id
group by products.product_name
order by total_quantity desc
limit 1; 

-- 4. Which store has generated the highest revenue from orders, and what is the total revenue?
select stores.store_name, sum(order_items.quantity * (order_items.list_price - order_items.discount)) as total_revenue
from order_items
join orders on order_items.order_id = orders.order_id
join stores on orders.store_id = stores.store_id
group by stores.store_name
order by total_revenue desc
limit 1;

-- 5. What is the average discount given per order, and which product category has the highest average discount?
select categories.category_name, avg(order_items.discount) as avg_discount
from order_items
join products on order_items.product_id = products.product_id
join categories on products.category_id = categories.category_id
group by categories.category_name
order by avg_discount desc
limit 1;
 
-- 6. What percentage of orders were shipped on or before the required date?
select round((count(case when orders.shipped_date <= orders.required_date then 1 end) * 100.0 / count(orders.order_id)), 2) 
as on_time_percentage
from orders;

-- 7. Which staff member has managed the highest number of orders, and what is the total value of these orders?
select staffs.first_name, staffs.last_name, count(orders.order_id) 
as total_orders, sum(order_items.quantity * (order_items.list_price - order_items.discount)) as total_value
from staffs
join orders on staffs.staff_id = orders.staff_id
join order_items on orders.order_id = order_items.order_id
group by staffs.staff_id, staffs.first_name, staffs.last_name
order by total_orders desc
limit 1;

-- 8. Which state has the highest number of customers, and what is the total revenue generated from that state?
select customers.state, count(customers.customer_id) 
as total_customers, sum(order_items.quantity * (order_items.list_price - order_items.discount)) as total_revenue
from customers
join orders on customers.customer_id = orders.customer_id
join order_items on orders.order_id = order_items.order_id
group by customers.state
order by total_revenue desc
limit 1;

-- 9. What is the average order frequency (number of orders per customer)?
select round(avg(order_count), 2) as avg_order_frequency
from (
select customers.customer_id, count(orders.order_id) as order_count
from customers
join orders on customers.customer_id = orders.customer_id
group by customers.customer_id
) as customer_orders;

-- 10. Which category has the highest number of unique products sold, and what is the total quantity sold for that category?
select categories.category_name, count(distinct products.product_id) 
as unique_products_sold, sum(order_items.quantity) as total_quantity_sold
from order_items
join products on order_items.product_id = products.product_id
join categories on products.category_id = categories.category_id
group by categories.category_name
order by total_quantity_sold desc
limit 1;

-- 11. Which product has the lowest stock quantity across all stores, and what is the current stock level?
select products.product_name, sum(stocks.quantity) as total_stock
from stocks
join products on stocks.product_id = products.product_id
group by products.product_name
order by total_stock asc
limit 1;

-- 12. What is the distribution of total revenue across different product categories?
select categories.category_name, sum(order_items.quantity * (order_items.list_price - order_items.discount)) as total_revenue
from order_items
join products on order_items.product_id = products.product_id
join categories on products.category_id = categories.category_id
group by categories.category_name
order by total_revenue desc;

-- 13. What is the most common city among customers, and what is the total revenue generated from customers in that city?
select customers.city, count(customers.customer_id) 
as total_customers, sum(order_items.quantity * (order_items.list_price - order_items.discount)) as total_revenue
from customers
join orders on customers.customer_id = orders.customer_id
join order_items on orders.order_id = order_items.order_id
group by customers.city
order by total_revenue desc
limit 1;

-- 14. What is the average order value, and how does it vary across different stores?
select stores.store_name, avg(order_items.quantity * (order_items.list_price - order_items.discount)) as avg_order_value
from orders
join order_items on orders.order_id = order_items.order_id
join stores on orders.store_id = stores.store_id
group by stores.store_name
order by avg_order_value desc;

-- 15. How does the sales performance of products vary by model year?
select products.model_year, sum(order_items.quantity * (order_items.list_price - order_items.discount)) as total_revenue
from order_items
join products on order_items.product_id = products.product_id
group by products.model_year
order by products.model_year;

-- 16. Which order had the highest number of items, and what is the total value of that order?
select orders.order_id, count(order_items.item_id) 
as total_items, sum(order_items.quantity * (order_items.list_price - order_items.discount)) as total_value
from orders
join order_items on orders.order_id = order_items.order_id
group by orders.order_id
order by total_items desc
limit 1;

-- 17. What is the market share of each brand in terms of total sales value?
select brands.brand_name, sum(order_items.quantity * (order_items.list_price - order_items.discount)) as total_sales, 
round(sum(order_items.quantity * (order_items.list_price - order_items.discount)) * 100.0 / 
(select sum(order_items.quantity * (order_items.list_price - order_items.discount)) from order_items), 2) as market_share
from order_items
join products on order_items.product_id = products.product_id
join brands on products.brand_id = brands.brand_id
group by brands.brand_name
order by total_sales desc;

-- 18. List the top 10 best-selling products by quantity sold.
select products.product_name, sum(order_items.quantity) as total_quantity
from order_items
join products on order_items.product_id = products.product_id
group by products.product_name
order by total_quantity desc
limit 10;

-- 19. What percentage of total sales does each store contribute?
select stores.store_name, 
sum(order_items.quantity * (order_items.list_price - order_items.discount)) as store_sales, 
round(sum(order_items.quantity * (order_items.list_price - order_items.discount)) * 100.0 / 
(select sum(order_items.quantity * (order_items.list_price - order_items.discount)) from order_items), 2) as sales_contribution
from order_items
join orders on order_items.order_id = orders.order_id
join stores on orders.store_id = stores.store_id
group by stores.store_name
order by store_sales desc;

-- 20. What is the average number of orders handled by each staff member?
select staffs.staff_id, staffs.first_name, staffs.last_name, count(orders.order_id) as total_orders_handled
from staffs
join orders on staffs.staff_id = orders.staff_id
group by staffs.staff_id, staffs.first_name, staffs.last_name
order by total_orders_handled desc;

-- 21. How do discounts impact the total sales value and order quantity?
select
case 
when order_items.discount > 0 then 'Discounted'
else 'Non-Discounted'
end as discount_status,
sum(order_items.quantity * (order_items.list_price - order_items.discount)) as total_sales,
count(order_items.order_id) as total_orders
from order_items
group by discount_status;

-- 22. What is the total revenue generated from each product category, and how does it compare with the overall revenue?
select categories.category_name, sum(order_items.quantity * (order_items.list_price - order_items.discount)) as category_revenue,
(sum(order_items.quantity * (order_items.list_price - order_items.discount)) * 100.0 / 
(select sum(order_items.quantity * (order_items.list_price - order_items.discount)) from order_items)) as revenue_percentage
from order_items
join products on order_items.product_id = products.product_id
join categories on products.category_id = categories.category_id
group by categories.category_name
order by category_revenue desc;


