-- =========================================================
-- Expenses RLS
--
-- Access rules:
--   - Owners can create, read, update, and delete expenses
--     for their own restaurant.
--   - Viewers can only read expenses for their restaurant.
--   - No user can access expenses from another restaurant.
--   - recorded_by_profile_id must match the authenticated user.
--   - category_id must reference either:
--       * a global system category, or
--       * a custom category belonging to the same restaurant.
-- =========================================================

alter table public.expenses
enable row level security;


-- =========================================================
-- SELECT
-- Owners and viewers can read expenses belonging
-- to their own restaurant.
-- =========================================================

create policy "Members can read own restaurant expenses"
on public.expenses
for select
to authenticated
using (
  restaurant_id = public.current_user_restaurant_id()
);


-- =========================================================
-- INSERT
-- Only the owner can create expenses.
--
-- The selected category must be valid for the restaurant:
--   - system category
--   - or the restaurant's own custom category
-- =========================================================

create policy "Owners can create expenses"
on public.expenses
for insert
to authenticated
with check (
  public.is_restaurant_owner()

  and restaurant_id = public.current_user_restaurant_id()

  and recorded_by_profile_id = auth.uid()

  and exists (
    select 1
    from public.expense_categories ec
    where ec.id = expenses.category_id
      and (
        ec.is_system = true
        or ec.restaurant_id = expenses.restaurant_id
      )
  )
);


-- =========================================================
-- UPDATE
-- Only the owner can modify expenses belonging
-- to their own restaurant.
--
-- WITH CHECK prevents changing the restaurant, recorder,
-- or category to an invalid value during an update.
-- =========================================================

create policy "Owners can update expenses"
on public.expenses
for update
to authenticated
using (
  restaurant_id = public.current_user_restaurant_id()
  and public.is_restaurant_owner()
)
with check (
  public.is_restaurant_owner()

  and restaurant_id = public.current_user_restaurant_id()

  and recorded_by_profile_id = auth.uid()

  and exists (
    select 1
    from public.expense_categories ec
    where ec.id = expenses.category_id
      and (
        ec.is_system = true
        or ec.restaurant_id = expenses.restaurant_id
      )
  )
);


-- =========================================================
-- DELETE
-- Only the owner can delete expenses belonging
-- to their own restaurant.
-- =========================================================

create policy "Owners can delete expenses"
on public.expenses
for delete
to authenticated
using (
  restaurant_id = public.current_user_restaurant_id()
  and public.is_restaurant_owner()
);