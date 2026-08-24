-- =========================================================
-- Expense Categories RLS
--
-- Expense categories can be:
--   1. Global RestroPulse system categories
--      where restaurant_id IS NULL and is_system = true
--
--   2. Restaurant-specific custom categories
--      where restaurant_id belongs to a restaurant
--
-- Access rules:
--   - Owners and viewers can read all system categories.
--   - Owners and viewers can read custom categories for
--     their own restaurant.
--   - Only owners can create/update/delete custom categories
--     for their own restaurant.
--   - System categories cannot be modified by normal users.
-- =========================================================

alter table public.expense_categories
enable row level security;


-- =========================================================
-- SELECT
-- Members can read:
--   - all global system categories
--   - custom categories belonging to their restaurant
-- =========================================================

create policy "Members can read available expense categories"
on public.expense_categories
for select
to authenticated
using (
  is_system = true
  or restaurant_id = public.current_user_restaurant_id()
);


-- =========================================================
-- INSERT
-- Only owners can create restaurant-specific custom
-- categories for their own restaurant.
--
-- Normal users cannot create global system categories.
-- =========================================================

create policy "Owners can create custom expense categories"
on public.expense_categories
for insert
to authenticated
with check (
  public.is_restaurant_owner()
  and restaurant_id = public.current_user_restaurant_id()
  and is_system = false
);


-- =========================================================
-- UPDATE
-- Only owners can modify custom categories belonging
-- to their own restaurant.
--
-- System categories remain protected.
-- =========================================================

create policy "Owners can update custom expense categories"
on public.expense_categories
for update
to authenticated
using (
  public.is_restaurant_owner()
  and restaurant_id = public.current_user_restaurant_id()
  and is_system = false
)
with check (
  public.is_restaurant_owner()
  and restaurant_id = public.current_user_restaurant_id()
  and is_system = false
);


-- =========================================================
-- DELETE
-- Only owners can delete custom categories belonging
-- to their own restaurant.
--
-- Global RestroPulse system categories cannot be deleted
-- through the client.
-- =========================================================

create policy "Owners can delete custom expense categories"
on public.expense_categories
for delete
to authenticated
using (
  public.is_restaurant_owner()
  and restaurant_id = public.current_user_restaurant_id()
  and is_system = false
);