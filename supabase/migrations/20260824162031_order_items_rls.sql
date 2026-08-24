-- =========================================================
-- Order Items RLS
--
-- Access is derived through the parent order because
-- order_items does not store restaurant_id directly.
--
-- Access rules:
--   - Owners can create, read, update, and delete order items
--     for orders belonging to their own restaurant.
--   - Viewers can only read order items for their restaurant.
--   - No user can access items from another restaurant.
-- =========================================================

alter table public.order_items
enable row level security;


-- =========================================================
-- SELECT
-- Owners and viewers can read order items when the parent
-- order belongs to their restaurant.
-- =========================================================

create policy "Members can read own restaurant order items"
on public.order_items
for select
to authenticated
using (
  exists (
    select 1
    from public.orders o
    where o.id = order_items.order_id
      and o.restaurant_id = public.current_user_restaurant_id()
  )
);


-- =========================================================
-- INSERT
-- Only the owner can add items to an order belonging
-- to their own restaurant.
-- =========================================================

create policy "Owners can create order items"
on public.order_items
for insert
to authenticated
with check (
  public.is_restaurant_owner()
  and exists (
    select 1
    from public.orders o
    where o.id = order_items.order_id
      and o.restaurant_id = public.current_user_restaurant_id()
  )
);


-- =========================================================
-- UPDATE
-- Only the owner can modify items belonging to an order
-- in their own restaurant.
--
-- WITH CHECK also prevents changing order_id so the row
-- suddenly points to an order outside the user's restaurant.
-- =========================================================

create policy "Owners can update order items"
on public.order_items
for update
to authenticated
using (
  public.is_restaurant_owner()
  and exists (
    select 1
    from public.orders o
    where o.id = order_items.order_id
      and o.restaurant_id = public.current_user_restaurant_id()
  )
)
with check (
  public.is_restaurant_owner()
  and exists (
    select 1
    from public.orders o
    where o.id = order_items.order_id
      and o.restaurant_id = public.current_user_restaurant_id()
  )
);


-- =========================================================
-- DELETE
-- Only the owner can delete items belonging to an order
-- in their own restaurant.
-- =========================================================

create policy "Owners can delete order items"
on public.order_items
for delete
to authenticated
using (
  public.is_restaurant_owner()
  and exists (
    select 1
    from public.orders o
    where o.id = order_items.order_id
      and o.restaurant_id = public.current_user_restaurant_id()
  )
);