-- =========================================================
-- Restaurant Join Requests
-- Stores requests from users who want to join a restaurant
-- as a viewer.
--
-- Business rules:
--   - A user can belong to only one restaurant.
--   - A pending request should not exist more than once
--     for the same user and restaurant.
--   - Only owners will later be allowed to approve or
--     decline requests through RLS/business logic.
-- =========================================================

create table public.restaurant_join_requests (
  id uuid primary key default gen_random_uuid(),

  -- Restaurant the user wants to join.
  restaurant_id uuid not null
    references public.restaurants(id)
    on delete cascade,

  -- User requesting access.
  requester_profile_id uuid not null
    references public.profiles(id)
    on delete cascade,

  -- Current state of the request.
  status public.join_request_status not null default 'pending',

  -- Optional profile of the owner who processed the request.
  -- Remains NULL while the request is pending.
  reviewed_by_profile_id uuid
    references public.profiles(id)
    on delete set null,

  -- Time when the owner approved or declined the request.
  reviewed_at timestamptz,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);


-- Automatically refresh updated_at when the request changes.
create trigger set_restaurant_join_requests_updated_at
before update on public.restaurant_join_requests
for each row
execute function public.set_updated_at();


-- =========================================================
-- Prevent duplicate pending requests.
--
-- A user cannot have two simultaneous pending requests
-- for the same restaurant.
--
-- Historical approved/declined requests can still remain.
-- =========================================================

create unique index restaurant_join_requests_unique_pending_idx
  on public.restaurant_join_requests (
    restaurant_id,
    requester_profile_id
  )
  where status = 'pending';


-- =========================================================
-- Indexes for common lookups.
-- =========================================================

-- Used when an owner loads pending requests for a restaurant.
create index restaurant_join_requests_restaurant_id_idx
  on public.restaurant_join_requests (restaurant_id);

-- Used when checking a user's request history/status.
create index restaurant_join_requests_requester_idx
  on public.restaurant_join_requests (requester_profile_id);