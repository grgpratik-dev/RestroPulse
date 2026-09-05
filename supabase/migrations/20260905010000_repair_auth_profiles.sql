-- Existing auth users may predate the profile creation trigger. Memberships
-- reference profiles, so those accounts cannot create or join a restaurant.
begin;

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, full_name)
  values (new.id, new.raw_user_meta_data ->> 'full_name')
  on conflict (id) do nothing;
  return new;
end;
$$;

-- Reinstall atomically so both upgraded and fresh databases have the trigger.
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_new_user();

-- Preserve existing profile data; create only missing profiles.
insert into public.profiles (id, full_name)
select id, raw_user_meta_data ->> 'full_name'
from auth.users
on conflict (id) do nothing;

commit;
