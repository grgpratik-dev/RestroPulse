-- =========================================================
-- Wastage Entries RLS
--
-- Access rules:
--   - Owners can create, read, update, and delete wastage
--     entries for their own restaurant.
--   - Viewers can only read wastage entries.
--   - No user can access wastage data from another restaurant.
-- =========================================================

alter table public.wastage_entries
enable row level security;


-- =========================================================
-- SELECT
-- Owners and viewers can read wastage entries belonging
-- to their own restaurant.
-- =========================================================

create policy "Members can read own restaurant wastage entries"
on public.wastage_entries
for select
to authenticated
using (
  restaurant_id = public.current_user_restaurant_id()
);


-- =========================================================
-- INSERT
-- Only the owner can create wastage entries for
-- their own restaurant.
-- =========================================================

create policy "Owners can create wastage entries"
on public.wastage_entries
for insert
to authenticated
with check (
  restaurant_id = public.current_user_restaurant_id()
  and public.is_restaurant_owner()
);


-- =========================================================
-- UPDATE
-- Only the owner can modify wastage entries belonging
-- to their own restaurant.
-- =========================================================

create policy "Owners can update wastage entries"
on public.wastage_entries
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
-- Only the owner can delete wastage entries belonging
-- to their own restaurant.
-- =========================================================

create policy "Owners can delete wastage entries"
on public.wastage_entries
for delete
to authenticated
using (
  restaurant_id = public.current_user_restaurant_id()
  and public.is_restaurant_owner()
);