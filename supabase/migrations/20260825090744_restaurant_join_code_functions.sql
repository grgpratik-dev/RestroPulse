-- =========================================================
-- Restaurant Join Code Functions
--
-- Provides the controlled workflow for:
--
--   1. Owner generates / regenerates a join code
--   2. Owner disables the join code
--   3. User resolves a valid code to preview restaurant
--   4. User requests Viewer access using the code
--
-- Join codes are never directly created or modified
-- by the Flutter client.
-- =========================================================


-- =========================================================
-- Generate / Regenerate Restaurant Join Code
--
-- Creates a code if none exists.
--
-- If the restaurant already has a code, the same row
-- is updated with a new code and re-enabled.
--
-- Example:
--   RP-A84F2C
--
-- Only the restaurant owner may perform this action.
-- =========================================================

create or replace function public.generate_restaurant_join_code()
returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user_id uuid;
  v_restaurant_id uuid;

  v_code text;
  v_attempt integer := 0;

begin

  -- =======================================================
  -- Authentication
  -- =======================================================

  v_user_id := auth.uid();

  if v_user_id is null then
    raise exception 'Authentication required';
  end if;


  -- =======================================================
  -- Find restaurant owned by caller.
  -- =======================================================

  select rm.restaurant_id
  into v_restaurant_id
  from public.restaurant_memberships rm
  where rm.profile_id = v_user_id
    and rm.role = 'owner';

  if not found then
    raise exception 'Only a restaurant owner can manage join codes';
  end if;


  -- =======================================================
  -- Generate a unique human-readable code.
  --
  -- A unique constraint also exists on the code column.
  -- The loop handles the extremely unlikely case where
  -- two generated codes collide.
  -- =======================================================

  loop

    v_attempt := v_attempt + 1;

    v_code :=
      'RP-' ||
      upper(
        substring(
          replace(gen_random_uuid()::text, '-', '')
          from 1
          for 6
        )
      );


    begin

      -- One row exists per restaurant.
      --
      -- If the restaurant already has a code,
      -- regenerate it and activate it again.

      insert into public.restaurant_join_codes (
        restaurant_id,
        code,
        is_active
      )
      values (
        v_restaurant_id,
        v_code,
        true
      )

      on conflict (restaurant_id)
      do update
      set
        code = excluded.code,
        is_active = true,
        updated_at = now();

      return v_code;


    exception
      when unique_violation then

        -- Extremely unlikely code collision with another
        -- restaurant. Generate another code and retry.

        if v_attempt >= 10 then
          raise exception 'Unable to generate unique restaurant join code';
        end if;

    end;

  end loop;

end;
$$;


-- =========================================================
-- Permissions
-- =========================================================

revoke all
on function public.generate_restaurant_join_code()
from public;

grant execute
on function public.generate_restaurant_join_code()
to authenticated;



-- =========================================================
-- Disable Restaurant Join Code
--
-- Keeps the join-code record but prevents it from being
-- used until the owner generates/regenerates a code again.
--
-- Only the restaurant owner may perform this action.
-- =========================================================

create or replace function public.disable_restaurant_join_code()
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user_id uuid;
  v_restaurant_id uuid;

begin

  -- =======================================================
  -- Authentication
  -- =======================================================

  v_user_id := auth.uid();

  if v_user_id is null then
    raise exception 'Authentication required';
  end if;


  -- =======================================================
  -- Find restaurant owned by caller.
  -- =======================================================

  select rm.restaurant_id
  into v_restaurant_id
  from public.restaurant_memberships rm
  where rm.profile_id = v_user_id
    and rm.role = 'owner';

  if not found then
    raise exception 'Only a restaurant owner can manage join codes';
  end if;


  -- =======================================================
  -- Disable current code.
  -- =======================================================

  update public.restaurant_join_codes
  set is_active = false
  where restaurant_id = v_restaurant_id;


  if not found then
    raise exception 'Restaurant does not have a join code';
  end if;

end;
$$;


-- =========================================================
-- Permissions
-- =========================================================

revoke all
on function public.disable_restaurant_join_code()
from public;

grant execute
on function public.disable_restaurant_join_code()
to authenticated;



-- =========================================================
-- Resolve Restaurant Join Code
--
-- Allows an authenticated user to enter a join code and
-- receive only the limited restaurant information needed
-- for the confirmation/preview screen.
--
-- It does NOT expose the restaurant table directly.
--
-- Invalid, disabled, or inactive-restaurant codes simply
-- return no rows.
-- =========================================================

create or replace function public.resolve_restaurant_join_code(
  p_code text
)
returns table (
  restaurant_id uuid,
  restaurant_name varchar,
  address text,
  logo_path varchar
)
language sql
stable
security definer
set search_path = public
as $$

  select
    r.id,
    r.name,
    r.address,
    r.logo_path

  from public.restaurant_join_codes jc

  join public.restaurants r
    on r.id = jc.restaurant_id

  where upper(trim(jc.code)) = upper(trim(p_code))
    and jc.is_active = true
    and r.is_active = true

  limit 1;

$$;


-- =========================================================
-- Permissions
-- =========================================================

revoke all
on function public.resolve_restaurant_join_code(text)
from public;

grant execute
on function public.resolve_restaurant_join_code(text)
to authenticated;



-- =========================================================
-- Request Restaurant Access By Join Code
--
-- Creates a pending Viewer join request.
--
-- Flow:
--
--   User enters code
--       ↓
--   Code is validated
--       ↓
--   Pending restaurant_join_requests row is created
--       ↓
--   Restaurant owner receives notification
--       ↓
--   Owner approves / declines using existing functions
--
-- The user is NOT immediately added as a Viewer.
-- =========================================================

create or replace function public.request_restaurant_join_by_code(
  p_code text
)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user_id uuid;

  v_restaurant_id uuid;
  v_restaurant_name varchar;

  v_owner_profile_id uuid;

  v_request_id uuid;

begin

  -- =======================================================
  -- Authentication
  -- =======================================================

  v_user_id := auth.uid();

  if v_user_id is null then
    raise exception 'Authentication required';
  end if;


  -- =======================================================
  -- User must not already belong to a restaurant.
  -- =======================================================

  if exists (
    select 1
    from public.restaurant_memberships rm
    where rm.profile_id = v_user_id
  ) then

    raise exception 'User already belongs to a restaurant';

  end if;


  -- =======================================================
  -- Resolve and lock the join-code row.
  --
  -- Locking prevents the code from being regenerated or
  -- disabled in the middle of this request operation.
  -- =======================================================

  select
    jc.restaurant_id,
    r.name
  into
    v_restaurant_id,
    v_restaurant_name

  from public.restaurant_join_codes jc

  join public.restaurants r
    on r.id = jc.restaurant_id

  where upper(trim(jc.code)) = upper(trim(p_code))
    and jc.is_active = true
    and r.is_active = true

  for update of jc;


  if not found then
    raise exception 'Invalid or inactive restaurant join code';
  end if;


  -- =======================================================
  -- If this user already has a pending request for this
  -- restaurant, return the existing request.
  --
  -- This makes repeated button taps safe.
  -- =======================================================

  select jr.id
  into v_request_id

  from public.restaurant_join_requests jr

  where jr.restaurant_id = v_restaurant_id
    and jr.requester_profile_id = v_user_id
    and jr.status = 'pending';


  if found then
    return v_request_id;
  end if;


  -- =======================================================
  -- Find current restaurant owner.
  --
  -- The owner receives the join-request notification.
  -- =======================================================

  select rm.profile_id
  into v_owner_profile_id

  from public.restaurant_memberships rm

  where rm.restaurant_id = v_restaurant_id
    and rm.role = 'owner';


  if not found then
    raise exception 'Restaurant does not currently have an owner';
  end if;


  -- =======================================================
  -- Create pending join request.
  -- =======================================================

  insert into public.restaurant_join_requests (
    restaurant_id,
    requester_profile_id,
    status
  )
  values (
    v_restaurant_id,
    v_user_id,
    'pending'
  )
  returning id into v_request_id;


  -- =======================================================
  -- Notify restaurant owner.
  -- =======================================================

  insert into public.notifications (
    recipient_profile_id,
    restaurant_id,
    type,
    title,
    message,
    related_entity_type,
    related_entity_id
  )
  values (
    v_owner_profile_id,
    v_restaurant_id,
    'join_request_received',
    'New join request',
    format(
      'A user requested viewer access to %s.',
      v_restaurant_name
    ),
    'restaurant_join_request',
    v_request_id
  );


  return v_request_id;

end;
$$;


-- =========================================================
-- Permissions
-- =========================================================

revoke all
on function public.request_restaurant_join_by_code(text)
from public;

grant execute
on function public.request_restaurant_join_by_code(text)
to authenticated;



-- =========================================================
-- Tighten Join Request Direct Access
--
-- Join requests should now be created through the
-- join-code RPC rather than direct table INSERT from Flutter.
--
-- SELECT remains available and is restricted by RLS.
--
-- Approval / decline are already handled by controlled RPCs.
-- =========================================================

revoke insert, update, delete
on public.restaurant_join_requests
from authenticated;

grant select
on public.restaurant_join_requests
to authenticated;


-- =========================================================
-- Approve Join Request
--
-- Approves a pending restaurant join request and creates
-- the requester as a viewer member of that restaurant.
--
-- Rules:
--   - Caller must be authenticated.
--   - Caller must be the owner of the target restaurant.
--   - Request must still be pending.
--   - Requester must not already belong to a restaurant.
--   - Membership creation + request approval happen together.
-- =========================================================

create or replace function public.approve_join_request(
  p_request_id uuid
)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_owner_id uuid;
  v_restaurant_id uuid;
  v_requester_id uuid;
  v_status public.join_request_status;
begin
  -- Currently authenticated user.
  v_owner_id := auth.uid();

  if v_owner_id is null then
    raise exception 'Authentication required';
  end if;


  -- Load and lock the join request so it cannot be processed
  -- simultaneously by another transaction.
  select
    restaurant_id,
    requester_profile_id,
    status
  into
    v_restaurant_id,
    v_requester_id,
    v_status
  from public.restaurant_join_requests
  where id = p_request_id
  for update;


  -- Request must exist.
  if not found then
    raise exception 'Join request not found';
  end if;


  -- Only pending requests can be approved.
  if v_status <> 'pending' then
    raise exception 'Join request has already been processed';
  end if;


  -- Caller must own the restaurant receiving this request.
  if not exists (
    select 1
    from public.restaurant_memberships rm
    where rm.restaurant_id = v_restaurant_id
      and rm.profile_id = v_owner_id
      and rm.role = 'owner'
  ) then
    raise exception 'Only the restaurant owner can approve this request';
  end if;


  -- The requester must still be free to join a restaurant.
  if exists (
    select 1
    from public.restaurant_memberships rm
    where rm.profile_id = v_requester_id
  ) then
    raise exception 'Requester already belongs to a restaurant';
  end if;


  -- Create the viewer membership.
  insert into public.restaurant_memberships (
    restaurant_id,
    profile_id,
    role
  )
  values (
    v_restaurant_id,
    v_requester_id,
    'viewer'
  );


  -- Mark the request as approved.
  update public.restaurant_join_requests
  set
    status = 'approved',
    reviewed_by_profile_id = v_owner_id,
    reviewed_at = now()
  where id = p_request_id;


  -- Create an in-app notification for the requester.
  insert into public.notifications (
    recipient_profile_id,
    restaurant_id,
    type,
    title,
    message,
    related_entity_type,
    related_entity_id
  )
  values (
    v_requester_id,
    v_restaurant_id,
    'join_request_approved',
    'Join request approved',
    'Your request to join the restaurant has been approved.',
    'restaurant_join_request',
    p_request_id
  );
end;
$$;


-- Only authenticated users can invoke the function.
-- Internal checks still ensure only the correct owner succeeds.
revoke all
on function public.approve_join_request(uuid)
from public;

grant execute
on function public.approve_join_request(uuid)
to authenticated;


-- =========================================================
-- Decline Join Request
--
-- Declines a pending restaurant join request.
--
-- Rules:
--   - Caller must be authenticated.
--   - Caller must be the owner of the target restaurant.
--   - Request must still be pending.
--   - No membership is created.
--   - Request status and review metadata are updated together.
-- =========================================================

create or replace function public.decline_join_request(
  p_request_id uuid
)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_owner_id uuid;
  v_restaurant_id uuid;
  v_requester_id uuid;
  v_status public.join_request_status;
begin
  -- Currently authenticated user.
  v_owner_id := auth.uid();

  if v_owner_id is null then
    raise exception 'Authentication required';
  end if;


  -- Load and lock the request so it cannot be processed
  -- simultaneously by another transaction.
  select
    restaurant_id,
    requester_profile_id,
    status
  into
    v_restaurant_id,
    v_requester_id,
    v_status
  from public.restaurant_join_requests
  where id = p_request_id
  for update;


  -- Request must exist.
  if not found then
    raise exception 'Join request not found';
  end if;


  -- Only pending requests can be declined.
  if v_status <> 'pending' then
    raise exception 'Join request has already been processed';
  end if;


  -- Caller must own the restaurant receiving this request.
  if not exists (
    select 1
    from public.restaurant_memberships rm
    where rm.restaurant_id = v_restaurant_id
      and rm.profile_id = v_owner_id
      and rm.role = 'owner'
  ) then
    raise exception 'Only the restaurant owner can decline this request';
  end if;


  -- Mark the request as declined.
  update public.restaurant_join_requests
  set
    status = 'declined',
    reviewed_by_profile_id = v_owner_id,
    reviewed_at = now()
  where id = p_request_id;


  -- Notify the requester.
  insert into public.notifications (
    recipient_profile_id,
    restaurant_id,
    type,
    title,
    message,
    related_entity_type,
    related_entity_id
  )
  values (
    v_requester_id,
    v_restaurant_id,
    'join_request_declined',
    'Join request declined',
    'Your request to join the restaurant was declined.',
    'restaurant_join_request',
    p_request_id
  );
end;
$$;


-- Only authenticated users may invoke the function.
-- Internal validation still ensures only the correct
-- restaurant owner can successfully decline the request.
revoke all
on function public.decline_join_request(uuid)
from public;

grant execute
on function public.decline_join_request(uuid)
to authenticated;

