-- =========================================================
-- Restaurants RLS
--
-- Access rules:
--   - Owner can read, update, and delete their restaurant.
--   - Viewer can read their restaurant.
--   - Users cannot access another restaurant.
--   - Restaurant creation is handled separately because
--     creating the restaurant and owner membership should
--     happen together as one controlled operation.
-- =========================================================


-- Enable Row Level Security.
alter table public.restaurants
enable row level security;


-- =========================================================
-- SELECT
-- Owners and viewers can read only the restaurant
-- they currently belong to.
-- =========================================================

create policy "Members can read own restaurant"
on public.restaurants
for select
to authenticated
using (
  id = public.current_user_restaurant_id()
);


-- =========================================================
-- UPDATE
-- Only the owner can modify restaurant information.
--
-- The restaurant being updated must also be the one
-- owned by the current user.
-- =========================================================

create policy "Owners can update own restaurant"
on public.restaurants
for update
to authenticated
using (
  id = public.current_user_restaurant_id()
  and public.is_restaurant_owner()
)
with check (
  id = public.current_user_restaurant_id()
  and public.is_restaurant_owner()
);


-- =========================================================
-- DELETE
-- Only the owner can delete their own restaurant.
--
-- Later, restaurant deletion should ideally be executed
-- through a controlled backend function because it is a
-- destructive operation affecting restaurant-owned data.
-- =========================================================

create policy "Owners can delete own restaurant"
on public.restaurants
for delete
to authenticated
using (
  id = public.current_user_restaurant_id()
  and public.is_restaurant_owner()
);