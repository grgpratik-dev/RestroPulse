-- A caller can read their own restaurant's members. Only its owner receives
-- invitation codes, account emails, and pending applicants. Account emails
-- let owners identify OTP users who have not supplied a display name yet.
create or replace function public.get_restaurant_members_access()
returns jsonb
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_restaurant_id uuid;
  v_is_owner boolean;
begin
  if auth.uid() is null then
    raise exception 'Authentication required' using errcode = '42501';
  end if;
  select restaurant_id, role = 'owner'
  into v_restaurant_id, v_is_owner
  from public.restaurant_memberships where profile_id = auth.uid();
  if not found then
    raise exception 'Restaurant membership required' using errcode = '42501';
  end if;
  return jsonb_build_object(
    'restaurant_name', (select name from public.restaurants where id = v_restaurant_id),
    'is_owner', v_is_owner,
    'join_code', case when v_is_owner then (
      select code from public.restaurant_join_codes
      where restaurant_id = v_restaurant_id and is_active
    ) else null end,
    'members', coalesce((
      select jsonb_agg(jsonb_build_object(
        'id', m.profile_id, 'name', coalesce(nullif(trim(p.full_name), ''), 'Unnamed member'), 'role', m.role,
        'email', case when v_is_owner then u.email else null end
      ) order by m.role, m.created_at, m.profile_id)
      from public.restaurant_memberships m join public.profiles p on p.id = m.profile_id
      join auth.users u on u.id = p.id
      where m.restaurant_id = v_restaurant_id
    ), '[]'::jsonb),
    'requests', case when v_is_owner then coalesce((
      select jsonb_agg(jsonb_build_object(
        'id', jr.id, 'name', coalesce(nullif(trim(p.full_name), ''), 'Unnamed applicant'), 'role', 'viewer', 'email', u.email
      ) order by jr.created_at, jr.id)
      from public.restaurant_join_requests jr join public.profiles p on p.id = jr.requester_profile_id
      join auth.users u on u.id = p.id
      where jr.restaurant_id = v_restaurant_id and jr.status = 'pending'
    ), '[]'::jsonb) else '[]'::jsonb end
  );
end;
$$;
revoke all on function public.get_restaurant_members_access() from public;
grant execute on function public.get_restaurant_members_access() to authenticated;
