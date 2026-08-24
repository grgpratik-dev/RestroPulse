-- =========================================================
-- Restaurant Memberships
-- Links users (profiles) to a restaurant and assigns
-- their role inside that restaurant.
--
-- Business rules:
--   - One restaurant can have many users.
--   - A restaurant can have only one owner.
--   - A restaurant can have multiple viewers.
--   - A user can belong to only one restaurant.
-- =========================================================

create table public.restaurant_memberships (
  id uuid primary key default gen_random_uuid(),

  -- Restaurant this membership belongs to.
  -- If the restaurant is deleted, its memberships
  -- are deleted automatically.
  restaurant_id uuid not null
    references public.restaurants(id)
    on delete cascade,

  -- User/profile linked to the restaurant.
  -- If the user account is deleted, their membership
  -- is removed automatically.
  profile_id uuid not null
    references public.profiles(id)
    on delete cascade,

  -- Role of the user within the restaurant.
  role public.restaurant_role not null,

  created_at timestamptz not null default now(),

  -- A user can belong to only one restaurant.
  -- This also creates an index on profile_id automatically.
  constraint restaurant_memberships_unique_profile
    unique (profile_id)
);


-- =========================================================
-- Ensure that each restaurant can have only one owner.
--
-- This is a partial unique index:
-- it only applies to rows where role = 'owner'.
-- Multiple viewer rows are still allowed.
-- =========================================================

create unique index restaurant_memberships_one_owner_per_restaurant_idx
  on public.restaurant_memberships (restaurant_id)
  where role = 'owner';


-- =========================================================
-- Improves lookups for all users belonging to a restaurant.
-- =========================================================

create index restaurant_memberships_restaurant_id_idx
  on public.restaurant_memberships (restaurant_id);