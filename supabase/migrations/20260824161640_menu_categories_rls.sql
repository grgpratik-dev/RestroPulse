-- =========================================================
-- Menu Categories RLS
--
-- Access rules:
--   - Owners can create, read, update, and delete categories
--     for their own restaurant.
--   - Viewers can only read categories for their restaurant.
--   - No user can access categories from another restaurant.
-- =========================================================


-- Enable Row Level Security.
alter table public.menu_categories
enable row level security;


-- =========================================================
-- SELECT
-- Owners and viewers can read categories belonging
-- to their own restaurant.
-- =========================================================

create policy "Members can read own restaurant menu categories"
on public.menu_categories
for select
to authenticated
using (
  restaurant_id = public.current_user_restaurant_id()
);


-- =========================================================
-- INSERT
-- Only the restaurant owner can create categories
-- for their own restaurant.
-- =========================================================

create policy "Owners can create menu categories"
on public.menu_categories
for insert
to authenticated
with check (
  restaurant_id = public.current_user_restaurant_id()
  and public.is_restaurant_owner()
);


-- =========================================================
-- UPDATE
-- Only the restaurant owner can modify categories
-- belonging to their own restaurant.
-- =========================================================

create policy "Owners can update menu categories"
on public.menu_categories
for update
to authenticated
using (
  restaurant_id = public.current_user_restaurant_id()
  and public.is_restaurant_owner()
)
with check (
  restaurant_id = public.current_user_restaurant_id()
  and public.is_restaurant_owner()
);


-- =========================================================
-- DELETE
-- Only the restaurant owner can delete categories
-- belonging to their own restaurant.
-- =========================================================

create policy "Owners can delete menu categories"
on public.menu_categories
for delete
to authenticated
using (
  restaurant_id = public.current_user_restaurant_id()
  and public.is_restaurant_owner()
);