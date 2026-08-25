-- =========================================================
-- RLS: Restaurant Join Codes
--
-- Security model:
--   - Only the restaurant owner can directly read the code.
--   - Viewers cannot read or manage join codes.
--   - Outsiders cannot list or inspect join codes.
--   - Direct INSERT / UPDATE / DELETE is intentionally blocked.
--   - Code generation, regeneration, disabling, and resolving
--     will be handled through controlled RPC functions.
-- =========================================================

alter table public.restaurant_join_codes
enable row level security;


-- =========================================================
-- SELECT
--
-- Owner can read the join-code row for their own restaurant.
-- =========================================================

create policy restaurant_join_codes_select_owner
on public.restaurant_join_codes
for select
to authenticated
using (
  restaurant_id = public.current_user_restaurant_id()
  and public.is_restaurant_owner()
);


-- =========================================================
-- No INSERT policy
-- No UPDATE policy
-- No DELETE policy
--
-- These operations will only be performed through
-- security-definer functions.
-- =========================================================
