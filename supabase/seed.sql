-- =========================================================
-- RestroPulse Local Development Seed
--
-- These users use fixed UUIDs so database resets always
-- recreate the same predictable test environment.
--
-- NOTE:
-- These are database test identities for SQL/RLS testing.
-- They are not password-login users.
-- =========================================================


-- =========================================================
-- Test Auth Users
-- =========================================================

insert into auth.users (
  id,
  email,
  raw_user_meta_data
)
values
  (
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
    'owner@test.com',
    '{"full_name":"Test Owner"}'
  ),
  (
    'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
    'viewer@test.com',
    '{"full_name":"Test Viewer"}'
  ),
  (
    'cccccccc-cccc-cccc-cccc-cccccccccccc',
    'outsider@test.com',
    '{"full_name":"Test Outsider"}'
  ),
  (
    'dddddddd-dddd-dddd-dddd-dddddddddddd',
    'owner2@test.com',
    '{"full_name":"Test Owner 2"}'
  );


-- =========================================================
-- Test Restaurants
--
-- timezone stores the restaurant's permanent IANA timezone.
-- Analytics must use this as the source of truth for
-- restaurant-local dates and business periods.
-- =========================================================

insert into public.restaurants (
  id,
  name,
  timezone
)
values
  (
    '11111111-1111-1111-1111-111111111111',
    'RLS Test Restaurant A',
    'Asia/Kathmandu'
  ),
  (
    '22222222-2222-2222-2222-222222222222',
    'RLS Test Restaurant B',
    'Asia/Kathmandu'
  );


-- =========================================================
-- Restaurant Memberships
--
-- Restaurant A:
--   Owner  -> owner@test.com
--   Viewer -> viewer@test.com
--
-- Restaurant B:
--   Owner  -> owner2@test.com
--
-- outsider@test.com intentionally has no membership.
-- =========================================================

insert into public.restaurant_memberships (
  restaurant_id,
  profile_id,
  role
)
values
  (
    '11111111-1111-1111-1111-111111111111',
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
    'owner'
  ),
  (
    '11111111-1111-1111-1111-111111111111',
    'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
    'viewer'
  ),
  (
    '22222222-2222-2222-2222-222222222222',
    'dddddddd-dddd-dddd-dddd-dddddddddddd',
    'owner'
  );


-- =========================================================
-- RESTROPULSE ANALYTICS TEST DATA
--
-- Restaurant A:
--   11111111-1111-1111-1111-111111111111
--
-- Owner A:
--   aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa
--
-- Purpose:
--   deterministic data for testing:
--   - Sales analytics
--   - Expense analytics
--   - Menu analytics
--   - Wastage analytics
--   - Dashboard
--   - Reports
--
-- Restaurant A timezone:
--   Asia/Kathmandu
--
-- Dates below are intentionally fixed.
-- =========================================================


-- =========================================================
-- MENU CATEGORIES
-- =========================================================

insert into public.menu_categories (
  id,
  restaurant_id,
  name,
  sort_order,
  is_active
)
values
(
  '31000000-0000-0000-0000-000000000001',
  '11111111-1111-1111-1111-111111111111',
  'Mains',
  1,
  true
),
(
  '31000000-0000-0000-0000-000000000002',
  '11111111-1111-1111-1111-111111111111',
  'Drinks',
  2,
  true
);


-- =========================================================
-- MENU ITEMS
--
-- Burger:
--   price = 500
--   cost  = 200
--   margin = 60%
--
-- Pizza:
--   price = 800
--   cost  = 400
--   margin = 50%
--
-- Momo:
--   price = 300
--   cost  = 120
--   margin = 60%
--
-- Cola:
--   price = 150
--   cost  = 60
--   margin = 60%
-- =========================================================

insert into public.menu_items (
  id,
  restaurant_id,
  category_id,
  name,
  description,
  selling_price,
  cost_price,
  is_available,
  is_active
)
values
(
  '32000000-0000-0000-0000-000000000001',
  '11111111-1111-1111-1111-111111111111',
  '31000000-0000-0000-0000-000000000001',
  'Burger',
  'Test burger',
  500,
  200,
  true,
  true
),
(
  '32000000-0000-0000-0000-000000000002',
  '11111111-1111-1111-1111-111111111111',
  '31000000-0000-0000-0000-000000000001',
  'Pizza',
  'Test pizza',
  800,
  400,
  true,
  true
),
(
  '32000000-0000-0000-0000-000000000003',
  '11111111-1111-1111-1111-111111111111',
  '31000000-0000-0000-0000-000000000001',
  'Momo',
  'Test momo',
  300,
  120,
  true,
  true
),
(
  '32000000-0000-0000-0000-000000000004',
  '11111111-1111-1111-1111-111111111111',
  '31000000-0000-0000-0000-000000000002',
  'Cola',
  'Test cola',
  150,
  60,
  true,
  true
);


-- =========================================================
-- ORDERS
--
-- Previous day: 2026-08-24
--
-- Order #1
-- Burger x2 = 1000
--
-- Order #2
-- Pizza x1 = 800
-- Cola x2 = 300
--
-- Previous-day revenue:
--   1000 + 1100 = 2100
--
--
-- Current day: 2026-08-25
--
-- Order #3
-- Momo x3 = 900
--
-- Order #4
-- Burger x1 = 500
-- Cola x2 = 300
--
-- Order #5
-- Pizza x2 = 1600
--
-- Current-day revenue:
--   900 + 800 + 1600 = 3300
--
-- Current-day orders:
--   3
--
-- Current-day average order:
--   3300 / 3 = 1100
-- =========================================================

insert into public.orders (
  id,
  order_number,
  restaurant_id,
  recorded_by_profile_id,
  channel,
  subtotal,
  discount_amount,
  total_amount,
  notes,
  ordered_at
)
values
(
  '33000000-0000-0000-0000-000000000001',
  1,
  '11111111-1111-1111-1111-111111111111',
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
  'dine_in',
  1000,
  0,
  1000,
  'Previous day test order 1',
  '2026-08-24 12:00:00+05:45'
),
(
  '33000000-0000-0000-0000-000000000002',
  2,
  '11111111-1111-1111-1111-111111111111',
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
  'takeaway',
  1100,
  0,
  1100,
  'Previous day test order 2',
  '2026-08-24 18:00:00+05:45'
),
(
  '33000000-0000-0000-0000-000000000003',
  3,
  '11111111-1111-1111-1111-111111111111',
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
  'dine_in',
  900,
  0,
  900,
  'Current day test order 1',
  '2026-08-25 11:30:00+05:45'
),
(
  '33000000-0000-0000-0000-000000000004',
  4,
  '11111111-1111-1111-1111-111111111111',
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
  'takeaway',
  800,
  0,
  800,
  'Current day test order 2',
  '2026-08-25 14:00:00+05:45'
),
(
  '33000000-0000-0000-0000-000000000005',
  5,
  '11111111-1111-1111-1111-111111111111',
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
  'delivery',
  1600,
  0,
  1600,
  'Current day test order 3',
  '2026-08-25 19:00:00+05:45'
);


-- =========================================================
-- ORDER ITEMS
--
-- Historical price/cost snapshots are intentionally stored.
-- =========================================================

insert into public.order_items (
  id,
  order_id,
  menu_item_id,
  item_name,
  quantity,
  unit_price,
  unit_cost,
  line_total
)
values

-- Previous day Order #1
(
  '34000000-0000-0000-0000-000000000001',
  '33000000-0000-0000-0000-000000000001',
  '32000000-0000-0000-0000-000000000001',
  'Burger',
  2,
  500,
  200,
  1000
),

-- Previous day Order #2
(
  '34000000-0000-0000-0000-000000000002',
  '33000000-0000-0000-0000-000000000002',
  '32000000-0000-0000-0000-000000000002',
  'Pizza',
  1,
  800,
  400,
  800
),
(
  '34000000-0000-0000-0000-000000000003',
  '33000000-0000-0000-0000-000000000002',
  '32000000-0000-0000-0000-000000000004',
  'Cola',
  2,
  150,
  60,
  300
),

-- Current day Order #3
(
  '34000000-0000-0000-0000-000000000004',
  '33000000-0000-0000-0000-000000000003',
  '32000000-0000-0000-0000-000000000003',
  'Momo',
  3,
  300,
  120,
  900
),

-- Current day Order #4
(
  '34000000-0000-0000-0000-000000000005',
  '33000000-0000-0000-0000-000000000004',
  '32000000-0000-0000-0000-000000000001',
  'Burger',
  1,
  500,
  200,
  500
),
(
  '34000000-0000-0000-0000-000000000006',
  '33000000-0000-0000-0000-000000000004',
  '32000000-0000-0000-0000-000000000004',
  'Cola',
  2,
  150,
  60,
  300
),

-- Current day Order #5
(
  '34000000-0000-0000-0000-000000000007',
  '33000000-0000-0000-0000-000000000005',
  '32000000-0000-0000-0000-000000000002',
  'Pizza',
  2,
  800,
  400,
  1600
);


-- =========================================================
-- EXPENSE CATEGORIES
-- =========================================================

insert into public.expense_categories (
  id,
  restaurant_id,
  name,
  expense_type,
  is_system,
  is_active
)
values
(
  '35000000-0000-0000-0000-000000000001',
  '11111111-1111-1111-1111-111111111111',
  'Rent',
  'fixed',
  false,
  true
),
(
  '35000000-0000-0000-0000-000000000002',
  '11111111-1111-1111-1111-111111111111',
  'Vegetables',
  'variable',
  false,
  true
),
(
  '35000000-0000-0000-0000-000000000003',
  '11111111-1111-1111-1111-111111111111',
  'Electricity',
  'variable',
  false,
  true
);


-- =========================================================
-- EXPENSES
--
-- Previous day:
--   Vegetables = 500
--   Electricity = 300
--   Total = 800
--
-- Current day:
--   Vegetables = 700
--   Electricity = 400
--   Total = 1100
--
-- Largest current category:
--   Vegetables = 700
-- =========================================================

insert into public.expenses (
  id,
  restaurant_id,
  category_id,
  recorded_by_profile_id,
  amount,
  expense_at,
  description,
  notes
)
values
(
  '36000000-0000-0000-0000-000000000001',
  '11111111-1111-1111-1111-111111111111',
  '35000000-0000-0000-0000-000000000002',
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
  500,
  '2026-08-24 09:00:00+05:45',
  'Vegetable purchase',
  'Previous day'
),
(
  '36000000-0000-0000-0000-000000000002',
  '11111111-1111-1111-1111-111111111111',
  '35000000-0000-0000-0000-000000000003',
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
  300,
  '2026-08-24 10:00:00+05:45',
  'Electricity expense',
  'Previous day'
),
(
  '36000000-0000-0000-0000-000000000003',
  '11111111-1111-1111-1111-111111111111',
  '35000000-0000-0000-0000-000000000002',
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
  700,
  '2026-08-25 08:30:00+05:45',
  'Vegetable purchase',
  'Current day'
),
(
  '36000000-0000-0000-0000-000000000004',
  '11111111-1111-1111-1111-111111111111',
  '35000000-0000-0000-0000-000000000003',
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
  400,
  '2026-08-25 10:30:00+05:45',
  'Electricity expense',
  'Current day'
);


-- =========================================================
-- WASTAGE
--
-- Previous day:
--   Expired = 100
--   Total = 100
--
-- Current day:
--   Overproduction = 150
--   Expired = 50
--   Total = 200
--
-- Current top reason:
--   Overproduction
-- =========================================================

insert into public.wastage_entries (
  id,
  restaurant_id,
  item_name,
  estimated_loss,
  reason,
  quantity,
  unit,
  wastage_date,
  notes
)
values
(
  '37000000-0000-0000-0000-000000000001',
  '11111111-1111-1111-1111-111111111111',
  'Tomatoes',
  100,
  'expired',
  2,
  'kg',
  '2026-08-24',
  'Previous-day wastage'
),
(
  '37000000-0000-0000-0000-000000000002',
  '11111111-1111-1111-1111-111111111111',
  'Rice',
  150,
  'overproduction',
  3,
  'kg',
  '2026-08-25',
  'Current-day wastage'
),
(
  '37000000-0000-0000-0000-000000000003',
  '11111111-1111-1111-1111-111111111111',
  'Milk',
  50,
  'expired',
  1,
  'litres',
  '2026-08-25',
  'Current-day wastage'
);

-- =========================================================
-- TIMEZONE BOUNDARY TEST ORDER
--
-- Restaurant timezone:
--   Asia/Kathmandu
--
-- Local restaurant time:
--   2026-08-26 00:30 +05:45
--
-- Equivalent UTC time:
--   2026-08-25 18:45 UTC
--
-- Purpose:
-- This order MUST belong to the restaurant business date
-- 2026-08-26, even though its UTC date is 2026-08-25.
-- =========================================================

insert into public.orders (
  id,
  order_number,
  restaurant_id,
  recorded_by_profile_id,
  channel,
  subtotal,
  discount_amount,
  total_amount,
  notes,
  ordered_at
)
values (
  '33000000-0000-0000-0000-000000000006',
  6,
  '11111111-1111-1111-1111-111111111111',
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
  'dine_in',
  500,
  0,
  500,
  'Timezone boundary test order',
  '2026-08-26 00:30:00+05:45'
);

insert into public.order_items (
  id,
  order_id,
  menu_item_id,
  item_name,
  quantity,
  unit_price,
  unit_cost,
  line_total
)
values (
  '34000000-0000-0000-0000-000000000008',
  '33000000-0000-0000-0000-000000000006',
  '32000000-0000-0000-0000-000000000001',
  'Burger',
  1,
  500,
  200,
  500
);