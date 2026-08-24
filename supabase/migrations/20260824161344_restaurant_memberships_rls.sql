-- =========================================================
-- Restaurant Memberships RLS
--
-- Access rules:
--   - Owner and viewers can read memberships belonging
--     to their own restaurant.
--   - Only the owner can remove viewers.
--   - Viewers cannot modify memberships.
--   - Membership creation, role changes, and ownership
--     transfer are handled through controlled functions.
-- =========================================================


-- Enable Row Level Security.
alter table public.restaurant_memberships
enable row level security;


-- =========================================================
-- SELECT
-- Members can see membership records belonging only
-- to their own restaurant.
--
-- This allows:
--   - owner to see all viewers
--   - viewers to see restaurant membership information
-- =========================================================

create policy "Members can read own restaurant memberships"
on public.restaurant_memberships
for select
to authenticated
using (
  restaurant_id = public.current_user_restaurant_id()
);


-- =========================================================
-- DELETE
-- Only the owner can remove viewer memberships from
-- their own restaurant.
--
-- role = 'viewer' is important:
-- it prevents the owner's membership from being deleted
-- through a normal client DELETE operation.
-- =========================================================

create policy "Owners can remove viewers"
on public.restaurant_memberships
for delete
to authenticated
using (
  restaurant_id = public.current_user_restaurant_id()
  and public.is_restaurant_owner()
  and role = 'viewer'
);