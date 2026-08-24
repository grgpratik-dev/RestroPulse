-- =========================================================
-- Notifications RLS
--
-- Notifications are personal to the recipient.
--
-- Access rules:
--   - A user can read only notifications addressed to them.
--   - Normal client users cannot directly insert, update,
--     or delete notification rows.
--   - State changes such as marking a notification as read
--     happen through controlled database functions.
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