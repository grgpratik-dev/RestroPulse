-- =========================================================
-- User Devices RLS
--
-- Device registrations are personal to each authenticated
-- user and are not restaurant-scoped.
--
-- Access rules:
--   - A user can read only their own device registrations.
--   - A user can register only devices for their own profile.
--   - A user can update only their own device registrations.
--   - A user can delete only their own device registrations.
-- =========================================================

alter table public.user_devices
enable row level security;


-- =========================================================
-- SELECT
-- Users can read only their own device registrations.
-- =========================================================

create policy "Users can read own devices"
on public.user_devices
for select
to authenticated
using (
  profile_id = auth.uid()
);


-- =========================================================
-- INSERT
-- Users can register a device only for themselves.
-- =========================================================

create policy "Users can create own devices"
on public.user_devices
for insert
to authenticated
with check (
  profile_id = auth.uid()
);


-- =========================================================
-- UPDATE
-- Users can update only their own device registrations.
--
-- WITH CHECK prevents changing profile_id to another user.
-- =========================================================

create policy "Users can update own devices"
on public.user_devices
for update
to authenticated
using (
  profile_id = auth.uid()
)
with check (
  profile_id = auth.uid()
);


-- =========================================================
-- DELETE
-- Users can remove only their own device registrations.
-- =========================================================

create policy "Users can delete own devices"
on public.user_devices
for delete
to authenticated
using (
  profile_id = auth.uid()
);