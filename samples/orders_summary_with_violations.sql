-- Sample SQL file with intentional style guide violations
-- Used to demonstrate AI-driven convention enforcement

-- VIOLATION: lowercase keywords, trailing commas, implicit join
select
    customers.customer_id,
    customers.first_name,
    customers.last_name,
    orders.order_id,
    orders.amount,
    orders.status
from customers, orders
where customers.customer_id = orders.customer_id
and orders.status = 'completed';

-- VIOLATION: lowercase keywords, no table aliases, nested subquery
select
    customer_name,
    (select count(*) from orders o where o.customer_id = c.customer_id) as order_count,
    (select sum(amount) from orders o where o.customer_id = c.customer_id) as total_spent
from customers c
where active = true;

-- VIOLATION: mixed case keywords, poor formatting
Select customer_id, First_Name, Last_Name, Email
From Customers Where is_active = True Order By created_at Desc;

-- VIOLATION: CamelCase columns, wrong boolean naming
SELECT
    CustomerID,
    OrderDate,
    active,
    subscription_flag,
    create_date
FROM orders;

-- CORRECT: Follows all style guide rules
SELECT
    c.customer_id
    , c.first_name
    , c.last_name
    , o.order_id
    , o.order_date
    , o.amount
    , CASE
        WHEN o.status = 'completed' THEN 'done'
        WHEN o.status = 'pending' THEN 'waiting'
        ELSE 'unknown'
    END AS status_label
FROM customers AS c
LEFT JOIN orders AS o
    ON c.customer_id = o.customer_id
WHERE c.is_active = TRUE
    AND o.created_at > '2024-01-01';

-- CORRECT: CTE usage following style guide
WITH active_customers AS (
    SELECT
        customer_id
        , customer_name
        , email
    FROM customers
    WHERE is_active = TRUE
)

, recent_orders AS (
    SELECT
        customer_id
        , COUNT(*) AS orders_count
        , SUM(amount) AS revenue_amount
    FROM orders
    WHERE order_date > CURRENT_DATE - INTERVAL '30 days'
    GROUP BY customer_id
)

SELECT
    ac.customer_name
    , ac.email
    , COALESCE(ro.orders_count, 0) AS orders_count
    , COALESCE(ro.revenue_amount, 0) AS revenue_amount
FROM active_customers AS ac
LEFT JOIN recent_orders AS ro
    ON ac.customer_id = ro.customer_id
ORDER BY ro.revenue_amount DESC NULLS LAST;
