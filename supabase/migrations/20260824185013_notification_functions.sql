-- =========================================================
-- Notification Functions
--
-- Controlled operations for notification state changes.
-- =========================================================


-- =========================================================
-- Mark Notification As Read
--
-- Rules:
--   - Caller must be authenticated.
--   - Notification must belong to the current user.
--   - Only is_read is changed.
-- =========================================================

create or replace function public.mark_notification_read(
  p_notification_id uuid
)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user_id uuid;
begin
  -- Get the currently authenticated user.
  v_user_id := auth.uid();

  if v_user_id is null then
    raise exception 'Authentication required';
  end if;


  -- Update only the notification that belongs to
  -- the currently authenticated recipient.
  update public.notifications
  set is_read = true
  where id = p_notification_id
    and recipient_profile_id = v_user_id;


  -- If nothing matched, either:
  --   - the notification does not exist, or
  --   - it belongs to another user.
  --
  -- We intentionally expose the same error for both cases.
  if not found then
    raise exception 'Notification not found';
  end if;
end;
$$;


-- Only authenticated users may invoke the function.
revoke all
on function public.mark_notification_read(uuid)
from public;

grant execute
on function public.mark_notification_read(uuid)
to authenticated;