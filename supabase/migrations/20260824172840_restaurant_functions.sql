-- =========================================================
-- Restaurant Functions
--
-- Controlled business operations that should not be done
-- through direct client INSERT/UPDATE statements.
-- =========================================================


-- =========================================================
-- Create Restaurant
--
-- Creates:
--   1. A new restaurant
--   2. The owner's membership
--
-- Both operations happen inside one database function, so
-- we never create a restaurant without an owner.
--
-- Rules:
--   - User must be authenticated.
--   - User must not already belong to a restaurant.
--   - The creator automatically becomes the owner.
-- =========================================================

create or replace function public.create_restaurant(
  p_name varchar,
  p_timezone varchar,

  p_description text default null,
  p_phone varchar default null,
  p_email varchar default null,
  p_address text default null,
  p_logo_path varchar default null
)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user_id uuid;
  v_restaurant_id uuid;

begin

  -- Get the currently authenticated user's UUID.
  v_user_id := auth.uid();

  -- The function must only be called by an authenticated user.
  if v_user_id is null then
    raise exception 'Authentication required';
  end if;


  -- A user can belong to only one restaurant.
  if exists (
    select 1
    from public.restaurant_memberships rm
    where rm.profile_id = v_user_id
  ) then
    raise exception 'User already belongs to a restaurant';
  end if;


  -- Restaurant name is required.
  if p_name is null or btrim(p_name) = '' then
    raise exception 'Restaurant name is required';
  end if;


  -- Restaurant timezone is required.
  if p_timezone is null or btrim(p_timezone) = '' then
    raise exception 'Restaurant timezone is required';
  end if;


  -- Validate that the supplied timezone is a real
  -- PostgreSQL/IANA timezone name.
  --
  -- Examples:
  --   Asia/Kathmandu
  --   Europe/London
  --   America/Toronto
  if not exists (
    select 1
    from pg_timezone_names
    where name = btrim(p_timezone)
  ) then
    raise exception 'Invalid restaurant timezone';
  end if;


  -- Create the restaurant.
  insert into public.restaurants (
    name,
    timezone,
    description,
    phone,
    email,
    address,
    logo_path
  )
  values (
    btrim(p_name),
    btrim(p_timezone),
    p_description,
    p_phone,
    p_email,
    p_address,
    p_logo_path
  )
  returning id into v_restaurant_id;


  -- Automatically create the owner membership.
  insert into public.restaurant_memberships (
    restaurant_id,
    profile_id,
    role
  )
  values (
    v_restaurant_id,
    v_user_id,
    'owner'
  );


  -- Return the new restaurant ID to the caller.
  return v_restaurant_id;

end;
$$;


-- =========================================================
-- Function permissions
--
-- Authenticated users may call the function.
-- The function itself performs the business-rule checks.
-- =========================================================

revoke all
on function public.create_restaurant(
  varchar,
  varchar,
  text,
  varchar,
  varchar,
  text,
  varchar
)
from public;


grant execute
on function public.create_restaurant(
  varchar,
  varchar,
  text,
  varchar,
  varchar,
  text,
  varchar
)
to authenticated;



-- =========================================================
-- Transfer Restaurant Ownership
--
-- Transfers ownership from the current owner to an
-- existing viewer in the same restaurant.
--
-- Rules:
--   - Caller must be authenticated.
--   - Caller must currently be the restaurant owner.
--   - Target user must already be a viewer in the same
--     restaurant.
--   - Ownership transfer happens atomically.
-- =========================================================

create or replace function public.transfer_restaurant_ownership(
  p_new_owner_profile_id uuid
)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_current_owner_id uuid;
  v_restaurant_id uuid;
  v_restaurant_name varchar;
begin
  -- Get the currently authenticated user.
  v_current_owner_id := auth.uid();

  if v_current_owner_id is null then
    raise exception 'Authentication required';
  end if;


  -- Lock and load the current owner's membership
  -- together with the restaurant name.
  select
    rm.restaurant_id,
    r.name
  into
    v_restaurant_id,
    v_restaurant_name
  from public.restaurant_memberships rm
  join public.restaurants r
    on r.id = rm.restaurant_id
  where rm.profile_id = v_current_owner_id
    and rm.role = 'owner'
  for update of rm;


  if not found then
    raise exception 'Only a restaurant owner can transfer ownership';
  end if;


  -- Ownership cannot be transferred to the current owner.
  if p_new_owner_profile_id = v_current_owner_id then
    raise exception 'User is already the restaurant owner';
  end if;


  -- Lock the target viewer membership and verify that
  -- the target belongs to the same restaurant.
  perform 1
  from public.restaurant_memberships rm
  where rm.restaurant_id = v_restaurant_id
    and rm.profile_id = p_new_owner_profile_id
    and rm.role = 'viewer'
  for update;


  if not found then
    raise exception 'New owner must be a viewer of this restaurant';
  end if;


  -- Demote the existing owner to viewer.
  update public.restaurant_memberships
  set role = 'viewer'
  where restaurant_id = v_restaurant_id
    and profile_id = v_current_owner_id;


  -- Promote the selected viewer to owner.
  update public.restaurant_memberships
  set role = 'owner'
  where restaurant_id = v_restaurant_id
    and profile_id = p_new_owner_profile_id;


  -- Notify the new owner and include the restaurant name
  -- so the notification is more meaningful.
  insert into public.notifications (
    recipient_profile_id,
    restaurant_id,
    type,
    title,
    message
  )
  values (
    p_new_owner_profile_id,
    v_restaurant_id,
    'ownership_transferred',
    'Restaurant ownership transferred',
    format(
      'You are now the owner of %s.',
      v_restaurant_name
    )
  );
end;
$$;


-- Only authenticated users can invoke this function.
revoke all
on function public.transfer_restaurant_ownership(uuid)
from public;

grant execute
on function public.transfer_restaurant_ownership(uuid)
to authenticated;


-- =========================================================
-- Remove Viewer
--
-- Removes an existing viewer from the owner's restaurant.
--
-- Rules:
--   - Caller must be authenticated.
--   - Caller must be the restaurant owner.
--   - Target user must currently be a viewer in the same
--     restaurant.
--   - Owners cannot be removed through this function.
--   - A notification is created for the removed viewer.
-- =========================================================

create or replace function public.remove_restaurant_viewer(
  p_viewer_profile_id uuid
)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_owner_id uuid;
  v_restaurant_id uuid;
  v_restaurant_name varchar;
begin
  -- Get the currently authenticated user.
  v_owner_id := auth.uid();

  if v_owner_id is null then
    raise exception 'Authentication required';
  end if;


  -- Load the restaurant owned by the current user
  -- together with its name.
  select
    rm.restaurant_id,
    r.name
  into
    v_restaurant_id,
    v_restaurant_name
  from public.restaurant_memberships rm
  join public.restaurants r
    on r.id = rm.restaurant_id
  where rm.profile_id = v_owner_id
    and rm.role = 'owner'
  for update of rm;


  if not found then
    raise exception 'Only a restaurant owner can remove viewers';
  end if;


  -- The target must currently be a viewer in the
  -- same restaurant.
  perform 1
  from public.restaurant_memberships rm
  where rm.restaurant_id = v_restaurant_id
    and rm.profile_id = p_viewer_profile_id
    and rm.role = 'viewer'
  for update;


  if not found then
    raise exception 'Viewer not found in this restaurant';
  end if;


  -- Remove the viewer membership.
  delete from public.restaurant_memberships
  where restaurant_id = v_restaurant_id
    and profile_id = p_viewer_profile_id
    and role = 'viewer';


  -- Notify the removed user.
  --
  -- The notification remains valid even though the user's
  -- restaurant membership has now been removed.
  insert into public.notifications (
    recipient_profile_id,
    restaurant_id,
    type,
    title,
    message
  )
  values (
    p_viewer_profile_id,
    v_restaurant_id,
    'viewer_removed',
    'Restaurant access removed',
    format(
      'Your access to %s has been removed.',
      v_restaurant_name
    )
  );
end;
$$;


-- Only authenticated users can invoke the function.
revoke all
on function public.remove_restaurant_viewer(uuid)
from public;

grant execute
on function public.remove_restaurant_viewer(uuid)
to authenticated;

-- =========================================================
-- Delete Restaurant
--
-- Permanently deletes the restaurant owned by the current
-- authenticated user.
--
-- Rules:
--   - Caller must be authenticated.
--   - Caller must currently be the restaurant owner.
--   - Restaurant deletion is explicit and destructive.
--   - Related restaurant-owned rows are removed through
--     their configured ON DELETE CASCADE relationships.
-- =========================================================

create or replace function public.delete_owned_restaurant()
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_owner_id uuid;
  v_restaurant_id uuid;
begin
  -- Get the currently authenticated user.
  v_owner_id := auth.uid();

  if v_owner_id is null then
    raise exception 'Authentication required';
  end if;


  -- Find and lock the restaurant membership owned
  -- by the current user.
  select rm.restaurant_id
  into v_restaurant_id
  from public.restaurant_memberships rm
  where rm.profile_id = v_owner_id
    and rm.role = 'owner'
  for update;


  if not found then
    raise exception 'Only a restaurant owner can delete a restaurant';
  end if;


  -- Delete the restaurant.
  --
  -- Related restaurant data is automatically cleaned up
  -- according to the foreign-key cascade rules defined
  -- throughout the schema.
  delete from public.restaurants
  where id = v_restaurant_id;
end;
$$;


-- Only authenticated users may invoke this function.
revoke all
on function public.delete_owned_restaurant()
from public;

grant execute
on function public.delete_owned_restaurant()
to authenticated;