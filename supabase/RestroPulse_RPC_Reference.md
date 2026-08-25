# RestroPulse RPC Reference

> Purpose: Keep a simple reference of which PostgreSQL functions should remain as Supabase RPCs, where they belong, and why they are RPCs instead of normal Flutter/Supabase queries.

---

## RPC Rule

Use a **standard Supabase query from Flutter** when the operation is a simple:

- row/list read
- filtered read
- paginated history read
- detail read by ID
- simple count
- normal CRUD operation that RLS can safely protect

Use an **RPC** when the operation requires one or more of:

- multiple-table aggregation
- analytics/calculations
- historical snapshot calculations
- multiple writes that must succeed atomically
- ownership/membership invariants
- sequential number generation
- security-sensitive workflows
- controlled state transitions
- side effects such as notifications

---

# 1. Business RPCs

These RPCs perform controlled business operations and should remain RPCs.

## `restaurant_functions.sql`

### `create_restaurant()`
Creates a restaurant and assigns the authenticated user as its owner in one controlled operation.

**Why RPC?**
- creates multiple related records
- must preserve the one-owner rule
- should succeed or fail atomically

### `transfer_restaurant_ownership()`
Transfers restaurant ownership to another existing member.

**Why RPC?**
- changes multiple membership roles
- must never leave the restaurant without an owner
- ownership rules should not be bypassed from the client

### `remove_restaurant_viewer()`
Removes a viewer from the restaurant.

**Why RPC?**
- controlled membership operation
- can create a notification
- prevents unsafe direct membership manipulation

### `delete_owned_restaurant()`
Deletes the restaurant owned by the authenticated owner.

**Why RPC?**
- destructive and security-sensitive
- must verify ownership
- cascades through restaurant-owned data

---

## `restaurant_join_code_functions.sql`

### `generate_restaurant_join_code()`
Creates or regenerates the restaurant's join code.

**Why RPC?**
- owner-only operation
- generates a unique code
- handles collision/retry logic
- replaces the previous code safely

### `disable_restaurant_join_code()`
Disables the restaurant's current join code.

**Why RPC?**
- controlled owner-only access operation
- prevents arbitrary client updates to join-code state

### `resolve_restaurant_join_code()`
Accepts a join code and returns only the limited restaurant preview required by the join flow.

**Why RPC?**
- user does not yet belong to the restaurant
- must expose only safe fields
- avoids granting broad table visibility

### `request_restaurant_join_by_code()`
Creates a pending restaurant join request from a valid join code.

**Why RPC?**
- validates the code
- verifies the user has no existing restaurant
- prevents duplicate pending requests
- creates notification side effects

### `approve_join_request()`
Approves a pending request and creates viewer membership.

**Why RPC?**
- controlled state transition
- membership creation + request update + notification
- must be atomic

### `decline_join_request()`
Declines a pending join request.

**Why RPC?**
- controlled state transition
- owner-only validation
- may create notification side effects

---

## `order_functions.sql`

### `create_order()`
Creates an order and its order items.

**Why RPC?**
- creates order + order items together
- stores historical price/cost snapshots
- generates restaurant-scoped sequential `order_number`
- should be atomic

### `create_orders_batch()`
Creates multiple orders through the controlled order creation flow.

**Why RPC?**
- batch operation
- reuses sequential numbering and validation
- avoids partial client-side writes

---

## `notification_functions.sql`

### `mark_notification_read()`
Marks one notification belonging to the authenticated user as read.

**Why RPC?**
- notifications do not expose general UPDATE access
- allows only the specific safe state change required by the app

---

# 2. Analytics RPCs

Analytics should stay inside PostgreSQL because the database can aggregate the data efficiently and return one compact response.

> Recommended migration: `analytics_functions.sql`

---

## Sales

### `get_sales_summary()`
Returns period sales totals, order count, average order value, previous-period sales, and percentage change.

**Why RPC?**
- aggregation
- previous-period comparison
- reusable for Today and Sales History

### `get_sales_by_channel()`
Returns revenue/order totals and percentage share for dine-in, takeaway, and delivery.

**Why RPC?**
- grouped aggregation
- percentage calculation

### `get_sales_trend()`
Returns time-bucketed sales data for the Sales History trend chart.

**Why RPC?**
- date grouping
- aggregation over potentially large order history

---

## Expenses

### `get_expense_summary()`
Returns total expenses, transaction count, previous-period comparison, and largest expense category.

**Why RPC?**
- aggregation
- comparison
- category ranking

### `get_expenses_by_category()`
Returns expense totals, counts, and percentage share grouped by category.

**Why RPC?**
- grouped aggregation
- percentage calculation

---

## Menu Performance

### `get_menu_performance_summary()`
Returns:
- best seller by units sold
- most profitable item by margin percentage

**Why RPC?**
- joins orders/order items/menu items
- historical sales aggregation
- profitability calculation

### `get_menu_items_performance()`
Returns the selected-period performance for each menu item.

Examples:
- units sold
- revenue
- current food-cost percentage
- status

**Why RPC?**
- multi-table analytics
- historical sales aggregation
- per-item calculations

### `get_menu_item_performance_detail()`
Returns detailed analytics for one menu item.

Examples:
- pricing
- food cost
- contribution
- period revenue
- units sold
- estimated total cost
- total contribution
- previous-period comparison

**Why RPC?**
- multiple calculations
- historical order-item cost snapshots
- previous-period comparison

---

## Wastage

### `get_wastage_summary()`
Returns selected-period:
- estimated loss
- entry count
- top reason
- previous-period comparison when required

**Why RPC?**
- aggregation
- top-reason ranking
- period comparison

### `get_wastage_by_reason()`
Returns wastage totals and percentage share grouped by reason.

**Why RPC?**
- grouped aggregation
- percentage calculation

---

## Dashboard

### `get_dashboard_snapshot()`
Returns the complete Dashboard analytical snapshot.

Examples:
- Restaurant Pulse
- revenue
- orders
- average order
- estimated profit
- food cost %
- previous-period comparisons
- highest-priority alert code/value

**Why RPC?**
- combines orders, order items, expenses, and wastage
- multiple analytical calculations
- Pulse calculation
- avoids many client network requests

> Keep human-readable UI text in Flutter where possible. The RPC should preferably return codes/values rather than final display sentences.

---

## Reports

### `get_report_overview()`
Returns the main report metrics and previous-period comparisons.

Examples:
- revenue
- expenses
- estimated profit
- profit margin
- orders
- average order
- food cost
- wastage

**Why RPC?**
- combines multiple tables
- financial calculations
- period comparisons

### `get_report_revenue_expense_trend()`
Returns grouped Revenue vs Expenses data for the Reports chart.

**Why RPC?**
- time bucketing
- aggregation across separate tables

### `get_report_drivers()`
Returns report-specific drivers that require aggregation.

Recommended unique outputs:
- leading sales channel
- leading channel revenue/share
- top revenue menu item
- top menu item revenue

**Why RPC?**
- grouped/ranked analytics across order history

---

# 3. Reads That Should NOT Be RPCs

Use normal Supabase queries from Flutter with RLS for these.

## Profiles / Restaurant

- current personal profile
- current restaurant information
- current role/membership
- restaurant member list

## Restaurant Join / Members & Access

- current restaurant join-code row for the owner
- pending join-request list for the owner

> Join **actions** remain RPCs. Simple join-related **reads** use standard queries + RLS.

## Sales

- recent orders
- order history
- order detail + order items

## Expenses

- recent expenses
- expense history
- expense detail

## Wastage

- recent wastage
- wastage history
- wastage detail

## Notifications

- notification list
- unread-only filter
- unread count

## Categories

- menu categories
- expense categories

---

# 4. Files That Can Be Removed After Consolidation

Once the kept analytics functions are moved into `analytics_functions.sql`, these dedicated read migrations can be removed:

```text
sales_read_functions.sql
expense_read_functions.sql
menu_read_functions.sql
wastage_read_functions.sql
dashboard_read_functions.sql
report_read_functions.sql
profile_read_functions.sql
restaurant_join_read_functions.sql
notification_read_functions.sql
```

Do this only after:

1. the kept RPCs are copied into `analytics_functions.sql`
2. duplicate/unnecessary RPCs are removed
3. `api_grants.sql` is updated
4. `supabase db reset` passes

---

# 5. Recommended Final RPC Migration Structure

```text
supabase/migrations/
│
├── ... database schema migrations
├── ... RLS migrations
│
├── restaurant_functions.sql
│   ├── create_restaurant()
│   ├── transfer_restaurant_ownership()
│   ├── remove_restaurant_viewer()
│   └── delete_owned_restaurant()
│
├── restaurant_join_code_functions.sql
│   ├── generate_restaurant_join_code()
│   ├── disable_restaurant_join_code()
│   ├── resolve_restaurant_join_code()
│   ├── request_restaurant_join_by_code()
│   ├── approve_join_request()
│   └── decline_join_request()
│
├── order_functions.sql
│   ├── create_order()
│   └── create_orders_batch()
│
├── notification_functions.sql
│   └── mark_notification_read()
│
├── analytics_functions.sql
│   │
│   ├── Sales
│   │   ├── get_sales_summary()
│   │   ├── get_sales_by_channel()
│   │   └── get_sales_trend()
│   │
│   ├── Expenses
│   │   ├── get_expense_summary()
│   │   └── get_expenses_by_category()
│   │
│   ├── Menu
│   │   ├── get_menu_performance_summary()
│   │   ├── get_menu_items_performance()
│   │   └── get_menu_item_performance_detail()
│   │
│   ├── Wastage
│   │   ├── get_wastage_summary()
│   │   └── get_wastage_by_reason()
│   │
│   ├── Dashboard
│   │   └── get_dashboard_snapshot()
│   │
│   └── Reports
│       ├── get_report_overview()
│       ├── get_report_revenue_expense_trend()
│       └── get_report_drivers()
│
└── api_grants.sql
```

---

# 6. Final RPC Count

## Business RPCs

```text
Restaurant
├── create_restaurant()
├── transfer_restaurant_ownership()
├── remove_restaurant_viewer()
└── delete_owned_restaurant()

Restaurant Join
├── generate_restaurant_join_code()
├── disable_restaurant_join_code()
├── resolve_restaurant_join_code()
├── request_restaurant_join_by_code()
├── approve_join_request()
└── decline_join_request()

Orders
├── create_order()
└── create_orders_batch()

Notifications
└── mark_notification_read()
```

**13 business RPCs**

## Analytics RPCs

```text
Sales
├── get_sales_summary()
├── get_sales_by_channel()
└── get_sales_trend()

Expenses
├── get_expense_summary()
└── get_expenses_by_category()

Menu
├── get_menu_performance_summary()
├── get_menu_items_performance()
└── get_menu_item_performance_detail()

Wastage
├── get_wastage_summary()
└── get_wastage_by_reason()

Dashboard
└── get_dashboard_snapshot()

Reports
├── get_report_overview()
├── get_report_revenue_expense_trend()
└── get_report_drivers()
```

**14 analytics RPCs**

### Current intended total: **27 RPCs**

This file should be updated whenever an RPC is added, removed, renamed, or its responsibility changes.
