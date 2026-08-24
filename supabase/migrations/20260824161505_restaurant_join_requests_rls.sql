-- =========================================================
-- Restaurant Join Requests RLS
--
-- Access rules:
--   - A user who does not yet belong to a restaurant can
--     submit a join request.
--   - Users can read their own join requests.
--   - Restaurant owners can read requests sent to their
--     restaurant.
--   - Viewers cannot process join requests.
--   - Approval/decline will be handled later through a
--     controlled database function.
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
-- INSERT
--
-- A user can submit a join request only when:
--   - the request belongs to their own profile
--   - they do not already belong to a restaurant
--   - the request starts with status = pending
--   - review fields have not already been filled
--
-- Duplicate pending requests to the same restaurant are
-- already prevented by our partial unique index.
-- =========================================================

create policy "Users without restaurant can create join requests"
on public.restaurant_join_requests
for insert
to authenticated
with check (
  requester_profile_id = auth.uid()

  and public.current_user_restaurant_id() is null

  and status = 'pending'

  and reviewed_by_profile_id is null

  and reviewed_at is null
);