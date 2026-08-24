-- =========================================================
-- Menu Items RLS
--
-- Access rules:
--   - Owners can create, read, update, and delete menu items
--     for their own restaurant.
--   - Viewers can only read menu items for their restaurant.
--   - No user can access menu items from another restaurant.
-- =========================================================

-- Enable Row Level Security.
alter table public.menu_items
enable row level security;


-- =========================================================
-- SELECT
-- Owners and viewers can read menu items belonging
-- to their own restaurant.
-- =========================================================

create policy "Members can read own restaurant menu items"
on public.menu_items
for select
to authenticated
using (
  restaurant_id = public.current_user_restaurant_id()
);


-- =========================================================
-- INSERT
-- Only the restaurant owner can create menu items
-- for their own restaurant.
-- =========================================================

create policy "Owners can create menu items"
on public.menu_items
for insert
to authenticated
with check (
  restaurant_id = public.current_user_restaurant_id()
  and public.is_restaurant_owner()
);


-- =========================================================
-- UPDATE
-- Only the restaurant owner can modify menu items
-- belonging to their own restaurant.
-- =========================================================

create policy "Owners can update menu items"
on public.menu_items
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
-- Only the restaurant owner can delete menu items
-- belonging to their own restaurant.
-- =========================================================

create policy "Owners can delete menu items"
on public.menu_items
for delete
to authenticated
using (
  restaurant_id = public.current_user_restaurant_id()
  and public.is_restaurant_owner()
);