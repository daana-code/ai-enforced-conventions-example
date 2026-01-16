# Metric Naming Convention

This document defines the naming standards for all metrics in our semantic layer. These conventions ensure consistency, discoverability, and clarity across all analytics and reporting.

## General Structure

All metric names follow this pattern:

```
<entity>_<descriptor>_<unit>
```

- **entity**: The business object being measured (plural form)
- **descriptor**: What aspect is being measured
- **unit**: The type of measurement (count, amount, rate, ratio, etc.)

## Rules

### 1. Use Plural Entity Names

Metrics measure collections, so entity names should be plural.

**Correct:**
- `orders_total_count`
- `subscriptions_active_count`
- `customers_churned_count`

**Incorrect:**
- `order_total_count`
- `subscription_active_count`

### 2. No Scope Words in Names

Words like `total`, `sum`, `avg`, `min`, `max` should NOT appear in metric names. Scope and aggregation are handled by the semantic layer through filters and dimensions.

**Correct:**
- `revenue_amount`
- `orders_count`
- `session_duration_seconds`

**Incorrect:**
- `total_revenue`
- `sum_of_orders`
- `avg_session_duration`

### 3. Use Snake Case

All metric names use lowercase with underscores.

**Correct:**
- `monthly_recurring_revenue_amount`
- `customers_new_count`

**Incorrect:**
- `MonthlyRecurringRevenueAmount`
- `customersNewCount`
- `monthly-recurring-revenue-amount`

### 4. Units Should Be Explicit

Include the unit of measurement as a suffix.

| Unit Type | Suffix | Example |
|-----------|--------|---------|
| Count of items | `_count` | `orders_completed_count` |
| Monetary value | `_amount` | `revenue_amount` |
| Percentage | `_rate` or `_pct` | `conversion_rate`, `churn_pct` |
| Duration | `_seconds`, `_minutes`, `_days` | `session_duration_seconds` |
| Ratio | `_ratio` | `ltv_cac_ratio` |

### 5. Descriptors Should Be Meaningful

The descriptor should clarify what's being measured about the entity.

**Good descriptors:**
- `customers_active_count` (status-based)
- `orders_completed_count` (state-based)
- `subscriptions_churned_count` (event-based)
- `revenue_recurring_amount` (type-based)

**Vague descriptors to avoid:**
- `customers_count` (active? total? new?)
- `orders_number` (use `_count`)

### 6. Time Periods in Dimension, Not Name

Don't bake time periods into metric names. Use dimensions for time filtering.

**Correct:**
- `revenue_amount` (with `period` dimension)
- `customers_new_count` (with `date` dimension)

**Incorrect:**
- `monthly_revenue_amount`
- `daily_new_customers_count`

Exception: Metrics that are inherently time-bound like `monthly_recurring_revenue_amount` (MRR) where the time period is part of the business definition.

## Examples

### Good Metric Names

| Metric | Entity | Descriptor | Unit |
|--------|--------|------------|------|
| `orders_completed_count` | orders | completed | count |
| `revenue_gross_amount` | revenue | gross | amount |
| `subscriptions_active_count` | subscriptions | active | count |
| `customers_churned_count` | customers | churned | count |
| `sessions_duration_avg_seconds` | sessions | duration_avg | seconds |
| `conversion_signup_rate` | conversion | signup | rate |

### Bad Metric Names (And Why)

| Bad Name | Problem | Better Name |
|----------|---------|-------------|
| `total_revenue` | Scope word "total" | `revenue_amount` |
| `nbr_of_paid_subs` | Abbreviations, wrong structure | `subscriptions_paid_count` |
| `OrderCount` | Wrong case | `orders_count` |
| `avg_order_value` | Scope word "avg" | `orders_value_avg_amount` |
| `customer_count` | Singular, vague | `customers_active_count` |
| `monthly_sales` | Time baked in, no unit | `sales_amount` |

## Enforcement

This convention is enforced automatically via AI review on pull requests. The AI agent reads this document and flags violations with:

- **Critical**: Scope words in names, wrong structure
- **Medium**: Missing units, vague descriptors
- **Minor**: Singular instead of plural

When flagged, fix the metric name before merging.
