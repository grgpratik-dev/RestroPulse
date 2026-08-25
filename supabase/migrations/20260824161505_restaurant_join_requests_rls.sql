-- =========================================================
-- Restaurant Join Requests RLS
--
-- Access rules:
--   - Users can read their own join requests.
--   - Restaurant owners can read requests sent to their
--     restaurant.
--   - Viewers cannot process join requests.
--   - Join requests are created only through the
--     request_restaurant_join_by_code() function.
--   - Approval/decline are handled through controlled
--     database functions.
-- =========================================================


-- Enable Row Level Security.

alter table public.restaurant_join_requests
enable row level security;



-- =========================================================
-- SELECT
--
-- A join request can be read by:
--   1. The user who submitted it.
--   2. The owner of the restaurant receiving the request.
-- =========================================================

create policy "Users and owners can read relevant join requests"

on public.restaurant_join_requests

for select

to authenticated

using (

  -- Requester can see their own request.
  requester_profile_id = auth.uid()

  or

  -- Restaurant owner can see requests sent to
  -- their own restaurant.
  (
    restaurant_id = public.current_user_restaurant_id()
    and public.is_restaurant_owner()
  )

);


-- =========================================================
-- No direct INSERT / UPDATE / DELETE policies.
--
-- Join request creation:
--   request_restaurant_join_by_code()
--
-- Approval:
--   approve_join_request()
--
-- Decline:
--   decline_join_request()
--
-- This prevents Flutter from bypassing the join-code
-- workflow by inserting a restaurant_id directly.
-- =========================================================