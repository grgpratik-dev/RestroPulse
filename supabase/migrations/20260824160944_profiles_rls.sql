-- =========================================================
-- Profiles RLS
-- Users can manage only their own personal profile.
--
-- Restaurant roles/memberships are controlled separately
-- through restaurant_memberships.
-- =========================================================


-- Enable Row Level Security on profiles.
alter table public.profiles
enable row level security;


-- =========================================================
-- SELECT
-- A user can read:
--   - their own profile
--   - profiles of users who belong to the same restaurant
--
-- This allows owners/viewers to see basic member information
-- such as name and avatar within their restaurant.
-- =========================================================

create policy "Users can read same restaurant profiles"
on public.profiles
for select
to authenticated
using (
  id = auth.uid()

  or exists (
    select 1
    from public.restaurant_memberships my_membership
    join public.restaurant_memberships other_membership
      on other_membership.restaurant_id = my_membership.restaurant_id
    where my_membership.profile_id = auth.uid()
      and other_membership.profile_id = profiles.id
  )
);


-- =========================================================
-- UPDATE
-- A user can update only their own profile.
--
-- This applies to both owners and viewers because personal
-- profile information belongs to the user, not the restaurant.
-- =========================================================

create policy "Users can update own profile"
on public.profiles
for update
to authenticated
using (
  id = auth.uid()
)
with check (
  id = auth.uid()
);