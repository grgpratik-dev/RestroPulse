-- =========================================================
-- RLS Helper Functions
-- Shared helper functions used by Row Level Security
-- policies throughout RestroPulse.
--
-- These functions determine:
--   - which restaurant the current user belongs to
--   - which role the current user has
--   - whether the current user is the restaurant owner
-- =========================================================


-- =========================================================
-- Returns the restaurant_id for the currently authenticated
-- user.
--
-- Because RestroPulse currently allows one profile to belong
-- to only one restaurant, this returns a single UUID.
--
-- Returns NULL if the user has no restaurant membership.
-- =========================================================

create or replace function public.current_user_restaurant_id()
returns uuid
language sql
stable
security definer
set search_path = public
as $$
  select rm.restaurant_id
  from public.restaurant_memberships rm
  where rm.profile_id = auth.uid()
  limit 1;
$$;


-- =========================================================
-- Returns the current user's role inside their restaurant.
--
-- Possible values:
--   owner
--   viewer
--
-- Returns NULL if the user has no membership.
-- =========================================================

create or replace function public.current_user_restaurant_role()
returns public.restaurant_role
language sql
stable
security definer
set search_path = public
as $$
  select rm.role
  from public.restaurant_memberships rm
  where rm.profile_id = auth.uid()
  limit 1;
$$;


-- =========================================================
-- Returns TRUE if the currently authenticated user is the
-- owner of their restaurant.
--
-- Returns FALSE if:
--   - the user is a viewer
--   - the user has no restaurant membership
-- =========================================================

create or replace function public.is_restaurant_owner()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.restaurant_memberships rm
    where rm.profile_id = auth.uid()
      and rm.role = 'owner'
  );
$$;