# SQL Style Guide

This document defines SQL coding standards for our data platform. Following these conventions ensures readable, maintainable, and consistent SQL across all models.

## Keywords and Syntax

### 1. SQL Keywords in UPPERCASE

All SQL keywords must be written in uppercase.

**Correct:**
```sql
SELECT
    customer_id,
    order_date,
    SUM(amount) AS total_amount
FROM orders
WHERE status = 'completed'
GROUP BY customer_id, order_date
```

**Incorrect:**
```sql
select
    customer_id,
    order_date,
    sum(amount) as total_amount
from orders
where status = 'completed'
group by customer_id, order_date
```

### 2. Column and Table Names in lowercase

All identifiers (columns, tables, aliases, CTEs) use lowercase with underscores.

**Correct:**
```sql
SELECT
    c.customer_id,
    c.first_name,
    o.order_total
FROM customers AS c
LEFT JOIN orders AS o ON c.customer_id = o.customer_id
```

**Incorrect:**
```sql
SELECT
    C.CustomerID,
    C.FirstName,
    O.OrderTotal
FROM Customers AS C
LEFT JOIN Orders AS O ON C.CustomerID = O.CustomerID
```

## Formatting

### 3. Leading Commas

Place commas at the beginning of lines in SELECT lists. This makes it easier to spot missing commas and comment out columns.

**Correct:**
```sql
SELECT
    customer_id
    , first_name
    , last_name
    , email
    , created_at
FROM customers
```

**Incorrect:**
```sql
SELECT
    customer_id,
    first_name,
    last_name,
    email,
    created_at
FROM customers
```

### 4. One Column Per Line

Each column in a SELECT statement gets its own line.

**Correct:**
```sql
SELECT
    order_id
    , customer_id
    , order_date
    , status
FROM orders
```

**Incorrect:**
```sql
SELECT order_id, customer_id, order_date, status
FROM orders
```

Exception: `SELECT *` is acceptable on a single line for quick exploration (never in production models).

### 5. Indentation

Use 4 spaces for indentation. Never use tabs.

- SELECT columns are indented once
- JOIN conditions are indented once from the JOIN
- CASE statements have WHEN/ELSE indented

**Correct:**
```sql
SELECT
    o.order_id
    , o.customer_id
    , CASE
        WHEN o.status = 'completed' THEN 'done'
        WHEN o.status = 'pending' THEN 'waiting'
        ELSE 'unknown'
    END AS status_label
FROM orders AS o
LEFT JOIN customers AS c
    ON o.customer_id = c.customer_id
WHERE o.created_at > '2024-01-01'
```

### 6. Explicit JOINs

Always use explicit JOIN syntax. Never use comma-separated implicit joins.

**Correct:**
```sql
SELECT
    c.customer_name
    , o.order_total
FROM customers AS c
INNER JOIN orders AS o
    ON c.customer_id = o.customer_id
```

**Incorrect:**
```sql
SELECT
    c.customer_name
    , o.order_total
FROM customers c, orders o
WHERE c.customer_id = o.customer_id
```

### 7. Always Alias Tables

Use short, meaningful aliases for all tables. Use `AS` keyword explicitly.

**Correct:**
```sql
SELECT
    c.customer_id
    , o.order_id
FROM customers AS c
LEFT JOIN orders AS o
    ON c.customer_id = o.customer_id
```

**Incorrect:**
```sql
SELECT
    customers.customer_id
    , orders.order_id
FROM customers
LEFT JOIN orders
    ON customers.customer_id = orders.customer_id
```

## Naming Conventions

### 8. Boolean Columns

Boolean columns should be prefixed with `is_` or `has_`.

**Correct:**
- `is_active`
- `has_subscription`
- `is_deleted`

**Incorrect:**
- `active`
- `subscription_flag`
- `deleted`

### 9. Timestamp Columns

Timestamp columns should be suffixed with `_at`.

**Correct:**
- `created_at`
- `updated_at`
- `deleted_at`
- `completed_at`

**Incorrect:**
- `create_date`
- `updated_timestamp`
- `deletion_time`

### 10. Date Columns

Date columns (without time) should be suffixed with `_date`.

**Correct:**
- `order_date`
- `birth_date`
- `start_date`

**Incorrect:**
- `order_dt`
- `birthdate`
- `start`

## CTEs and Subqueries

### 11. Prefer CTEs Over Subqueries

Use Common Table Expressions (CTEs) for readability. Name them descriptively.

**Correct:**
```sql
WITH active_customers AS (
    SELECT
        customer_id
        , customer_name
    FROM customers
    WHERE is_active = TRUE
)

, recent_orders AS (
    SELECT
        customer_id
        , COUNT(*) AS order_count
    FROM orders
    WHERE order_date > CURRENT_DATE - INTERVAL '30 days'
    GROUP BY customer_id
)

SELECT
    ac.customer_name
    , ro.order_count
FROM active_customers AS ac
LEFT JOIN recent_orders AS ro
    ON ac.customer_id = ro.customer_id
```

**Incorrect:**
```sql
SELECT
    c.customer_name
    , (
        SELECT COUNT(*)
        FROM orders o
        WHERE o.customer_id = c.customer_id
        AND o.order_date > CURRENT_DATE - INTERVAL '30 days'
    ) AS order_count
FROM customers c
WHERE c.is_active = TRUE
```

### 12. CTE Naming

CTE names should describe what the data represents, not how it was derived.

**Correct:**
- `active_customers`
- `monthly_revenue`
- `churned_subscriptions`

**Incorrect:**
- `filtered_customers`
- `joined_data`
- `temp_table`

## Enforcement

This style guide is enforced automatically via AI review on pull requests. The AI agent reads this document and flags violations with:

- **Critical**: Implicit joins, unaliased tables
- **Medium**: Lowercase keywords, trailing commas
- **Minor**: Naming convention deviations

When flagged, fix the SQL before merging.
