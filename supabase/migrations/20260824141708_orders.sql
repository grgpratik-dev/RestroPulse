-- =========================================================
-- Orders
-- Stores each completed restaurant order.
--
-- An order represents one sale/transaction.
-- The individual menu items sold in the order are stored
-- separately in order_items.
-- =========================================================

create table public.orders (
  id uuid primary key default gen_random_uuid(),

  -- Restaurant this order belongs to.
  restaurant_id uuid not null
    references public.restaurants(id)
    on delete cascade,

  -- User who recorded the order.
  -- Historical orders remain even if that user's
  -- account is deleted later.
  recorded_by_profile_id uuid
    references public.profiles(id)
    on delete set null,

  -- Sales channel:
  -- dine_in, takeaway, or delivery.
  channel public.order_channel not null,

  -- Total before applying the order-level discount.
  subtotal numeric(12,2) not null,

  -- Whole-order discount.
  discount_amount numeric(12,2) not null default 0,

  -- Final amount after discount.
  total_amount numeric(12,2) not null,

  -- Optional note entered while recording the order.
  notes text,

  -- When the actual order/sale occurred.
  ordered_at timestamptz not null default now(),

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  -- Monetary values cannot be negative.
  constraint orders_subtotal_non_negative
    check (subtotal >= 0),

  constraint orders_discount_non_negative
    check (discount_amount >= 0),

  constraint orders_total_non_negative
    check (total_amount >= 0),

  -- Discount cannot exceed the subtotal.
  constraint orders_discount_not_greater_than_subtotal
    check (discount_amount <= subtotal),

  -- Final total must equal subtotal minus discount.
  constraint orders_total_matches_calculation
    check (total_amount = subtotal - discount_amount)
);


-- =========================================================
-- Automatically refresh updated_at whenever
-- an order is modified.
-- =========================================================

create trigger set_orders_updated_at
before update on public.orders
for each row
execute function public.set_updated_at();


-- =========================================================
-- Indexes
-- =========================================================

-- Important for restaurant order history.
create index orders_restaurant_id_idx
  on public.orders (restaurant_id);


-- Important for daily/monthly/yearly sales and
-- reporting queries.
create index orders_restaurant_ordered_at_idx
  on public.orders (restaurant_id, ordered_at);


-- Useful when auditing orders entered by a user.
create index orders_recorded_by_profile_id_idx
  on public.orders (recorded_by_profile_id);