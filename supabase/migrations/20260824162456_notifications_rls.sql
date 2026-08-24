-- =========================================================
-- Notifications RLS
--
-- Notifications are personal to the recipient.
--
-- Access rules:
--   - A user can read only notifications addressed to them.
--   - A user can update only their own notifications.
--   - Normal client users cannot create notifications.
--   - Normal client users cannot delete notifications.
--
-- Notification creation will later happen through trusted
-- backend/database logic when events occur.
-- =========================================================

alter table public.notifications
enable row level security;


-- =========================================================
-- SELECT
-- Users can read only their own notifications.
-- =========================================================

create policy "Users can read own notifications"
on public.notifications
for select
to authenticated
using (
  recipient_profile_id = auth.uid()
);


-- =========================================================
-- UPDATE
-- Users can update only notifications addressed to them.
--
-- This is primarily intended for actions such as
-- marking a notification as read.
--
-- WITH CHECK prevents changing the recipient to another user.
-- =========================================================

create policy "Users can update own notifications"
on public.notifications
for update
to authenticated
using (
  recipient_profile_id = auth.uid()
)
with check (
  recipient_profile_id = auth.uid()
);