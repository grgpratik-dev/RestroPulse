-- =========================================================
-- Orders RLS
--
-- Access rules:
--   - Owners can create, read, update, and delete orders
--     belonging to their own restaurant.
--   - Viewers can only read orders for their restaurant.
--   - No user can access orders from another restaurant.
--   - When creating an order, recorded_by_profile_id must
--     match the currently authenticated user.
-- =========================================================

alter table public.orders
enable row level security;


-- =========================================================
-- SELECT
-- Owners and viewers can read orders belonging
-- to their own restaurant.
-- =========================================================

create policy "Members can read own restaurant orders"
on public.orders
for select
to authenticated
using (
  restaurant_id = public.current_user_restaurant_id()
);


-- =========================================================
-- INSERT
-- Only the restaurant owner can create orders.
--
-- recorded_by_profile_id must either:
--   - match the authenticated user
--   - or be NULL if we intentionally allow that
--
-- Since normal app-created orders should always record
-- who entered them, we require auth.uid() here.
-- =========================================================

create policy "Owners can create orders"
on public.orders
for insert
to authenticated
with check (
  restaurant_id = public.current_user_restaurant_id()
  and public.is_restaurant_owner()
  and recorded_by_profile_id = auth.uid()
);


-- =========================================================
-- UPDATE
-- Only the restaurant owner can modify orders belonging
-- to their own restaurant.
--
-- recorded_by_profile_id cannot be changed to another user.
-- =========================================================

create policy "Owners can update orders"
on public.orders
for update
to authenticated
using (
  restaurant_id = public.current_user_restaurant_id()
  and public.is_restaurant_owner()
)
with check (
  restaurant_id = public.current_user_restaurant_id()
  and public.is_restaurant_owner()
  and recorded_by_profile_id = auth.uid()
);


-- =========================================================
-- DELETE
-- Only the restaurant owner can delete orders belonging
-- to their own restaurant.
-- =========================================================

create policy "Owners can delete orders"
on public.orders
for delete
to authenticated
using (
  restaurant_id = public.current_user_restaurant_id()
  and public.is_restaurant_owner()
);